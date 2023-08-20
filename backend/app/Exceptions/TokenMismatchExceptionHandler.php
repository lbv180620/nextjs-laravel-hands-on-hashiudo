<?php

declare(strict_types=1);

namespace App\Exceptions;

use Illuminate\Http\Request;
use Illuminate\Session\TokenMismatchException;
use Throwable;

final class TokenMismatchExceptionHandler
{
    public function handle(Request $request, Throwable $e)
    {
        if ($request->is('api/*') || $request->is('login') || $request->is('login/*') || $request->is('logout') || $request->ajax()) {
            // Log::error('[API Error]' . $request->method() . ': ' . $request->fullUrl());

            if ($e instanceof TokenMismatchException) {
                return response()->httpError(status: $e->status, message: $e->getMessage());
            }
        }

        return null;
    }
}
