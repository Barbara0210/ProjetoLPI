<?php

use App\Http\Controllers\DocsController;
use App\Http\Controllers\CompatibilidadeController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\AppointmentsController;

use Illuminate\Support\Facades\Route;
use SebastianBergmann\CodeCoverage\Report\Html\Dashboard;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});
Route::get('/doctors', [DocsController::class, 'listindex'])->name('doctors.index');
Route::get('/doctors/create', [DocsController::class, 'createUtente'])->name('doctors.create');
Route::post('/doctors', [DocsController::class, 'storeUtente'])->name('doctors.store');
Route::get('/doctors/{doctor}', [DocsController::class, 'show'])->name('doctors.show');
Route::get('/doctors/{doctor}/edit', [DocsController::class, 'edit'])->name('doctors.edit');
Route::put('/doctors/{doctor}', [DocsController::class, 'update'])->name('doctors.update');
Route::delete('/doctors/{doctor}', [DocsController::class, 'destroy'])->name('doctors.destroy');

Route::group(['middleware' => 'admin'], function () {
    // Rotas da dashboard de admin
});




Route::middleware([
    'auth:sanctum',
    config('jetstream.auth_session'),
    'verified',
])->group(function () {
    Route::get('/dashboard',[DashboardController::class, 'index']) ->name('dashboard');
});
