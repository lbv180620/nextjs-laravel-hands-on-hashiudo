<?php

declare(strict_types=1);

namespace App\Exceptions;

use Illuminate\Http\Request;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Throwable;

final class NotFoundHttpExceptionHandler
{
    public function handle(Request $request, Throwable $e)
    {
        if ($e instanceof NotFoundHttpException) {
            return response()->httpError(status: $e->getStatusCode(), url: $request->fullUrl(), message: $e->getMessage());
        }

        return null;
    }
}
