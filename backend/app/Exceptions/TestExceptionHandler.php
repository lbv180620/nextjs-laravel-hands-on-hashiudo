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
                $status = $e->getStatusCode();
                $url = $request->fullUrl();
                $message = $e->getMessage();
                $code = $e->getErrorCode();
                $details = $e->getDetails();
                $id = $e->getErrorId();

                return response()->error(...compact('status', 'url', 'message', 'code', 'details', 'id'));
            }
        }

        return null;
    }
}
