<?php

declare(strict_types=1);

namespace Tests\Feature\Http\Controllers\Api\Auth;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Validation\ValidationException;
use Tests\TestCase;

final class ForgotPasswordControllerTest extends TestCase
{
    use RefreshDatabase;

    /**
     * @return void
     */
    public function testSuccess(): void
    {
        $user = User::factory()->create(['email' => 'test@example.com']);

        $params = [
            'email' => $user->email,
        ];

        $this->postJson('/api/forgot-password', $params)
            ->assertStatus(200)
            ->assertJson([
                'message' => 'We have emailed your password reset link!',
            ]);

        $this->travel(55)->seconds();

        // try {
        $this->postJson('/api/forgot-password', $params)
            ->assertStatus(422)
            ->assertJson([
                'message' => 'The given data was invalid.',
                'errors' => [
                    'email' => ['Please wait before retrying.'],
                ],
            ]);
    }

    /**
     * @return void
     */
    public function testThrottle60s(): void
    {
        $user = User::factory()->create(['email' => 'test@example.com']);

        $params = [
            'email' => $user->email,
        ];

        $this->postJson('/api/forgot-password', $params)
            ->assertStatus(200)
            ->assertJson([
                'message' => 'We have emailed your password reset link!',
            ]);

        $this->travel(60)->seconds();

        $this->postJson('/api/forgot-password', $params)
            ->assertStatus(200)
            ->assertJson([
                'message' => 'We have emailed your password reset link!',
            ]);
    }
}
