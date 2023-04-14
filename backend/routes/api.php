<?php

use App\Http\Controllers\Api\Auth\ForgotPasswordController;
use App\Http\Controllers\Api\Auth\ResetPasswordController;
use App\Http\Controllers\MemoController;
use App\Http\Resources\UserResource;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// メモ全件取得
Route::get('/memos', [MemoController::class, 'fetch'])->name('fetch');

Route::middleware(['throttle:relief'])->group(function () {
    // メモ登録
    Route::post('/memos', [MemoController::class, 'create'])->name('create');
});

// ログインユーザー取得
Route::get('/user', function () {
    $user = Auth::user();
    return $user ? new UserResource($user) : null;
});

// パスワードリセット
// [例1]
Route::post('/forgot-password', ForgotPasswordController::class)->name('password.forgot');
Route::post('/reset-password', ResetPasswordController::class)->name('password.reset');
// [例2]
// Route::post('password/request', [ForgotPasswordController::class, 'sendResetLinkEmail']); // パスワード再設定メール送信
// Route::post('password/reset', [ForgotPasswordController::class, 'resetPassword']); // パスワード再設定
