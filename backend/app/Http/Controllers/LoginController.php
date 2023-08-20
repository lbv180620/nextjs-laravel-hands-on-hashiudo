<?php

declare(strict_types=1);

namespace App\Http\Controllers;

use App\Http\Enums\ErrorEnums\AuthErrorEnum;
use App\Http\Enums\SuccessEnums\AuthSuccessEnum;
use App\Http\Exceptions\AuthenticationException;
use App\Http\Exceptions\AuthException;
use App\Http\Requests\LoginRequest;
use Illuminate\Auth\AuthManager;
use Illuminate\Http\JsonResponse;

final class LoginController extends Controller
{
    /**
     * @param AuthManager $auth
     */
    public function __construct(private readonly AuthManager $auth)
    {
    }

    /**
     * ログイン処理
     *
     * @param LoginRequest $request
     * @return JsonResponse
     * @throws AuthenticationException
     */
    public function __invoke(LoginRequest $request): JsonResponse
    {
        $credentials = $request->only(['email', 'password']);

        // ログイン成功時
        if ($this->auth->guard()->attempt($credentials)) {
            $request->session()->regenerate();

            return response()->success(enum: AuthSuccessEnum::LOGIN_SUCCESS, options: ['id' => $request->user()->id]);
        }

        // ログイン失敗時のエラーメッセージ
        throw new AuthException(AuthErrorEnum::LOGIN_FAILED);
    }
}
