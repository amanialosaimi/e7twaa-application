<?php

namespace App\Http\Controllers;

use Kreait\Firebase\Factory;
use Kreait\Firebase\Database;

class FirebaseController extends Controller
{
    private $database;

    public function __construct()
    {
        $firebase = (new Factory)
            ->withServiceAccount(storage_path('app/firebase/volunteersdata-cf17b-firebase-adminsdk-fbsvc-a5f56172ff.json'))
            ->withDatabaseUri('https://database-test-application-default-rtdb.firebaseio.com');

        $database = $firebase->createDatabase();


        $this->database = $firebase->createDatabase();
    }

}
