<?php

declare(strict_types=1);

namespace App\Http\Exceptions;

use App\Http\ErrorEnums\TestErrorEnum;
use RuntimeException;

final class TestException extends RuntimeException
{
    protected TestErrorEnum $testErrorEnum;

    public function __construct(TestErrorEnum $testErrorEnum)
    {
        parent::__construct($testErrorEnum->message());

        $this->testErrorEnum = $testErrorEnum;
    }

    public function getErrorMessage(): string
    {
        return $this->testErrorEnum->message();
    }

    public function getErrorCode(): string
    {
        return $this->testErrorEnum->code();
    }

    public function getStatusCode(): int
    {
        return $this->testErrorEnum->status();
    }

    public function getErrorId(): string
    {
        return $this->testErrorEnum->value;
    }

    public function getDetails(): array
    {
        return $this->testErrorEnum->details();
    }
}