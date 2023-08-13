<?php

declare(strict_types=1);

namespace App\Exceptions;

use App\Http\Resources\ApiErrorResponseBodyResource;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpFoundation\Response as HttpResponse;
use Throwable;

final class ValidationExceptionHandler
{
    public function handle(Request $request, Throwable $e,)
    {
        if ($e instanceof ValidationException) {
            $code = HttpResponse::$statusTexts[$e->status];
            $message = $e->getMessage() ?: __($code);
            $errors = $e->errors();
            // Log::error($code);
            // Log::error($e->errors());

            $details = [];
            foreach ($errors as $field => $msgs) {
                foreach ($msgs as $msg) {
                    $details[] = [
                        'field' => $field,
                        'message' => $msg,
                    ];
                }
            }

            return response()->json(
                new ApiErrorResponseBodyResource(
                    $request->fullUrl(),
                    __($message),
                    str_replace(' ', '_', $code),
                    $details,
                ),
                $e->status
            );
        }

        return null;
    }
}
