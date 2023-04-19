<?php

namespace App\Http\Controllers;

use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\Request;
use Laravel\Socialite\Facades\Socialite;

class RegisterController extends Controller
{
    //
    public function registeredProviderUser(Request $request, string $provider)
    {
        $token = $request->token;

        $providerUser = Socialite::driver($provider)->userFromToken($token);

        $user = User::query()
            ->where('email', $providerUser->getEmail())
            ->first();

        return new UserResource($user);
    }
}
