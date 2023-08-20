<?php

declare(strict_types=1);

namespace App\Providers;

use App\Http\Enums\BaseEnumInterface;
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
        $this->app->bind(BaseEnumInterface::class, AuthenticationExceptionErrorEnum::class);
    }

    /**
     * Bootstrap services.
     *
     * @return void
     */
    public function boot()
    {
        //
        Response::macro('httpError', function (int $status = HttpResponse::HTTP_BAD_REQUEST, string $message = '', $details = [], string $id = '') {
            $code = HttpFoundationResponse::$statusTexts[$status];
            $message = $message ?: __($code);
            // Log::error($code);

            return response()->json(
                new ApiErrorResponseBodyResource(
                    status: $status,
                    message: __($message),
                    code: str_replace(' ', '_', $code),
                    details: $details,
                    id: $id,
                ),
                status: $status,
            );
        });

        Response::macro('error', function (BaseEnumInterface $enum, array $options = []) {
            return response()->json(
                new ApiErrorResponseBodyResource(
                    status: $enum->status(),
                    message: $enum->message(),
                    code: $enum->code(),
                    details: $enum->details($options),
                    id: $enum->id(),
                ),
                status: $enum->status(),
            );
        });

        Response::macro('success', function (BaseEnumInterface $enum, array $options = []) {
            $code = HttpFoundationResponse::$statusTexts[$enum->status()];
            $message = $enum->message() ?: __($code);

            return response()->json(
                new ApiSuccessResponseBodyResource(
                    status: $enum->status(),
                    message: $message,
                    code: $code,
                    data: $enum->data($options)
                ),
                status: $enum->status()
            );
        });
    }
}
