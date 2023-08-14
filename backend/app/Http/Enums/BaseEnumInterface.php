<?php

namespace App\Http\Enums;

interface BaseEnumInterface
{
    public function status(): int;
    public function message(): string;
    public function code(): string;
    public function details(?array $options): array;
    public function id(): string;
}
