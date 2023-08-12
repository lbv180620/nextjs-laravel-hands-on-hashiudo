<?php

namespace App\Exceptions;

use App\Http\Resources\ApiErrorResponseBodyResource;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response as HttpResponse;
use Symfony\Component\Routing\Exception\MethodNotAllowedException;
use Throwable;

class MethodNotAllowedHttpExceptionHandler
{
    public function handle(Throwable $e, Request $request)
    {
        if ($e instanceof MethodNotAllowedException) {
            $code = HttpResponse::$statusTexts[$e->getStatusCode()];
            $message = $e->getMessage() ?: __($code);

            return response()->json(
                new ApiErrorResponseBodyResource(
                    $request->fullUrl(),
                    $message,
                    str_replace(' ', '_', $code)
                ),
                $e->getStatusCode(),
            );
        }

        return null;
    }
}
