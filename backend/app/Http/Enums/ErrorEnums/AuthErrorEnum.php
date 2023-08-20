<?php

declare(strict_types=1);

namespace App\Http\Enums\ErrorEnums;

use App\Http\Enums\BaseEnumInterface;
use Illuminate\Http\Response;

enum AuthErrorEnum: string implements BaseEnumInterface
{
    case UNAUTHORIZED = "ET4001";
    case INVALID_FORMAT_DATA = "ET4002";
    case LOGIN_FAILED = "ET4003";
    case ALREADY_AUTHENTICATED = "ET4004";

    public function message(): string
    {
        return match ($this) {
            self::UNAUTHORIZED => '未ログインです。',
            self::INVALID_FORMAT_DATA => '不正な値が入力されています。',
            self::LOGIN_FAILED => 'IDまたはパスワードが間違っています。',
            self::ALREADY_AUTHENTICATED => 'すでにログアウトしています。'
        };
    }

    public function code(): string
    {
        return match ($this) {
            self::UNAUTHORIZED => ucwords(strtolower(self::UNAUTHORIZED->name), '_'),
            self::INVALID_FORMAT_DATA => ucwords(strtolower(self::INVALID_FORMAT_DATA->name), '_'),
            self::LOGIN_FAILED => ucwords(strtolower(self::LOGIN_FAILED->name), '_'),
            self::ALREADY_AUTHENTICATED => ucwords(strtolower(self::ALREADY_AUTHENTICATED->name), '_'),
        };
    }

    public function status(): int
    {
        return match ($this) {
            self::UNAUTHORIZED => Response::HTTP_UNAUTHORIZED,
            self::INVALID_FORMAT_DATA => Response::HTTP_UNPROCESSABLE_ENTITY,
            self::LOGIN_FAILED => Response::HTTP_UNAUTHORIZED,
            self::ALREADY_AUTHENTICATED => Response::HTTP_UNAUTHORIZED,
        };
    }

    public function details(?array $options): array
    {
        return match ($this) {
            self::UNAUTHORIZED => [],
            self::INVALID_FORMAT_DATA => [
                [
                    'field' => 'name',
                    'message' => 'The name field is required.',
                ],
            ],
            self::LOGIN_FAILED => [],
            self::ALREADY_AUTHENTICATED => [],
        };
    }

    public function id(): string
    {
        return match ($this) {
            self::UNAUTHORIZED => self::UNAUTHORIZED->value,
            self::INVALID_FORMAT_DATA => self::INVALID_FORMAT_DATA->value,
            self::LOGIN_FAILED => self::LOGIN_FAILED->value,
            self::ALREADY_AUTHENTICATED => self::ALREADY_AUTHENTICATED->value,
        };
    }
}
