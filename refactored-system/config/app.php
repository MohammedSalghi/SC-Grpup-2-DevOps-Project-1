<?php
/**
 * Application Configuration
 * Main application settings and constants
 */

return [
    'app_name' => 'E-Doc Doctor Appointment System',
    'app_version' => '2.0.0',
    'environment' => $_ENV['APP_ENV'] ?? 'development',
    'debug' => $_ENV['APP_DEBUG'] ?? true,
    'timezone' => 'Asia/Kolkata',
    'session' => [
        'name' => 'EDOC_SESSION',
        'lifetime' => 3600, // 1 hour
        'secure' => $_ENV['APP_ENV'] === 'production',
        'httponly' => true,
        'samesite' => 'Strict'
    ],
    'upload' => [
        'max_size' => 5 * 1024 * 1024, // 5MB
        'allowed_types' => ['jpg', 'jpeg', 'png', 'gif', 'pdf'],
        'upload_path' => __DIR__ . '/../uploads/'
    ]
];
