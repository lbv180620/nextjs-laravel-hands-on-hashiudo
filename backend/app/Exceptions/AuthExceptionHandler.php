<?php

namespace App\Exceptions;

use App\Http\Exceptions\AuthException;
use Illuminate\Http\Request;
use Throwable;

class AuthExceptionHandler
{
    public function handle(Request $request, Throwable $e)
    {
        if ($request->is('api/*') || $request->is('login') || $request->is('login/*') || $request->is('logout') || $request->ajax()) {
            // Log::error('[API Error]' . $request->method() . ': ' . $request->fullUrl());

            if ($e instanceof AuthException) {
                return response()->error(enum: $e->getErrorEnum(), url: $request->fullUrl());
            }
        }

        return null;
    }
}
