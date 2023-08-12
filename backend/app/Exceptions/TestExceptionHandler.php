<?php

namespace App\Exceptions;

use App\Http\Exceptions\TestException;
use App\Http\Resources\ApiErrorResponseBodyResource;
use Illuminate\Http\Request;
use Throwable;

class TestExceptionHandler
{
    public function handle(Request $request, Throwable $e)
    {
        if ($e instanceof TestException) {
            return response()->json(
                new ApiErrorResponseBodyResource(
                    $request->fullUrl(),
                    $e->getMessage(),
                    $e->getErrorCode(),
                    $e->getDetails(),
                    $e->getErrorId(),
                ),
                $e->getStatusCode(),
            );
        }

        return null;
    }
}
