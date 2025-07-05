<?php
/**
 * Database Configuration
 * Centralized database configuration for the E-Doc system
 */

return [
    'host' => $_ENV['DB_HOST'] ?? 'db',
    'username' => $_ENV['DB_USERNAME'] ?? 'root',
    'password' => $_ENV['DB_PASSWORD'] ?? 'root',
    'database' => $_ENV['DB_NAME'] ?? 'edoc',
    'port' => $_ENV['DB_PORT'] ?? 3306,
    'charset' => 'utf8mb4',
    'options' => [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
        PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4"
    ]
];
