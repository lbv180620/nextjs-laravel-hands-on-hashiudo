<?php

declare(strict_types=1);

namespace App\Exceptions;

use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Throwable;

final class ValidationExceptionHandler
{
    public function handle(Request $request, Throwable $e,)
    {
        if ($request->is('api/*') || $request->is('login') || $request->is('login/*') || $request->is('logout') || $request->ajax()) {
            // Log::error('[API Error]' . $request->method() . ': ' . $request->fullUrl());

            if ($e instanceof ValidationException) {
                $errors = $e->errors();
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

                return response()->httpError(status: $e->status, message: $e->getMessage(), details: $details);
            }
        }

        return null;
    }
}
