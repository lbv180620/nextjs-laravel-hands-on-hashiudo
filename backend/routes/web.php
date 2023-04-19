<?php

use App\Http\Controllers\LoginController;
use App\Http\Controllers\RegisterController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::post('/login', [LoginController::class, 'login'])->name('login');

Route::prefix('login')->name('login.')->group(function () {
    Route::get('/{provider}', [LoginController::class, 'redirectToProvider'])
        ->where('provider',  'google')
        ->name('{provider}');
    Route::get('/{provider}/callback', [LoginController::class, 'handleProviderCallback'])
        ->where('provider', 'google')
        ->name('{provider}.callback');
});

// Route::prefix('register')->name('register.')->group(function () {
//     Route::get('/{provider}', [RegisterController::class, 'registeredProviderUser'])
//         ->where('provider', 'google')
//         ->name('{provider}');
// });
