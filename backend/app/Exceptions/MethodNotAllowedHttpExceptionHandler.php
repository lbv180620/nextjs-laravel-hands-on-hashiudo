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
            return response()->httpError(status: $e->getStatusCode(), message: $e->getMessage());
        }

        return null;
    }
}
