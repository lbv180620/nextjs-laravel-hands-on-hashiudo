<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class ApiSuccessResponseBodyResource extends JsonResource
{
    private string $url;
    private string $message;
    private string $code;
    private array $details;

    public function __construct(string $url, string $message, string $code, array $details = [])
    {
        $this->url = $url;
        $this->message = $message;
        $this->code = $code;
        $this->details = $details;
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
                'url' => $this->url,
                'message' => $this->message,
                'code' => $this->code,
                'details' => $this->details,
            ]
        ];
    }
}
