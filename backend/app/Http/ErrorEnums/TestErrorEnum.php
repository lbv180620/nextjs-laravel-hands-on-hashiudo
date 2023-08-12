<?php

declare(strict_types=1);

namespace App\Http\ErrorEnums;

use Illuminate\Http\Response;

enum TestErrorEnum: string
{
    case UNAUTHORIZED = "ET4001";
    case INVALID_FORMAT_DATA = "ET4002";

    public function message(): string
    {
        return match ($this) {
            self::UNAUTHORIZED => '未ログインです',
            self::INVALID_FORMAT_DATA => '不正な値が入力されています',
        };
    }

    public function code(): string
    {
        return match ($this) {
            self::UNAUTHORIZED => ucwords(strtolower(self::UNAUTHORIZED->name), '_'),
            self::INVALID_FORMAT_DATA => ucwords(strtolower(self::INVALID_FORMAT_DATA->name), '_'),
        };
    }

    public function status(): int
    {
        return match ($this) {
            self::UNAUTHORIZED => Response::HTTP_UNAUTHORIZED,
            self::INVALID_FORMAT_DATA => 422,
        };
    }

    public function details(): array
    {
        return match ($this) {
            self::UNAUTHORIZED => [],
            self::INVALID_FORMAT_DATA => [
                'field' => 'name',
                'message' => 'The name field is required.',
            ]
        };
    }
}
