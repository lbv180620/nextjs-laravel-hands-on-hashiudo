<?php

namespace App\Exceptions;

use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use Illuminate\Support\Facades\Log;
use Throwable;

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
    }

    public function render($request, Throwable $e)
    {

        $exceptionHandlers = [
            HttpExceptionHandler::class,
            ModelNotFoundExceptionHandler::class,
            MethodNotAllowedHttpExceptionHandler::class,
            NotFoundHttpExceptionHandler::class,
            TestExceptionHandler::class,
            TokenMismatchExceptionHandler::class,
            ValidationExceptionHandler::class,
        ];

        if ($request->is('api/*') || $request->is('login') || $request->ajax()) {
            // Log::error('[API Error]' . $request->method() . ': ' . $request->fullUrl());

            foreach ($exceptionHandlers as $handlerClass) {
                $handler = app($handlerClass);
                if ($handler->handle($request, $e)) {
                    return $handler->handle($request, $e);
                }
            }
        }


        return parent::render($request, $e);
    }
}
