<?php

namespace App\Exceptions;

use App\Http\Resources\ApiErrorResponseBodyResource;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Throwable;

class ModelNotFoundExceptionHandler
{
    public function handle(Throwable $e, Request $request)
    {
        if ($e instanceof ModelNotFoundException) {
            return response()->json(
                new ApiErrorResponseBodyResource(
                    $request->fullUrl(),
                    'Not Found',
                    'Not_Found',
                ),
                Response::HTTP_NOT_FOUND,
            );
        }

        return null;
    }
}
