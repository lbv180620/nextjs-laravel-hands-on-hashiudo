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
            $status = $e->getStatusCode();
            $url = $request->fullUrl();
            $message = $e->getMessage();

            return response()->httpError(...compact('status', 'url', 'message'));
        }

        return null;
    }
}
