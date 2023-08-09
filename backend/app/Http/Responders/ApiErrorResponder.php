<?php

declare(strict_types=1);

namespace App\Http\Responders;

use App\Http\Resources\ApiErrorResource;
use Illuminate\Contracts\Support\Responsable;
use Illuminate\Http\JsonResponse;
use Polidog\ObjectToArray\ToArrayTrait;

final class ApiErrorResponder implements Responsable
{
    use ToArrayTrait;

    private string $url;
    private string $message;
    private string $code;
    private string $id;
    private array $details;
    private int $statusCode;

    public function __construct(string $url, string $message, string $code, string $id, array $details, int $statusCode = 400)
    {
        $this->url = $url;
        $this->message = $message;
        $this->code = $code;
        $this->id = $id;
        $this->details = $details;
        $this->statusCode = $statusCode;
    }

    public function toResponse($request): JsonResponse
    {
        return new JsonResponse(
            new ApiErrorResource($this->__toArray()),
            $this->statusCode
        );
    }
}
