<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
Route::post('/login', action: [AuthController::class, 'login']);

Route::get('/get-csrf-token', function () {
    return csrf_token();  // This will return the CSRF token as a string.
});
