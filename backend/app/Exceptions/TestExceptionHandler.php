<?php

namespace App\Exceptions;

use App\Http\Exceptions\TestException;
use App\Http\Resources\ApiErrorResponseBodyResource;
use Illuminate\Http\Request;

class TestExceptionHandler
{
    public function handle(TestException $e, Request $request)
    {
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
}
