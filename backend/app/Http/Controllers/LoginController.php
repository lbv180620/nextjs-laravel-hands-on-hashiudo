<?php

namespace App\Http\Controllers;

use App\Http\Enums\SuccessEnums\AuthSuccessEnum;
use App\Http\Enums\TestErrorEnum;
use App\Http\Exceptions\TestException;
use App\Http\Requests\LoginRequest;
// use App\Http\Resources\UserResource;
use Illuminate\Http\JsonResponse;
// use Illuminate\Http\Request;
// use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Auth;
// use Illuminate\Validation\ValidationException;

class LoginController extends Controller
{
    /**
     * ログイン処理
     *
     * @param LoginRequest $request
     */
    public function login(LoginRequest $request): JsonResponse
    {
        // ログイン成功時
        if (Auth::attempt($request->all())) {
            $request->session()->regenerate();
            // return new UserResource(Auth::user());

            return response()->success(enum: AuthSuccessEnum::LOGIN_SUCCESS, url: $request->fullUrl(), options: ['id' => Auth::id()]);
        }

        // ログイン失敗時のエラーメッセージ
        // throw ValidationException::withMessages([
        //     'loginFailed' => 'IDまたはパスワードが間違っています。',
        // ]);
        throw new TestException(TestErrorEnum::LOGIN_FAILED);
    }
}
