<?php

declare(strict_types=1);

namespace App\Http\ErrorEnums;

use Illuminate\Http\Response;

enum TestErrorEnum: string
{
    case Unauthorized = "ET4001";
    case InvalidFormData = "invalid format data";

    public function message(): string
    {
        return match ($this) {
            self::Unauthorized => '未ログインです',
            self::InvalidFormData => '不正な値が入力されています。',
        };
    }

    public function status(): int
    {
        return match ($this) {
            self::Unauthorized => Response::HTTP_UNAUTHORIZED,
            self::InvalidFormData => 422,
        };
    }

    public function details(): array
    {
        return match ($this) {
            self::Unauthorized => [],
            self::InvalidFormData => [
                'field' => 'name',
                'message' => 'The name field is required.',
            ]
        };
    }
}
