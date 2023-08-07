<?php

namespace App\Exceptions;

use App\Http\Exceptions\TestException;
use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use Illuminate\Http\Request;
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
                    $code = HttpResponse::$statusTexts[$e->getStatusCode()];
                    $message = $e->getMessage() ?: __($code);
                    // Log::error($code);

                    return response()->json([
                        'error' => [
                            'url' => $request->fullUrl(),
                            'message' => $message,
                            'code' => str_replace(' ', '', $code),
                            'id' => "",
                            'status' => $e->getStatusCode(),
                            'details' => [],
                        ]
                    ], $e->getStatusCode());
                }

                if ($e instanceof ValidationException) {
                    // Log::error($e->errors());

                    return $this->invalidJson($request, $e);
                }

                if ($e instanceof TestException) {
                    return response()->json([
                        'error' => [
                            'url' => $request->fullUrl(),
                            'message' => $e->getMessage(),
                            'code' => $e->getErrorCode(),
                            'id' => $e->getErrorId(),
                            'details' => $e->getDetails(),
                        ]
                    ], $e->getStatusCode());
                }

                return response()->json([
                    'error' => [
                        'url' => $request->fullUrl(),
                        'message' => __('Internal Server Error'),
                        'code' => 'InternalServerError',
                        'id' => "",
                        'details' => [],
                    ]
                ], 500);
            }
        });
    }
}
