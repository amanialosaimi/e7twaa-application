    <?php

    namespace App\Http\Controllers;

    use Illuminate\Http\Request;
    use Kreait\Firebase\Factory;
    use Google\Cloud\Firestore\FirestoreClient;
    use Firebase\JWT\JWT;
    use Firebase\JWT\Key;
    use Illuminate\Support\Facades\Config;
    use Firebase\JWT\ExpiredException;
    use Carbon\Carbon;

    class VolunteersController extends Controller
    {
        protected $firestore;

        public function __construct()
        {
            $factory = (new Factory)->withServiceAccount(storage_path('app/firebase/firebase_credentials.json'));
            $this->firestore = $factory->createFirestore()->database();
        }

        public function checkUser(Request $request)
        {
            $NationalID = trim($request->input('NationalID'));
            $phoneNumber = trim($request->input('PhoneNumber'));

            if (!$NationalID || !$phoneNumber) {
                return response()->json(['message' => 'NationalID and PhoneNumber are required'], 400);
            }

            try {
                $query = $this->firestore->collection('Volunteers')
                    ->where('NationalID', '=', $NationalID)
                    ->where('PhoneNumber', '=', $phoneNumber)
                    ->limit(1);

                $documents = $query->documents();

                foreach ($documents as $document) {
                    if ($document->exists()) {
                        return response()->json([
                            'message' => 'Volunteer exists',
                            'Volunteers' => $document->data()
                        ]);
                    }
                }

                return response()->json(['message' => 'User not found'], 404);
            } catch (\Exception $e) {
                return response()->json(['error' => 'Firestore error: ' . $e->getMessage()], 500);
            }
        }

        public function login(Request $request)
        {
            $NationalID = trim($request->input('NationalID'));
            $phoneNumber = trim($request->input('PhoneNumber'));

            if (!$NationalID || !$phoneNumber) {
                return response()->json(['message' => 'بيانات تسجيل الدخول غير صحيحة'], 401);
            }

            try {
                $query = $this->firestore->collection('Volunteers')
                    ->where('NationalID', '=', $NationalID)
                    ->where('PhoneNumber', '=', $phoneNumber)
                    ->limit(1);

                $documents = $query->documents();

                if ($documents->isEmpty()) {
                    return response()->json(['message' => 'بيانات تسجيل الدخول غير صحيحة'], 401);
                }

                $user = $documents->rows()[0];

                // التحقق من عدم حظر التوكن القديم
                $oldToken = $request->bearerToken();
                $blacklistedToken = $this->firestore->collection('BlacklistedTokens')->document($oldToken)->snapshot();
                if ($blacklistedToken->exists()) {
                    return response()->json(['message' => 'تم تسجيل الخروج، الرجاء تسجيل الدخول مجددًا'], 401);
                }

                $payload = [
                    'sub' => $user->id(),
                    'phoneNumber' => $user['PhoneNumber'],
                    'nationalID' => $user['NationalID'],
                    'iat' => time(),
                    'exp' => time() + (60 * 60 * 24 * 20), // التوكن صالح لمدة 7 أيام
                ];

                $jwtSecret = Config::get('app.jwt_secret');
                $token = JWT::encode($payload, $jwtSecret, 'HS256');

                return response()->json(['token' => $token, 'user' => $user->data()], 200);
            } catch (\Exception $e) {
                return response()->json(['message' => $e->getMessage()], 500);
            }
        }

        public function logout(Request $request)
        {
            $token = $request->bearerToken();

            if (!$token) {
                return response()->json(['message' => 'لم يتم إرسال التوكن'], 400);
            }

            try {
                $jwtSecret = Config::get('app.jwt_secret');
                JWT::decode($token, new Key($jwtSecret, 'HS256'));

                // حفظ التوكن المحظور في Firestore
                $this->firestore->collection('BlacklistedTokens')->document($token)->set([
                    'token' => $token,
                    'expires_at' => Carbon::now()->addWeek(),
                ]);

                return response()->json(['message' => 'تم تسجيل الخروج بنجاح'], 200);
            } catch (ExpiredException $e) {
                return response()->json(['message' => 'انتهت صلاحية التوكن، الرجاء تسجيل الدخول مجددًا'], 401);
            } catch (\Exception $e) {
                return response()->json(['message' => 'توكن غير صالح'], 401);
            }
        }

        public function checkToken(Request $request)
        {
            $token = $request->bearerToken();

            if (!$token) {
                return response()->json(['message' => 'توكن غير متوفر'], 400);
            }

            $blacklistedToken = $this->firestore->collection('BlacklistedTokens')->document($token)->snapshot();
            if ($blacklistedToken->exists()) {
                return response()->json(['message' => 'الجلسة منتهية، الرجاء تسجيل الدخول مرة أخرى'], 401);
            }

            return response()->json(['message' => 'التوكن صالح'], 200);
        }
        private function getUserFromToken(Request $request)
            {
                $token = $request->bearerToken();
                if (!$token) {
                    return null;
                }

                try {
                    $jwtSecret = Config::get('app.jwt_secret');
                    $decoded = JWT::decode($token, new Key($jwtSecret, 'HS256'));

                    $userRef = $this->firestore->collection('Volunteers')->document($decoded->sub)->snapshot();
                    if ($userRef->exists()) {
                        return ['id' => $decoded->sub, 'data' => $userRef->data()];
                    }

                    return null;
                } catch (ExpiredException $e) {
                    return null;
                } catch (\Exception $e) {
                    return null;
                }
            }

            public function checkIn(Request $request)
            {
                $user = $this->getUserFromToken($request);

                if (!$user) {
                    return response()->json(['message' => 'غير مصرح'], 401);
                }

                $now = Carbon::now();
                $workDate = $now->hour < 6 ? $now->subDay()->format('Y-m-d') : $now->format('Y-m-d');

                $attendanceRef = $this->firestore->collection('Attendance')->document("{$user['id']}-{$workDate}");
                $snapshot = $attendanceRef->snapshot();

                if ($snapshot->exists()) {
                    return response()->json(['message' => 'تم تسجيل الحضور مسبقًا'], 400);
                }

                // إضافة فلاغ يوضح أن التسجيل تم عبر التطبيق
                $attendanceRef->set([
                    'user_id' => $user['id'],
                    'login_time' => $now->toDateTimeString(),
                    'logout_time' => null,
                    'checked_in_app' => true, // ✅ هذا الفلاغ يشير إلى أن الحضور تم عبر التطبيق
                ]);

                return response()->json(['message' => 'تم تسجيل الحضور بنجاح', 'work_date' => $workDate], 201);
            }

            public function checkOut(Request $request)
            {
                $user = $this->getUserFromToken($request);

                if (!$user) {
                    return response()->json(['message' => 'غير مصرح'], 401);
                }

                $now = Carbon::now();
                $workDate = $now->hour < 6 ? $now->subDay()->format('Y-m-d') : $now->format('Y-m-d');

                $attendanceRef = $this->firestore->collection('Attendance')->document("{$user['id']}-{$workDate}");
                $snapshot = $attendanceRef->snapshot();

                if (!$snapshot->exists()) {
                    return response()->json(['message' => 'لم يتم تسجيل حضور لهذا اليوم'], 404);
                }

                if (!empty($snapshot->get('logout_time'))) {
                    return response()->json(['message' => 'تم تسجيل الانصراف مسبقًا'], 400);
                }

                $loginTime = Carbon::parse($snapshot->get('login_time'));
                $logoutTime = $now;
                $duration = $logoutTime->diff($loginTime);
                $formattedDuration = sprintf('%02d:%02d:%02d', $duration->h, $duration->i, $duration->s);

                $attendanceRef->update([
                    ['path' => 'logout_time', 'value' => $logoutTime->toDateTimeString()],
                    ['path' => 'work_duration', 'value' => $formattedDuration],
                ]);

                return response()->json([
                    'message' => 'تم تسجيل الانصراف بنجاح',
                    'work_duration' => $formattedDuration,
                    'work_date' => $workDate
                ], 200);
            }
    }
