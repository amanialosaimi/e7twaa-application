<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\VolunteersController;


// تسجيل الدخول باستخدام Firebase
Route::post('/login', action: [VolunteersController::class, 'login']);

// تسجيل خروج المستخدم
Route::post('/logout', [AuthController::class, 'logout']);

// استرجاع بيانات المستخدم المسجل حاليًا
Route::get('/user', [AuthController::class, 'getUser']);

Route::post('/checkUser', [VolunteersController::class, 'checkUser']);

Route::middleware('auth:api')->post('/logout', [VolunteersController::class, 'logout']);
Route::middleware('auth:api')->get('/check-token', [VolunteersController::class, 'checkToken']);
Route::middleware('auth:api')->post('/check-in', [VolunteersController::class, 'checkIn']);
Route::middleware('auth:api')->post('/check-out', [VolunteersController::class, 'checkOut']);
