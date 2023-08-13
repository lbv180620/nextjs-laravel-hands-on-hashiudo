<?php

namespace App\Exceptions;

use Illuminate\Http\Request;
use Symfony\Component\Routing\Exception\MethodNotAllowedException;
use Throwable;

class MethodNotAllowedHttpExceptionHandler
{
    public function handle(Request $request, Throwable $e)
    {
        if ($e instanceof MethodNotAllowedException) {
            return response()->httpError(
                $e->getStatusCode(),
                $request->fullUrl(),
                $e->getMessage(),
            );
        }

        return null;
    }
}
