<?php
//يحفظ بيانات المستخدم في Session بعد تسجيل الدخول
// يضيف logout() لمسح بيانات الجلسة عند تسجيل الخروج
//يضيف getUser() لاسترجاع بيانات المستخدم بدون الحاجة لإرسال التوكن مع كل طلب
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Services\FirebaseService;
use Illuminate\Support\Facades\Session;

class AuthController extends Controller
{
    protected $firebaseAuth;

    public function __construct()
    {
        $this->firebaseAuth = FirebaseService::getInstance()->getAuth();
    }

    public function login(Request $request)
    {
        $request->validate([
            'idToken' => 'required|string',
        ]);

        try {
            $verifiedIdToken = $this->firebaseAuth->verifyIdToken($request->idToken);
            $uid = $verifiedIdToken->claims()->get('sub');

            $user = $this->firebaseAuth->getUser($uid);

            // حفظ بيانات المستخدم في الجلسة
            Session::put('user', [
                'uid' => $user->uid,
                'email' => $user->email ?? null,
                'phone' => $user->phoneNumber ?? null,
                'name' => $user->displayName ?? null,
            ]);

            return response()->json([
                'message' => 'Login successful',
                'user' => Session::get('user'),
            ], 200);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Invalid token'], 401);
        }
    }

    public function logout()
    {
        Session::forget('user');
        return response()->json(['message' => 'Logout successful'], 200);
    }

    public function getUser()
    {
        if (Session::has('user')) {
            return response()->json(['user' => Session::get('user')], 200);
        }
        return response()->json(['error' => 'No user logged in'], 401);
    }
}
