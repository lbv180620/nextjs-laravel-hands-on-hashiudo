<?php

declare(strict_types=1);

namespace App\Exceptions;

use App\Http\Resources\ApiErrorResponseBodyResource;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Throwable;

final class ModelNotFoundExceptionHandler
{
    public function handle(Request $request, Throwable $e)
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
