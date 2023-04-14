<?php

declare(strict_types=1);

namespace Tests\Feature\Http\Controllers\Api\Auth;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Support\Facades\Password;
use Tests\TestCase;

final class ResetPasswordControllerTest extends TestCase
{
    use RefreshDatabase;

    /**
     * @return void
     */
    public function testSuccess(): void
    {
        $user = User::factory()->create(['email' => 'test@example.com']);
        $token = Password::createToken($user);

        $params = [
            'email' => $user->email,
            'password' => 'secret',
            'token' => $token,
        ];

        $this->postJson('/api/reset-password', $params)
            ->assertStatus(200)
            ->assertJson([
                'message' => 'Your password has been reset!',
            ]);
    }

    /**
     * @return void
     */
    public function testNotExistsEmail(): void
    {
        $params = [
            'email' => 'test@example.com',
            'password' => 'secret',
            'token' => '123456789',
        ];

        $this->postJson('/api/reset-password', $params)
            ->assertStatus(422)
            ->assertJson([
                'message' => 'The given data was invalid.',
                'errors' => [
                    'email' => ['We can\'t find a user with that email address.'],
                ],
            ]);
    }

    /**
     * @return void
     */
    public function testMismatchToken(): void
    {
        $user = User::factory()->create(['email' => 'test@example.com']);
        Password::createToken($user);

        $params = [
            'email' => $user->email,
            'password' => 'secret',
            'token' => '123456789',
        ];

        $this->postJson('/api/reset-password', $params)
            ->assertStatus(422)
            ->assertJson([
                'message' => 'The given data was invalid.',
                'errors' => [
                    'email' => ['This password reset token is invalid.'],
                ],
            ]);
    }

    /**
     * @return void
     */
    public function testExpiredToken(): void
    {
        $user = User::factory()->create(['email' => 'test@example.com']);
        $token = Password::createToken($user);

        $params = [
            'email' => $user->email,
            'password' => 'secret',
            'token' => $token,
        ];

        $this->travel(60)->hours();

        $this->postJson('/api/reset-password', $params)
            ->assertStatus(422)
            ->assertJson([
                'message' => 'The given data was invalid.',
                'errors' => [
                    'email' => ['This password reset token is invalid.'],
                ],
            ]);
    }
}
