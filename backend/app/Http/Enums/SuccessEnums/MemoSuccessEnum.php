<?php

declare(strict_types=1);

namespace App\Http\Enums\SuccessEnums;

use App\Http\Enums\BaseEnumInterface;
use App\Models\Memo;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Response;

enum MemoSuccessEnum: string implements BaseEnumInterface
{
    case MEMO_POST_SUCCESS = "ST2001";

    public function message(): string
    {
        return match ($this) {
            self::MEMO_POST_SUCCESS => '',
        };
    }

    public function code(): string
    {
        return match ($this) {
            self::MEMO_POST_SUCCESS => ucwords(strtolower(self::MEMO_POST_SUCCESS->name), '_'),
        };
    }

    public function status(): int
    {
        return match ($this) {
            self::MEMO_POST_SUCCESS => Response::HTTP_CREATED,
        };
    }

    public function details(?array $options): array
    {
        return match ($this) {
            self::MEMO_POST_SUCCESS => $options ? [
                'memo_id' => $options['id'] ?? '',
            ] : [],
        };
    }

    public function id(): string
    {
        return match ($this) {
            self::MEMO_POST_SUCCESS => self::MEMO_POST_SUCCESS->value,
        };
    }
}
