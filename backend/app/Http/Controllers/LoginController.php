<?php

namespace App\Http\Controllers;

use App\Http\Requests\LoginRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException as ValidationValidationException;

class LoginController extends Controller
{
    /**
     * ログイン処理
     *
     * @param LoginRequest $request
     * @return JsonResource
     */
    public function login(LoginRequest $request): JsonResource
    {
        // ログイン成功時
        if (Auth::attempt($request->all())) {
            $request->session()->regenerate();
            return new UserResource(Auth::user());
        }

        // ログイン失敗時のエラーメッセージ
        throw ValidationValidationException::withMessages([
            'loginFailed' => 'IDまたはパスワードが間違っています。',
        ]);
    }

    /**
     * ユーザーの全件取得
     *
     */
    // public function fetch()
    // {
    //     // ログインユーザーのID取得
    //     $id = Auth::id();

    //     if (!$id) {
    //         throw new Exception('未ログインです。');
    //     }

    //     try {
    //         $users = User::select('*')->latest()->get();
    //     } catch (\Exception $ex) {
    //         throw $ex;
    //     }

    //     return UserResource::collection($users);
    // }
}