<?php

declare(strict_types=1);

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Laravel\Socialite\Facades\Socialite;

final class SocialLoginController extends Controller
{
    public function redirectToProvider(string $provider)
    {
        $redirectUrl = Socialite::driver($provider)->redirect()->getTargetUrl();

        return response()->json([
            'redirect_url' => $redirectUrl,
        ]);
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
            return redirect()->away(config('client.url') . '/memos');
        }

        $user = User::create([
            'name' => $providerUser->getName(),
            'email' => $providerUser->getEmail(),
            'token' => $providerUser->token,
        ]);

        Auth::login($user, true);

        return redirect()->away(config('client.url') . '/memos');
    }
}
