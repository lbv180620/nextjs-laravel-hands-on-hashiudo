<?php

declare(strict_types=1);

namespace App\Http\Enums\SuccessEnums;

use App\Http\Enums\BaseEnumInterface;
use Illuminate\Http\Response;

enum AuthSuccessEnum: string implements BaseEnumInterface
{
    case LOGIN_SUCCESS = "ST2001";

    public function message(): string
    {
        return match ($this) {
            self::LOGIN_SUCCESS => 'ログインに成功しました',
        };
    }

    public function code(): string
    {
        return match ($this) {
            self::LOGIN_SUCCESS => ucwords(strtolower(self::LOGIN_SUCCESS->name), '_'),
        };
    }

    public function status(): int
    {
        return match ($this) {
            self::LOGIN_SUCCESS => Response::HTTP_OK,
        };
    }

    public function details(?array $options): array
    {
        return match ($this) {
            self::LOGIN_SUCCESS => $options ? [
                'user_id' => $options['id'] ?? '',
            ] : [],
        };
    }

    public function id(): string
    {
        return match ($this) {
            self::LOGIN_SUCCESS => self::LOGIN_SUCCESS->value,
        };
    }
}
