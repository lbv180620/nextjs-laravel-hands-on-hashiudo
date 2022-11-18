<?php

use App\Http\Controllers\MemoController;
use App\Http\Controllers\UserController;
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
Route::get('/memos', [MemoController::class, 'fetch'])->name('memos.fetch');

Route::middleware(['throttle:relief'])->group(function () {
    // メモ登録
    Route::post('/memos', [MemoController::class, 'create'])->name('memos.create');
});

// ログインユーザー取得
Route::get('/user', function () {
    $user = Auth::user();
    return $user ? new UserResource($user) : null;
});

// ユーザー全件取得
Route::get('/users', [UserController::class, 'fetch'])->name('users.fetch');