<?php

declare(strict_types=1);

namespace App\Providers;

use App\Exceptions\AuthExceptionHandler;
use App\Exceptions\HttpExceptionHandler;
use App\Exceptions\MethodNotAllowedHttpExceptionHandler;
use App\Exceptions\ModelNotFoundExceptionHandler;
use App\Exceptions\NotFoundHttpExceptionHandler;
use App\Exceptions\TestExceptionHandler;
use App\Exceptions\TokenMismatchExceptionHandler;
use App\Exceptions\ValidationExceptionHandler;
use Illuminate\Support\ServiceProvider;

final class HandlerServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     *
     * @return void
     */
    public function register()
    {
        //
        $this->app->bind(AuthExceptionHandler::class);
        $this->app->bind(HttpExceptionHandler::class);
        $this->app->bind(MethodNotAllowedHttpExceptionHandler::class);
        $this->app->bind(ModelNotFoundExceptionHandler::class);
        $this->app->bind(NotFoundHttpExceptionHandler::class);
        $this->app->bind(TokenMismatchExceptionHandler::class);
        $this->app->bind(TestExceptionHandler::class);
        $this->app->bind(ValidationExceptionHandler::class);
    }

    /**
     * Bootstrap services.
     *
     * @return void
     */
    public function boot()
    {
        //
    }
}
