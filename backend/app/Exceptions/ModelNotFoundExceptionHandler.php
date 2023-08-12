<?php

namespace App\Exceptions;

use App\Http\Resources\ApiErrorResponseBodyResource;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Illuminate\Http\Response;

class ModelNotFoundExceptionHandler
{
    public function handle(ModelNotFoundException $e, Request $request)
    {
        return response()->json(
            new ApiErrorResponseBodyResource(
                $request->fullUrl(),
                'Not Found',
                'Not_Found',
            ),
            Response::HTTP_NOT_FOUND,
        );
    }
}
