<?php

declare(strict_types=1);

namespace App\Exceptions;

use App\Http\Resources\ApiErrorResponseBodyResource;
use Illuminate\Http\Request;
use Illuminate\Session\TokenMismatchException;
use Throwable;

final class TokenMismatchExceptionHandler
{
    public function handle(Request $request, Throwable $e)
    {
        if ($e instanceof TokenMismatchException) {
            return response()->json(
                new ApiErrorResponseBodyResource(
                    $request->fullUrl(),
                    __('CSRF Token Mismatch'),
                    'CSRF_Token_Mismatch'
                ),
                419,
            );
        }

        return null;
    }
}
