<?php
/**
 * Security Configuration
 * Security settings and constants for the application
 */

return [
    'password' => [
        'min_length' => 8,
        'require_special_chars' => true,
        'require_numbers' => true,
        'require_uppercase' => true,
        'cost' => 12, // bcrypt cost
    ],
    'csrf' => [
        'token_name' => '_token',
        'regenerate_on_use' => true,
    ],
    'rate_limit' => [
        'max_attempts' => 5,
        'window_minutes' => 15,
    ],
    'headers' => [
        'X-Content-Type-Options' => 'nosniff',
        'X-Frame-Options' => 'DENY',
        'X-XSS-Protection' => '1; mode=block',
        'Strict-Transport-Security' => 'max-age=31536000; includeSubDomains',
        'Content-Security-Policy' => "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline';"
    ]
];
