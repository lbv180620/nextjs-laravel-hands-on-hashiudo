<?php

declare(strict_types=1);

namespace App\Notifications\Api\Auth;

use Illuminate\Auth\Notifications\ResetPassword;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Support\Facades\Lang;

final class ResetPasswordNotification extends ResetPassword
{
    private const PASSWORD_RESET_ENDPOINT = 'https://example.com/reset-password';

    /**
     * @param string $url
     * @return MailMessage
     */
    protected function buildMailMessage($url): MailMessage
    {
        return parent::buildMailMessage($url)
            ->greeting(Lang::get('Greeting'))
            ->salutation(config('app.name'));
    }

    protected function resetUrl($notifiable): string
    {
        return self::PASSWORD_RESET_ENDPOINT . '?' . http_build_query([
            'token' => $this->token,
            'email' => $notifiable->getEmailForPasswordReset(),
        ]);
    }
}
