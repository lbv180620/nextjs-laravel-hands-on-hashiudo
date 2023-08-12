<?php

namespace App\Exceptions;

use App\Http\Resources\ApiErrorResponseBodyResource;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response as HttpResponse;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Throwable;

class NotFoundHttpExceptionHandler
{
    public function handle(Request $request, Throwable $e)
    {
        if ($e instanceof NotFoundHttpException) {
            $code = HttpResponse::$statusTexts[$e->getStatusCode()];
            $message = $e->getMessage() ?: __($code);
            // Log::error($code);

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
