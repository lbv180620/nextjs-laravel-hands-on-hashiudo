<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class ApiErrorResource extends JsonResource
{
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
                'url' => $this->resource['url'],
                'message' => $this->resource['message'],
                'code' => $this->resource['code'],
                'id' => $this->resource['id'],
                'details' => $this->resource['details'],
            ]
        ];
    }
}
