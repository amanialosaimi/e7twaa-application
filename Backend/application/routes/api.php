<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;

// تسجيل الدخول باستخدام Firebase
Route::post('/login', [AuthController::class, 'login']);

// تسجيل خروج المستخدم
Route::post('/logout', [AuthController::class, 'logout']);

// استرجاع بيانات المستخدم المسجل حاليًا
Route::get('/user', [AuthController::class, 'getUser']);
