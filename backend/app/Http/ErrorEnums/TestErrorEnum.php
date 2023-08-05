<?php

declare(strict_types=1);

namespace App\Http\ErrorEnums;

use Illuminate\Http\Response;

enum TestErrorEnum: string
{
    case UNAUTH = "unauthorized";

    public function message(): string
    {
        return match ($this) {
            self::UNAUTH => '未ログインです',
        };
    }

    public function status(): int
    {
        return match ($this) {
            self::UNAUTH => Response::HTTP_UNAUTHORIZED,
        };
    }

    public function details(): array
    {
        return match ($this) {
            self::UNAUTH => [
                'url' => 'aaaa',
                'field' => 'bbb',
            ]
        };
    }
}
