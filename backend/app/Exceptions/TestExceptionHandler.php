<?php

namespace App\Exceptions;

use App\Http\Exceptions\TestException;
use Illuminate\Http\Request;
use Throwable;

class TestExceptionHandler
{
    public function handle(Request $request, Throwable $e)
    {
        if ($request->is('api/*') || $request->is('login') || $request->ajax()) {
            // Log::error('[API Error]' . $request->method() . ': ' . $request->fullUrl());

            if ($e instanceof TestException) {
                return response()->error(enum: $e->getErrorEnum(), url: $request->fullUrl());
            }
        }

        return null;
    }
}
