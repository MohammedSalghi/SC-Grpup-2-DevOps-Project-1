<?php
/**
 * REFACTORED: Centralized Error Handler
 * Fixes: Duplicated Code (Code Smell #3)
 * Implementation: Single source of truth for error messages
 */

class ErrorHandler {
    
    // Centralized error messages configuration
    private static $errorMessages = [
        'auth' => [
            'invalid_credentials' => 'Wrong credentials: Invalid email or password',
            'access_denied' => 'Access denied. Insufficient permissions.',
            'session_expired' => 'Session expired. Please login again.',
            'user_not_found' => 'User account not found.',
        ],
        'validation' => [
            'email_exists' => 'Already have an account for this Email address.',
            'password_mismatch' => 'Password Confirmation Error! Please re-confirm password.',
            'invalid_email' => 'Please enter a valid email address.',
            'required_field' => 'This field is required.',
            'invalid_phone' => 'Please enter a valid phone number.',
        ],
        'database' => [
            'connection_failed' => 'Database connection failed. Please try again later.',
            'query_failed' => 'Database query failed. Please contact administrator.',
            'record_not_found' => 'Record not found.',
            'deletion_failed' => 'Failed to delete record.',
        ],
        'system' => [
            'file_upload_failed' => 'File upload failed.',
            'permission_denied' => 'Permission denied.',
            'system_error' => 'System error occurred. Please try again.',
        ]
    ];
    
    // Error styling configuration
    private static $errorStyles = [
        'error' => 'color:rgb(255, 62, 62);text-align:center;',
        'success' => 'color:rgb(46, 125, 50);text-align:center;',
        'warning' => 'color:rgb(255, 152, 0);text-align:center;',
        'info' => 'color:rgb(33, 150, 243);text-align:center;'
    ];
    
    /**
     * Get formatted error message
     */
    public static function getError($category, $key, $type = 'error') {
        $message = self::$errorMessages[$category][$key] ?? 'Unknown error occurred.';
        $style = self::$errorStyles[$type] ?? self::$errorStyles['error'];
        
        return '<label for="promter" class="form-label" style="' . $style . '">' . $message . '</label>';
    }
    
    /**
     * Get error message by numeric code (for backward compatibility)
     */
    public static function getErrorByCode($code) {
        $codeMap = [
            '0' => '',
            '1' => self::getError('validation', 'email_exists'),
            '2' => self::getError('validation', 'password_mismatch'),
            '3' => '',
            '4' => '',
            'invalid_credentials' => self::getError('auth', 'invalid_credentials'),
            'access_denied' => self::getError('auth', 'access_denied'),
            'user_not_found' => self::getError('auth', 'user_not_found'),
        ];
        
        return $codeMap[$code] ?? self::getError('system', 'system_error');
    }
    
    /**
     * Log error for debugging (production-ready logging)
     */
    public static function logError($message, $file = '', $line = '') {
        $timestamp = date('Y-m-d H:i:s');
        $logMessage = "[$timestamp] Error: $message";
        
        if ($file) {
            $logMessage .= " in $file";
        }
        
        if ($line) {
            $logMessage .= " on line $line";
        }
        
        error_log($logMessage);
    }
    
    /**
     * Handle exceptions with user-friendly messages
     */
    public static function handleException($exception) {
        self::logError(
            $exception->getMessage(), 
            $exception->getFile(), 
            $exception->getLine()
        );
        
        // In production, show generic error to users
        if (APP_ENV === 'production') {
            return self::getError('system', 'system_error');
        } else {
            // In development, show detailed error
            return '<div style="color: red; border: 1px solid red; padding: 10px; margin: 10px;">' .
                   '<strong>Debug Error:</strong> ' . $exception->getMessage() . '<br>' .
                   '<strong>File:</strong> ' . $exception->getFile() . '<br>' .
                   '<strong>Line:</strong> ' . $exception->getLine() .
                   '</div>';
        }
    }
    
    /**
     * Validate form inputs with standardized error responses
     */
    public static function validateInput($input, $rules) {
        $errors = [];
        
        foreach ($rules as $field => $fieldRules) {
            $value = $input[$field] ?? '';
            
            foreach ($fieldRules as $rule) {
                switch ($rule) {
                    case 'required':
                        if (empty($value)) {
                            $errors[$field] = self::getError('validation', 'required_field');
                        }
                        break;
                    case 'email':
                        if (!filter_var($value, FILTER_VALIDATE_EMAIL)) {
                            $errors[$field] = self::getError('validation', 'invalid_email');
                        }
                        break;
                    case 'phone':
                        if (!preg_match('/^[0-9]{10}$/', $value)) {
                            $errors[$field] = self::getError('validation', 'invalid_phone');
                        }
                        break;
                }
            }
        }
        
        return $errors;
    }
    
    /**
     * Display success message with consistent styling
     */
    public static function getSuccessMessage($message) {
        return '<label class="form-label" style="' . self::$errorStyles['success'] . '">' . $message . '</label>';
    }
    
    /**
     * Get all available error categories for documentation
     */
    public static function getErrorCategories() {
        return array_keys(self::$errorMessages);
    }
    
    /**
     * Add custom error message at runtime
     */
    public static function addError($category, $key, $message) {
        if (!isset(self::$errorMessages[$category])) {
            self::$errorMessages[$category] = [];
        }
        self::$errorMessages[$category][$key] = $message;
    }
}

// Define application environment (should be in config file)
if (!defined('APP_ENV')) {
    define('APP_ENV', 'development'); // Change to 'production' for live environment
}

?>
