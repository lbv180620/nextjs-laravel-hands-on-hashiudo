<?php

namespace App\Http\Requests;

use App\Http\Resources\ApiErrorResponseBodyResource;
use App\Http\Responders\ApiErrorResponder;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\Exceptions\HttpResponseException;
use Illuminate\Http\Response;

abstract class ApiErrorResponseRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return false;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            //
        ];
    }

    protected function failedValidation(Validator $validator)
    {
        // dd($validator->errors());
        $response = response()->json(
            new ApiErrorResponseBodyResource(
                '',
                '',
                '',
                [
                    'fields' => $validator->errors()->toArray(),
                ],
            ),
            Response::HTTP_UNPROCESSABLE_ENTITY,
        );


        throw new HttpResponseException($response);
    }
}
