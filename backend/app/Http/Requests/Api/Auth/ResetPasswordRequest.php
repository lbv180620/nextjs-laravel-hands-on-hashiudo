<?php

declare(strict_types=1);

namespace App\Http\Requests\Api\Auth;

use Illuminate\Foundation\Http\FormRequest;
// use Illuminate\Validation\Rules\Password;

class ResetPasswordRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
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
            'email' => ['required', 'email'],
            // 'password' => ['required', 'string', Password::min(8)->letters()->mixedCase()->numbers()->uncompromised()],
            'password' => ['required', 'string', 'min:6'],
            'token' => ['required', 'string']
        ];
    }
}
