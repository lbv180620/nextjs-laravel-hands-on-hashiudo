<?php

namespace App\Exceptions;

use App\Http\Resources\ApiErrorResponseBodyResource;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response as HttpResponse;
use Symfony\Component\HttpKernel\Exception\HttpException;

class HttpExceptionHandler
{
    public function handle(HttpException $e, Request $request)
    {
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
}
