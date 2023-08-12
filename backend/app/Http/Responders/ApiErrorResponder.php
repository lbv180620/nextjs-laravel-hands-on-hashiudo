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
    private int $statusCode;
    private string $id;
    private array $details;

    public function __construct(string $url, string $message, string $code, int $statusCode = 400, string $id = '', array $details = [])
    {
        $this->url = $url;
        $this->message = $message;
        $this->code = $code;
        $this->statusCode = $statusCode;
        $this->id = $id;
        $this->details = $details;
    }

    public function toResponse($request): JsonResponse
    {
        return response()->json(
            new ApiErrorResource($this->__toArray()),
            $this->statusCode
        );
    }
}
