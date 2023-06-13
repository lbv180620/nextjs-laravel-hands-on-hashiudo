<?php

namespace App\Http\Controllers;

use App\Http\Requests\LoginRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException as ValidationValidationException;
use Laravel\Socialite\Facades\Socialite;

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
        if (Auth::attempt($request->all(), true)) {
            $request->session()->regenerate();
            return new UserResource(Auth::user());
        }

        // ログイン失敗時のエラーメッセージ
        throw ValidationValidationException::withMessages([
            'loginFailed' => 'IDまたはパスワードが間違っています。',
        ]);
    }

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