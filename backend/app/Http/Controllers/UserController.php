<?php

namespace App\Http\Controllers;

use App\Http\Resources\UserResource;
use App\Models\User;
use Auth;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class UserController extends Controller
{
    /**
     * ユーザーの全件取得
     *
     * @return AnonymousResourceCollection
     */
    public function fetch(): AnonymousResourceCollection
    {
        // ログインユーザーのID取得
        $id = Auth::id();

        if (!$id) {
            throw new Exception('未ログインです。');
        }

        try {
            $users = User::select('*')->latest()->get();
        } catch (\Exception $ex) {
            throw $ex;
        }

        return UserResource::collection($users);
    }
}