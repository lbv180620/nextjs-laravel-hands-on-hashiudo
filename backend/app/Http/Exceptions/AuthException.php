<?php

declare(strict_types=1);

namespace App\Http\Exceptions;

use App\Http\Enums\ErrorEnums\AuthErrorEnum;
use RuntimeException;

final class AuthException extends RuntimeException
{
    protected AuthErrorEnum $testErrorEnum;

    public function __construct(AuthErrorEnum $testErrorEnum)
    {
        parent::__construct($testErrorEnum->message());

        $this->testErrorEnum = $testErrorEnum;
    }

    public function getErrorEnum(): AuthErrorEnum
    {
        return $this->testErrorEnum;
    }
}
