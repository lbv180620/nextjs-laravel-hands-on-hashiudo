<?php

declare(strict_types=1);

namespace App\Http\Enums\SuccessEnums;

use App\Http\Enums\BaseEnumInterface;
use Illuminate\Http\Response;

enum DataFetchSuccessEnum: string implements BaseEnumInterface
{
    case LOGIN_USER_FETCH_SUCCESS = "DF2001";

    public function message(): string
    {
        return match ($this) {
            self::LOGIN_USER_FETCH_SUCCESS => 'ログインユーザー情報の取得に成功しました。',
        };
    }

    public function code(): string
    {
        return match ($this) {
            self::LOGIN_USER_FETCH_SUCCESS => ucwords(strtolower(self::LOGIN_USER_FETCH_SUCCESS->name), '_'),
        };
    }

    public function status(): int
    {
        return match ($this) {
            self::LOGIN_USER_FETCH_SUCCESS => Response::HTTP_OK,
        };
    }

    public function data(?array $options): array
    {
        return match ($this) {
            self::LOGIN_USER_FETCH_SUCCESS => $options ?? [],
        };
    }

    public function id(): string
    {
        return match ($this) {
            self::LOGIN_USER_FETCH_SUCCESS => self::LOGIN_USER_FETCH_SUCCESS->value,
        };
    }
}
