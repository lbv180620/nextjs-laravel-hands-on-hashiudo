<?php

declare(strict_types=1);

namespace App\Http\Controllers;

use App\Http\Enums\ErrorEnums\AuthErrorEnum;
use App\Http\Enums\SuccessEnums\AuthSuccessEnum;
use App\Http\Exceptions\AuthException;
use Illuminate\Auth\AuthManager;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class LogoutController extends Controller
{
    /**
     * @param AuthManager $auth
     */
    public function __construct(private readonly AuthManager $auth)
    {
    }

    /**
     * ログアウト処理
     *
     * @param Request $request
     * @return JsonResponse
     */
    public function __invoke(Request $request): JsonResponse
    {
        if ($this->auth->guard()->guest()) {
            return new AuthException(AuthErrorEnum::ALREADY_AUTHENTICATED);
        }

        $this->auth->guard()->logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return response()->success(enum: AuthSuccessEnum::LOGOUT_SUCCESS);
    }
}
