<?php

declare(strict_types=1);

namespace App\Http\Enums\SuccessEnums;

use App\Http\Enums\BaseEnumInterface;
use Illuminate\Http\Response;

enum AuthSuccessEnum: string implements BaseEnumInterface
{
    case LOGIN_SUCCESS = "ST2001";
    case LOGOUT_SUCCESS = "ST2002";
    case REDIRECT_URL_FETCH_SUCCESS = "ST2003";

    public function message(): string
    {
        return match ($this) {
            self::LOGIN_SUCCESS => 'ログインに成功しました。',
            self::LOGOUT_SUCCESS => 'ログアウトに成功しました。',
            self::REDIRECT_URL_FETCH_SUCCESS => 'プロバイダーへのリダイレクトURLの取得に成功しました。',
        };
    }

    public function code(): string
    {
        return match ($this) {
            self::LOGIN_SUCCESS => ucwords(strtolower(self::LOGIN_SUCCESS->name), '_'),
            self::LOGOUT_SUCCESS => ucwords(strtolower(self::LOGOUT_SUCCESS->name), '_'),
            self::REDIRECT_URL_FETCH_SUCCESS => ucwords(strtolower(self::REDIRECT_URL_FETCH_SUCCESS->name), '_'),
        };
    }

    public function status(): int
    {
        return match ($this) {
            self::LOGIN_SUCCESS => Response::HTTP_OK,
            self::LOGOUT_SUCCESS => Response::HTTP_OK,
            self::REDIRECT_URL_FETCH_SUCCESS => Response::HTTP_OK,
        };
    }

    public function data(?array $options): array
    {
        return match ($this) {
            self::LOGIN_SUCCESS => $options ?? [],
            self::LOGOUT_SUCCESS => [],
            self::REDIRECT_URL_FETCH_SUCCESS => $options ?? [],
        };
    }

    public function id(): string
    {
        return match ($this) {
            self::LOGIN_SUCCESS => self::LOGIN_SUCCESS->value,
            self::LOGOUT_SUCCESS => self::LOGOUT_SUCCESS->value,
            self::REDIRECT_URL_FETCH_SUCCESS => self::REDIRECT_URL_FETCH_SUCCESS->value,
        };
    }
}
