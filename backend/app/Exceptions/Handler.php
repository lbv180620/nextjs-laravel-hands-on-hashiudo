<?php

namespace App\Exceptions;

use App\Http\Exceptions\TestException;
use App\Http\Responders\ApiErrorResponder;
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

                    return new ApiErrorResponder(
                        $request->fullUrl(),
                        $message,
                        str_replace(' ', '', $code),
                        "",
                        [],
                        $e->getStatusCode(),
                    );
                }

                if ($e instanceof ValidationException) {
                    // Log::error($e->errors());

                    return $this->invalidJson($request, $e);
                }

                if ($e instanceof TestException) {
                    return new ApiErrorResponder(
                        $request->fullUrl(),
                        $e->getMessage(),
                        $e->getErrorCode(),
                        $e->getErrorId(),
                        $e->getDetails(),
                        $e->getStatusCode(),
                    );
                }

                return new ApiErrorResponder(
                    $request->fullUrl(),
                    __('Internal Server Error'),
                    'InternalServerError',
                    'InternalServerError',
                    [],
                    500,
                );
            }
        });
    }
}
