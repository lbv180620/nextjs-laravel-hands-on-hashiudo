<?php

namespace App\Exceptions;

use App\Http\Resources\ApiErrorResponseBodyResource;
use Illuminate\Http\Request;
use Illuminate\Session\TokenMismatchException;
use Throwable;

class TokenMismatchExceptionHandler
{
    public function handle(Throwable $e, Request $request)
    {
        if ($e instanceof TokenMismatchException) {
            return response()->json(
                new ApiErrorResponseBodyResource(
                    $request->fullUrl(),
                    __('CSRF Token Mismatch'),
                    'CSRF_Token_Mismatch'
                ),
                419
            );
        }

        return null;
    }
}
