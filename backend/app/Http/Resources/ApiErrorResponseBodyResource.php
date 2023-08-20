<?php

declare(strict_types=1);

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

final class ApiErrorResponseBodyResource extends JsonResource
{
    private int $status;
    private string $url;
    private string $message;
    private string $code;
    private string $id;
    private array $details;

    public function __construct(int $status, string $url, string $message, string $code, array $details = [], string $id = '')
    {
        $this->status = $status;
        $this->url = $url;
        $this->message = $message;
        $this->code = $code;
        $this->details = $details;
        $this->id = $id;
    }

    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        return [
            'error' => [
                'status' => $this->status,
                'url' => $this->url,
                'message' => $this->message,
                'code' => $this->code,
                'details' => $this->details,
                'id' => $this->id,
            ]
        ];
    }
}
