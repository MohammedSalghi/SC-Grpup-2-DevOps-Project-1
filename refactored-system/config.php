<?php
/**
 * REFACTORED: Configuration Management
 * Fixes: Hardcoded values and improves maintainability
 * Implementation: Centralized configuration system
 */

class Config {
    
    // Database Configuration
    const DB_HOST = "db";
    const DB_USERNAME = "root";
    const DB_PASSWORD = "root";
    const DB_NAME = "edoc";
    const DB_CHARSET = "utf8";
    
    // Application Settings
    const APP_NAME = "eDoc Hospital Management System";
    const APP_VERSION = "2.0.0";
    const APP_ENV = "development"; // development, staging, production
    
    // Security Settings
    const SESSION_TIMEOUT = 3600; // 1 hour in seconds
    const PASSWORD_MIN_LENGTH = 8;
    const MAX_LOGIN_ATTEMPTS = 5;
    const LOCKOUT_DURATION = 900; // 15 minutes in seconds
    
    // Performance Settings
    const CACHE_ENABLED = true;
    const CACHE_DURATION = 300; // 5 minutes
    const MAX_QUERY_EXECUTION_TIME = 30; // seconds
    
    // File Upload Settings
    const MAX_FILE_SIZE = 5242880; // 5MB in bytes
    const ALLOWED_FILE_TYPES = ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'];
    const UPLOAD_PATH = 'uploads/';
    
    // Pagination Settings
    const DEFAULT_PAGE_SIZE = 20;
    const MAX_PAGE_SIZE = 100;
    
    // Email Configuration (for notifications)
    const SMTP_HOST = "localhost";
    const SMTP_PORT = 587;
    const SMTP_USERNAME = "";
    const SMTP_PASSWORD = "";
    const FROM_EMAIL = "noreply@edoc.com";
    const FROM_NAME = "eDoc System";
    
    // API Settings
    const API_RATE_LIMIT = 100; // requests per minute
    const API_VERSION = "v1";
    
    // Logging Configuration
    const LOG_LEVEL = "DEBUG"; // DEBUG, INFO, WARNING, ERROR
    const LOG_FILE = "logs/application.log";
    const MAX_LOG_SIZE = 10485760; // 10MB
    
    /**
     * Get database configuration as array
     */
    public static function getDatabaseConfig() {
        return [
            'host' => self::DB_HOST,
            'username' => self::DB_USERNAME,
            'password' => self::DB_PASSWORD,
            'database' => self::DB_NAME,
            'charset' => self::DB_CHARSET
        ];
    }
    
    /**
     * Get environment-specific settings
     */
    public static function getEnvironmentConfig() {
        switch (self::APP_ENV) {
            case 'production':
                return [
                    'debug' => false,
                    'error_reporting' => false,
                    'display_errors' => false,
                    'log_level' => 'ERROR',
                    'cache_enabled' => true
                ];
            case 'staging':
                return [
                    'debug' => true,
                    'error_reporting' => true,
                    'display_errors' => false,
                    'log_level' => 'WARNING',
                    'cache_enabled' => true
                ];
            case 'development':
            default:
                return [
                    'debug' => true,
                    'error_reporting' => true,
                    'display_errors' => true,
                    'log_level' => 'DEBUG',
                    'cache_enabled' => false
                ];
        }
    }
    
    /**
     * Get security configuration
     */
    public static function getSecurityConfig() {
        return [
            'session_timeout' => self::SESSION_TIMEOUT,
            'password_min_length' => self::PASSWORD_MIN_LENGTH,
            'max_login_attempts' => self::MAX_LOGIN_ATTEMPTS,
            'lockout_duration' => self::LOCKOUT_DURATION
        ];
    }
    
    /**
     * Check if feature is enabled
     */
    public static function isFeatureEnabled($feature) {
        $features = [
            'cache' => self::CACHE_ENABLED,
            'email_notifications' => true,
            'file_upload' => true,
            'api_access' => true,
            'debug_mode' => (self::APP_ENV === 'development')
        ];
        
        return $features[$feature] ?? false;
    }
    
    /**
     * Get configuration value by key with dot notation support
     */
    public static function get($key, $default = null) {
        $config = [
            'app.name' => self::APP_NAME,
            'app.version' => self::APP_VERSION,
            'app.env' => self::APP_ENV,
            'db.host' => self::DB_HOST,
            'db.name' => self::DB_NAME,
            'security.session_timeout' => self::SESSION_TIMEOUT,
            'files.max_size' => self::MAX_FILE_SIZE,
            'pagination.default_size' => self::DEFAULT_PAGE_SIZE
        ];
        
        return $config[$key] ?? $default;
    }
    
    /**
     * Validate configuration on application startup
     */
    public static function validate() {
        $errors = [];
        
        // Check database configuration
        if (empty(self::DB_HOST) || empty(self::DB_NAME)) {
            $errors[] = "Database configuration is incomplete";
        }
        
        // Check file permissions
        if (!is_writable(dirname(self::LOG_FILE))) {
            $errors[] = "Log directory is not writable";
        }
        
        if (!is_writable(self::UPLOAD_PATH)) {
            $errors[] = "Upload directory is not writable";
        }
        
        // Check security settings
        if (self::PASSWORD_MIN_LENGTH < 6) {
            $errors[] = "Password minimum length is too weak";
        }
        
        return empty($errors) ? true : $errors;
    }
}

// Environment-specific initialization
$envConfig = Config::getEnvironmentConfig();

// Set error reporting based on environment
error_reporting($envConfig['error_reporting'] ? E_ALL : 0);
ini_set('display_errors', $envConfig['display_errors'] ? 1 : 0);

// Set timezone
date_default_timezone_set('Asia/Kolkata');

// Validate configuration on load
$configValidation = Config::validate();
if ($configValidation !== true) {
    error_log("Configuration validation failed: " . implode(', ', $configValidation));
    if (Config::get('app.env') === 'development') {
        die("Configuration Error: " . implode('<br>', $configValidation));
    }
}
?>
