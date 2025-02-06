<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Kreait\Firebase\Factory;
use Kreait\Firebase\Auth;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    protected $firebaseAuth;

    public function __construct()
    {
        $firebase = (new Factory)
            ->withServiceAccount(config('firebase.credentials'));

        $this->firebaseAuth = $firebase->createAuth();
    }

    public function login(Request $request)
    {
        \Log::info('Login request data: ', $request->all());  // Log the incoming request data
    
        $request->validate([
            'email' => 'nullable|email',
            'phone' => 'nullable|string',
        ]);
    
        if (!$request->email && !$request->phone) {
            return response()->json(['error' => 'Email or phone number is required'], 400);
        }
    
        try {
            // Check if user exists in Firebase Authentication
            $user = null;
    
            if ($request->email) {
                $user = $this->firebaseAuth->getUserByEmail($request->email);
            } elseif ($request->phone) {
                $user = $this->firebaseAuth->getUserByPhoneNumber($request->phone);
            }
    
            if ($user) {
                // Check if the user exists in your Laravel users table
                $localUser = User::where('email', $user->email)->orWhere('phone', $user->phoneNumber)->first();
    
                if (!$localUser) {
                    // Create a new user in Laravel database
                    $localUser = User::create([
                        'name' => $user->displayName ?? 'User',
                        'email' => $user->email,
                        'phone' => $user->phoneNumber,
                        'password' => Hash::make('default_password'), // Change this based on your logic
                    ]);
                }
    
                // Generate Laravel JWT Token (if using Laravel Passport/Sanctum)
                $token = $localUser->createToken('authToken')->plainTextToken;
    
                return response()->json([
                    'message' => 'Login successful',
                    'token' => $token,
                    'user' => $localUser
                ]);
            }
    
            return response()->json(['error' => 'User not found in Firebase'], 404);
        } catch (\Exception $e) {
            \Log::error('Login error: ' . $e->getMessage());  // Log the error message
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }
    
}
