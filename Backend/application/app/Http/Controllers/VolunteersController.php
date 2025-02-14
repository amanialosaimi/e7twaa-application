<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Kreait\Firebase\Factory;
use Google\Cloud\Firestore\FirestoreClient;
use Firebase\JWT\JWT;
use Firebase\JWT\ExpiredException;
class VolunteersController extends Controller
{
   
    protected $firestore;
    protected $database;

    public function __construct()
    {
        $factory = (new Factory)
            ->withServiceAccount(storage_path('app/firebase/firebase_credentials.json'));

        $this->firestore = $factory->createFirestore()->database();
        $this->database = $factory->createDatabase();
    }

    public function checkUser(Request $request)
    {
        $NationalID = $request->input('NationalID');
        $phoneNumber = $request->input('PhoneNumber');

        if (!$NationalID || !$phoneNumber) {
            return response()->json(['message' => 'NationalID and phoneNumber is required'], 400);
        }

        try {
            $projectId = env('GOOGLE_CLOUD_PROJECT');
            $firestore = new FirestoreClient([
                'projectId' => $projectId,
            ]);
            ini_set('max_execution_time', 60);

            $query = $firestore->collection('Volunteers')
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
            $projectId = env('GOOGLE_CLOUD_PROJECT');
            $firestore = new FirestoreClient([
                'projectId' => $projectId,
            ]);
            ini_set('max_execution_time', 60);

            $query = $firestore->collection('Volunteers')
                ->where('NationalID', '=', $NationalID)
                ->where('PhoneNumber', '=', $phoneNumber)
                ->limit(1);


            $documents = $query->documents();

            if ($documents->isEmpty()) {
                return response()->json(['message' => 'بيانات تسجيل الدخول غير صحيحة'], 401);
            }

            $user = $documents->rows()[0];
            
            // إنشاء التوكن باستخدام JWT مع صلاحية أسبوع
            $payload = [
                'sub' => $user->id(),
                'PhoneNumber' => $user['PhoneNumber'],
                'NationalID' => $user['NationalID'],
                'iat' => time(),
                'exp' => time() + (60 * 60 * 24 * 20), // صالح لمدة 7 أيام
            ];
            
            $token = JWT::encode($payload, env('JWT_SECRET'), 'HS256');
            
            return response()->json(['token' => $token, 'user' => $user->data()], 200);
        } catch (Exception $e) {
            return response()->json(['message' => $e->getMessage()], 500);
        }
    }

}
