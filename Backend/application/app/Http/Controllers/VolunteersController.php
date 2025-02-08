<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Kreait\Firebase\Factory;
use Google\Cloud\Firestore\FirestoreClient;

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

}
