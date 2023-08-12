<?php

namespace App\Exceptions;

use App\Http\Exceptions\TestException;
use App\Http\Resources\ApiErrorResponseBodyResource;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Session\TokenMismatchException;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpFoundation\Response as HttpResponse;
use Throwable;
use Symfony\Component\HttpKernel\Exception\HttpException;
use Symfony\Component\HttpKernel\Exception\MethodNotAllowedHttpException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

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

            if ($request->is('api/*') || $request->is('login') || $request->ajax()) {
                // Log::error('[API Error]' . $request->method() . ': ' . $request->fullUrl());

                if ($e instanceof HttpException) {
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

                if ($e instanceof ValidationException) {
                    // Log::error($e->errors());

                    return $this->invalidJson($request, $e);
                }

                if ($e instanceof TestException) {
                    return response()->json(
                        new ApiErrorResponseBodyResource(
                            $request->fullUrl(),
                            $e->getMessage(),
                            $e->getErrorCode(),
                            $e->getErrorId(),
                            $e->getDetails(),
                        ),
                        $e->getStatusCode(),
                    );
                }

                return response()->json(
                    new ApiErrorResponseBodyResource(
                        $request->fullUrl(),
                        __('Internal Server Error'),
                        'Internal_Server_Error'
                    ),
                    Response::HTTP_INTERNAL_SERVER_ERROR
                );
            }
        });
    }

    public function render($request, Throwable $e)
    {
        if ($request->is('api/*') || $request->is('login') || $request->ajax()) {
            if ($e instanceof NotFoundHttpException) {
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

            if ($e instanceof MethodNotAllowedHttpException) {
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

            if ($e instanceof ModelNotFoundException) {
                return response()->json(
                    new ApiErrorResponseBodyResource(
                        $request->fullUrl(),
                        'Not Found',
                        'Not_Found',
                    ),
                    Response::HTTP_NOT_FOUND,
                );
            }

            if ($e instanceof TokenMismatchException || $e instanceof HttpException && $e->getStatusCode() === 419) {
                return response()->json(
                    new ApiErrorResponseBodyResource(
                        $request->fullUrl(),
                        __('CSRF Token Mismatch'),
                        'CSRF_Token_Mismatch'
                    ),
                    419
                );
            }
        }

        return parent::render($request, $e);
    }
}
