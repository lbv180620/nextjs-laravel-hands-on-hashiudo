<?php

namespace App\Exceptions;

use App\Http\Resources\ApiErrorResponseBodyResource;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpFoundation\Response as HttpResponse;
use Throwable;

class ValidationExceptionHandler
{
    public function handle(Request $request, Throwable $e,)
    {
        if ($e instanceof ValidationException) {
            $code = HttpResponse::$statusTexts[$e->status];
            $message = $e->getMessage() ?: __($code);
            // Log::error($code);
            // Log::error($e->errors());

            return response()->json(
                new ApiErrorResponseBodyResource(
                    $request->fullUrl(),
                    $message,
                    str_replace(' ', '_', $code),
                    [
                        'fields' => $e->errors()
                    ],
                ),
                $e->status
            );
        }

        return null;
    }
}
