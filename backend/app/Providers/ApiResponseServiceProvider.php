<?php

declare(strict_types=1);

namespace App\Providers;

use App\Http\Enums\BaseEnumInterface;
use App\Http\Enums\ErrorEnums\TestErrorEnum;
use App\Http\Enums\SuccessEnums\AuthSuccessEnum;
use App\Http\Enums\SuccessEnums\MemoSuccessEnum;
use App\Http\Resources\ApiErrorResponseBodyResource;
use App\Http\Resources\ApiSuccessResponseBodyResource;
use Illuminate\Http\Response as HttpResponse;
use Illuminate\Support\Facades\Response;
use Illuminate\Support\ServiceProvider;
use Symfony\Component\HttpFoundation\Response as HttpFoundationResponse;

final class ApiResponseServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     *
     * @return void
     */
    public function register()
    {
        //
        $this->app->bind(BaseEnumInterface::class, AuthSuccessEnum::class);
        $this->app->bind(BaseEnumInterface::class, MemoSuccessEnum::class);
        $this->app->bind(BaseEnumInterface::class, TestErrorEnum::class);
    }

    /**
     * Bootstrap services.
     *
     * @return void
     */
    public function boot()
    {
        //
        Response::macro('success', function (BaseEnumInterface $enum, string $url = '', array $options = []) {
            $code = HttpFoundationResponse::$statusTexts[$enum->status()];
            $message = $enum->message() ?: __($code);

            return response()->json(
                new ApiSuccessResponseBodyResource(
                    $url,
                    $message,
                    $code,
                    $enum->details($options)
                ),
                $enum->status()
            );
        });

        Response::macro('httpError', function (int $status = HttpResponse::HTTP_BAD_REQUEST, string $url = '', string $message = '', $details = [], string $id = '') {
            $code = HttpFoundationResponse::$statusTexts[$status];
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

        // Response::macro('error', function (int $status = HttpResponse::HTTP_BAD_REQUEST, string $url = '', string $message, string $code, array $details = [], string $id = '') {
        Response::macro('error', function (BaseEnumInterface $enum, string $url = '', array $options = []) {
            return response()->json(
                new ApiErrorResponseBodyResource(
                    url: $url,
                    message: $enum->message(),
                    code: $enum->code(),
                    details: $enum->details($options),
                    id: $enum->id(),
                ),
                $enum->status(),
            );
        });
    }
}
