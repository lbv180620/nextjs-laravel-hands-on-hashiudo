<?php

declare(strict_types=1);

namespace App\Exceptions;

use Illuminate\Http\Request;
use Symfony\Component\HttpKernel\Exception\HttpException;
use Throwable;

final class HttpExceptionHandler
{
    public function handle(Request $request, Throwable $e)
    {
        if ($e instanceof HttpException) {
            return response()->httpError(status: $e->getStatusCode(), url: $request->fullUrl(), message: $e->getMessage());
        }

        return null;
    }
}
