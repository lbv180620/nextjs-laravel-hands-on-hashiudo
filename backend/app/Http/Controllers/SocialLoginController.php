<?php

declare(strict_types=1);

namespace App\Http\Controllers;

use App\Http\Enums\SuccessEnums\AuthSuccessEnum;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Auth;
use Laravel\Socialite\Facades\Socialite;

final class SocialLoginController extends Controller
{
    public function redirectToProvider(string $provider)
    {
        $redirectUrl = Socialite::driver($provider)->redirect()->getTargetUrl();

        return response()->success(enum: AuthSuccessEnum::REDIRECT_URL_FETCH_SUCCESS, options: ['redirect_url' => $redirectUrl]);
    }

    public function handleProviderCallback(Request $request, string $provider)
    {
        try {
            $providerUser = Socialite::driver($provider)->stateless()->user();
        } catch (\Exception $e) {
            abort(500, $e->getMessage());
        }

        $user = User::query()
            ->where('email', $providerUser->getEmail())
            ->first();

        if ($user) {
            Auth::login($user, true);
            return redirect()->away(config('client.url') . '/memos', Response::HTTP_FOUND);
        }

        $user = User::create([
            'name' => $providerUser->getName(),
            'email' => $providerUser->getEmail(),
            'token' => $providerUser->token,
        ]);

        Auth::login($user, true);

        return redirect()->away(config('client.url') . '/memos', Response::HTTP_FOUND);
    }
}
