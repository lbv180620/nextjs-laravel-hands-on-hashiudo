<?php

declare(strict_types=1);

namespace App\Exceptions;

use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Throwable;

final class ModelNotFoundExceptionHandler
{
    public function handle(Request $request, Throwable $e)
    {
        if ($request->is('api/*') || $request->is('login') || $request->ajax()) {
            // Log::error('[API Error]' . $request->method() . ': ' . $request->fullUrl());

            if ($e instanceof ModelNotFoundException) {
                return response()->httpError(status: Response::HTTP_NOT_FOUND, url: $request->fullUrl());
            }
        }

        return null;
    }
}
