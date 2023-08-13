<?php

namespace App\Providers;

use App\Http\Resources\ApiErrorResponseBodyResource;
use App\Http\Resources\ApiSuccessResponseBodyResource;
use Illuminate\Support\Facades\Response;
use Illuminate\Support\ServiceProvider;
use Symfony\Component\HttpFoundation\Response as HttpResponse;

class ApiResponseServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     *
     * @return void
     */
    public function register()
    {
        //
    }

    /**
     * Bootstrap services.
     *
     * @return void
     */
    public function boot()
    {
        //
        Response::macro('success', function (int $status, string $url, array $details = []) {
            $code = HttpResponse::$statusTexts[$status];

            return response()->json(
                new ApiSuccessResponseBodyResource(
                    $url,
                    __($code),
                    $code,
                    $details
                ),
                $status
            );
        });

        Response::macro('httpError', function (int $status, string $url, string $message = '', $details = [], string $id = '') {
            $code = HttpResponse::$statusTexts[$status];
            $message = $message ?: __($code);
            // Log::error($code);

            return response()->json(
                new ApiErrorResponseBodyResource(
                    $url,
                    __($message),
                    str_replace(' ', '_', $code),
                    $details,
                    $id,
                ),
                $status,
            );
        });

        Response::macro('error', function (int $status, string $url, string $message, string $code, array $details = [], string $id = '') {
            return response()->json(
                new ApiErrorResponseBodyResource(
                    $url,
                    $message,
                    $code,
                    $details,
                    $id,
                ),
                $status,
            );
        });
    }
}
