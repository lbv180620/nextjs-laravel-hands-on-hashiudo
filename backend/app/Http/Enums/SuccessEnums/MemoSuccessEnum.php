<?php

declare(strict_types=1);

namespace App\Http\Enums\SuccessEnums;

use App\Http\Enums\BaseEnumInterface;
use Illuminate\Http\Response;

enum MemoSuccessEnum: string implements BaseEnumInterface
{
    case MEMO_CREATE_SUCCESS = "ST2001";
    case MEMO_LIST_FETCH_SUCCESS = "ST2002";

    public function message(): string
    {
        return match ($this) {
            self::MEMO_CREATE_SUCCESS => 'メモの新規登録に成功しました。',
            self::MEMO_LIST_FETCH_SUCCESS => 'メモの一覧取得に成功しました。',
        };
    }

    public function code(): string
    {
        return match ($this) {
            self::MEMO_CREATE_SUCCESS => ucwords(strtolower(self::MEMO_CREATE_SUCCESS->name), '_'),
            self::MEMO_LIST_FETCH_SUCCESS => ucwords(strtolower(self::MEMO_LIST_FETCH_SUCCESS->name), '_'),
        };
    }

    public function status(): int
    {
        return match ($this) {
            self::MEMO_CREATE_SUCCESS => Response::HTTP_CREATED,
            self::MEMO_LIST_FETCH_SUCCESS => Response::HTTP_OK,
        };
    }

    public function data(?array $options): array
    {
        return match ($this) {
            self::MEMO_CREATE_SUCCESS => $options ?? [],
            self::MEMO_LIST_FETCH_SUCCESS => $options ?? [],
        };
    }

    public function id(): string
    {
        return match ($this) {
            self::MEMO_CREATE_SUCCESS => self::MEMO_CREATE_SUCCESS->value,
            self::MEMO_LIST_FETCH_SUCCESS => self::MEMO_LIST_FETCH_SUCCESS->value,
        };
    }
}
