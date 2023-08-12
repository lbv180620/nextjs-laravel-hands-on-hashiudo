<?php

namespace App\Exceptions;

use App\Http\Exceptions\TestException;
use App\Http\Resources\ApiErrorResponseBodyResource;
use Illuminate\Http\Request;
use Throwable;

class TestExceptionHandler
{
    public function handle(Throwable $e, Request $request)
    {
        if ($e instanceof TestException) {
            return response()->json(
                new ApiErrorResponseBodyResource(
                    $request->fullUrl(),
                    $e->getMessage(),
                    $e->getErrorCode(),
                    $e->getErrorId(),
                    $e->getDetails(),
                ),
                $e->getStatusCode(),
            );
        }

        return null;
    }
}
