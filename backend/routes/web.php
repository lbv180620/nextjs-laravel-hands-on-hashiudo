<?php

use App\Http\Controllers\LoginController;
use App\Http\Controllers\LogoutController;
use App\Http\Controllers\SocialLoginController;
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

Route::post('/login', LoginController::class)->name('login');
Route::post('/logout', LogoutController::class)->name('logout');

Route::prefix('login')->name('login.')->group(function () {
    Route::get('/{provider}', [SocialLoginController::class, 'redirectToProvider'])
        ->where('provider',  'google')
        ->name('{provider}');
    Route::get('/{provider}/callback', [SocialLoginController::class, 'handleProviderCallback'])
        ->where('provider', 'google')
        ->name('{provider}.callback');
});
