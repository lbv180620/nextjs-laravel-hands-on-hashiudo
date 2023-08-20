<?php

declare(strict_types=1);

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

final class ApiSuccessResponseBodyResource extends JsonResource
{
    private int $status;
    private string $message;
    private string $code;
    private array $data;

    public function __construct(int $status, string $message, string $code, array $data = [])
    {
        $this->status = $status;
        $this->message = $message;
        $this->code = $code;
        $this->data = $data;
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
            'success' => [
                'status' => $this->status,
                'message' => $this->message,
                'code' => $this->code,
                'data' => $this->data,
            ]
        ];
    }
}
