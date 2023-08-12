<?php

namespace App\Exceptions;

use App\Http\Exceptions\TestException;
use App\Http\Resources\ApiErrorResponseBodyResource;
use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
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
    }

    public function render($request, Throwable $e)
    {
        $exceptionHandlers = [
            TestExceptionHandler::class,
            TokenMismatchExceptionHandler::class,
            ModelNotFoundExceptionHandler::class,
            MethodNotAllowedHttpExceptionHandler::class,
            NotFoundHttpExceptionHandler::class,
            HttpExceptionHandler::class,
        ];

        if ($request->is('api/*') || $request->is('login') || $request->ajax()) {
            foreach ($exceptionHandlers as $handlerClass) {
                $handler = app($handlerClass);
                if ($handler->handle($e, $request)) {
                    return $handler->handle($e, $request);
                }
            }
        }

        if ($e instanceof ValidationException) {
            // Log::error($e->errors());

            return $this->invalidJson($request, $e);
        }

        return parent::render($request, $e);
    }
}
