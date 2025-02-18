<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Kreait\Firebase\Factory;
use Google\Cloud\Firestore\FirestoreClient;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use Illuminate\Support\Facades\Hash;
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
        $NationalID = $request->input('NationalID');
        $phoneNumber = $request->input('PhoneNumber');

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
        $NationalID = $request->input('NationalID');
        $phoneNumber = $request->input('PhoneNumber');

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

            $payload = [
                'sub' => $user->id(),
                'PhoneNumber' => $user['PhoneNumber'],
                'NationalID' => $user['NationalID'],
                'iat' => time(),
                'exp' => time() + (60 * 60 * 24 * 7), // التوكن صالح لمدة 7 أيام
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
            $decoded = JWT::decode($token, new Key($jwtSecret, 'HS256'));

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

    public function getUserFromToken(Request $request)
    {
        $token = $request->bearerToken();

        if (!$token) {
            return null;
        }

        try {
            $jwtSecret = Config::get('app.jwt_secret');
            $decoded = JWT::decode($token, new Key($jwtSecret, 'HS256'));

            return (object) [
                'id' => $decoded->sub,
                'phone' => $decoded->PhoneNumber,
                'national_id' => $decoded->NationalID
            ];
        } catch (\Exception $e) {
            return null;
        }
    }
}
