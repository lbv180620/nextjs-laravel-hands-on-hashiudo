<?php

declare(strict_types=1);

namespace App\Http\ErrorEnums;

use Illuminate\Http\Response;

enum TestErrorEnum: string
{
    case UNAUTH = "unauthorized";
    case InvalidFormData = "invalid format data";

    public function message(): string
    {
        return match ($this) {
            self::UNAUTH => '未ログインです',
            self::InvalidFormData => '不正な値が入力されています。',
        };
    }

    public function status(): int
    {
        return match ($this) {
            self::UNAUTH => Response::HTTP_UNAUTHORIZED,
            self::InvalidFormData => 422,
        };
    }

    public function details(): array
    {
        return match ($this) {
            self::UNAUTH => [],
            self::InvalidFormData => [
                'field' => 'name',
                'message' => 'The name field is required.',
            ]
        };
    }
}
