<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\FirebaseController;
Route::get('/data', [FirebaseController::class, 'getData']);
