<?php

use App\Http\Controllers\Api\MeController;
use App\Http\Controllers\MemoController;
use App\Http\Resources\UserResource;
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

// Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//     return $request->user();
// });

Route::get('/me', MeController::class);
// Route::group(['middleware' => ['auth:sanctum']], function () {
// });

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
