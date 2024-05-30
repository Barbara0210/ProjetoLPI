<?php

use App\Http\Controllers\UsersController;
use App\Http\Controllers\AppointmentsController;
use App\Http\Controllers\DocsController;
use App\Http\Controllers\ReviewController;
use App\Models\Appointments;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

//this is the endpoint with prefix /api
Route::post('/login', [UsersController::class,'login']);
Route::post('/register', [UsersController::class,'register']);
//Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
   // return $request->user();
//});

//this group mean return users data if authenticated successfully
Route::middleware('auth:sanctum')->group(function(){
    Route::get('/user', [UsersController::class,'index']);
    Route::post('/fav', [UsersController::class,'storeFavDoc']);
    Route::post('/logout', [UsersController::class,'logout']);
    Route::post('/book',[AppointmentsController::class, 'store']);
    Route::post('/reviews',[AppointmentsController::class, 'storeReview']);
    Route::get('/appointments',[AppointmentsController::class, 'index']); //retrieve appointments
    Route::put('/appointments/{id}', [AppointmentsController::class, 'update']);
    Route::get('/reviews', [ReviewController::class, 'getReviewsByAppointment']);
    Route::put('/reviews/{id}', [ReviewController::class, 'updateReview']);
    Route::get('/doctors/{doctorId}/latest', [ReviewController::class, 'getLatestReview']);


});

