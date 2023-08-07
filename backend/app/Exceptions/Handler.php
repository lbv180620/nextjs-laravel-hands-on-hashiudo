<?php

namespace App\Exceptions;

use App\Http\Exceptions\TestException;
use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpFoundation\Response as HttpResponse;
use Throwable;
use Symfony\Component\HttpKernel\Exception\HttpException;

class Handler extends ExceptionHandler
{
    /**
     * A list of the exception types that are not reported.
     *
     * @var array<int, class-string<Throwable>>
     */
    protected $dontReport = [
        //
    ];

    /**
     * A list of the inputs that are never flashed for validation exceptions.
     *
     * @var array<int, string>
     */
    protected $dontFlash = [
        'current_password',
        'password',
        'password_confirmation',
    ];

    /**
     * Register the exception handling callbacks for the application.
     *
     * @return void
     */
    public function register()
    {
        $this->reportable(function (Throwable $e) {
            //
        });

        $this->renderable(function (Throwable $e, Request $request) {
            if ($request->is('api/*') || $request->ajax()) {
                // Log::error('[API Error]' . $request->method() . ': ' . $request->fullUrl());

                if ($e instanceof HttpException) {
                    $message = $e->getMessage() ?: HttpResponse::$statusTexts[$e->getStatusCode()];
                    // Log::error($message);

                    return response()->json([
                        'errors' => [
                            'message' => $message,
                            'code' => $e->getStatusCode(),
                            'details' => [],
                        ]
                        // 'message' => $message
                    ], $e->getStatusCode());
                }

                if ($e instanceof ValidationException) {
                    // Log::error($e->errors());

                    return $this->invalidJson($request, $e);
                }

                if ($e instanceof TestException) {
                    return new JsonResponse([
                        'errors' => [
                            'message' => $e->getMessage(),
                            'code' => $e->getErrorCode(),
                            'details' => $e->getDetails(),
                        ]
                    ], $e->getStatusCode());
                }

                // return response()->json([
                //     'message' => 'Internal Server Error'
                // ], 500);
            }
        });
    }
}
