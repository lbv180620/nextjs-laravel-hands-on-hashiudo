<?php

namespace App\Exceptions;

use App\Http\Resources\ApiErrorResponseBodyResource;
use Illuminate\Http\Request;
use Illuminate\Session\TokenMismatchException;

class TokenMismatchExceptionHandler
{
    public function handle(TokenMismatchException $e, Request $request)
    {
        return response()->json(
            new ApiErrorResponseBodyResource(
                $request->fullUrl(),
                __('CSRF Token Mismatch'),
                'CSRF_Token_Mismatch'
            ),
            419
        );
    }
}
