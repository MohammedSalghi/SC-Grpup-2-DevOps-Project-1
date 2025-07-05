<?php

namespace App\Security;

/**
 * Input Validator Class
 * Provides comprehensive input validation and sanitization
 */
class InputValidator
{
    /**
     * Validate email address
     * @param string $email
     * @return bool
     */
    public static function validateEmail(string $email): bool
    {
        return filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
    }

    /**
     * Validate password strength
     * @param string $password
     * @return array
     */
    public static function validatePassword(string $password): array
    {
        $config = include __DIR__ . '/../../config/security.php';
        $errors = [];

        // Check minimum length
        if (strlen($password) < $config['password']['min_length']) {
            $errors[] = "Password must be at least {$config['password']['min_length']} characters long";
        }

        // Check for uppercase letter
        if ($config['password']['require_uppercase'] && !preg_match('/[A-Z]/', $password)) {
            $errors[] = "Password must contain at least one uppercase letter";
        }

        // Check for numbers
        if ($config['password']['require_numbers'] && !preg_match('/[0-9]/', $password)) {
            $errors[] = "Password must contain at least one number";
        }

        // Check for special characters
        if ($config['password']['require_special_chars'] && !preg_match('/[^a-zA-Z0-9]/', $password)) {
            $errors[] = "Password must contain at least one special character";
        }

        return [
            'valid' => empty($errors),
            'errors' => $errors
        ];
    }

    /**
     * Sanitize input based on type
     * @param mixed $input
     * @param string $type
     * @return mixed
     */
    public static function sanitizeInput($input, string $type = 'string')
    {
        if ($input === null) {
            return null;
        }

        switch ($type) {
            case 'email':
                return filter_var($input, FILTER_SANITIZE_EMAIL);
            
            case 'int':
                return filter_var($input, FILTER_VALIDATE_INT);
            
            case 'float':
                return filter_var($input, FILTER_VALIDATE_FLOAT);
            
            case 'url':
                return filter_var($input, FILTER_SANITIZE_URL);
            
            case 'phone':
                return preg_replace('/[^0-9+\-\s]/', '', $input);
            
            case 'date':
                return self::validateDate($input) ? $input : null;
            
            case 'time':
                return self::validateTime($input) ? $input : null;
            
            case 'alphanumeric':
                return preg_replace('/[^a-zA-Z0-9]/', '', $input);
            
            case 'string':
            default:
                return htmlspecialchars(strip_tags($input), ENT_QUOTES, 'UTF-8');
        }
    }

    /**
     * Validate date format
     * @param string $date
     * @param string $format
     * @return bool
     */
    public static function validateDate(string $date, string $format = 'Y-m-d'): bool
    {
        $d = \DateTime::createFromFormat($format, $date);
        return $d && $d->format($format) === $date;
    }

    /**
     * Validate time format
     * @param string $time
     * @param string $format
     * @return bool
     */
    public static function validateTime(string $time, string $format = 'H:i'): bool
    {
        $t = \DateTime::createFromFormat($format, $time);
        return $t && $t->format($format) === $time;
    }

    /**
     * Validate phone number
     * @param string $phone
     * @return bool
     */
    public static function validatePhone(string $phone): bool
    {
        // Remove all non-numeric characters except + and -
        $cleaned = preg_replace('/[^0-9+\-]/', '', $phone);
        
        // Check if it has appropriate length (7-15 digits)
        $digitCount = preg_match_all('/[0-9]/', $cleaned);
        return $digitCount >= 7 && $digitCount <= 15;
    }

    /**
     * Validate required fields
     * @param array $data
     * @param array $requiredFields
     * @return array
     */
    public static function validateRequired(array $data, array $requiredFields): array
    {
        $errors = [];
        
        foreach ($requiredFields as $field) {
            if (!isset($data[$field]) || empty(trim($data[$field]))) {
                $errors[] = "The {$field} field is required";
            }
        }
        
        return [
            'valid' => empty($errors),
            'errors' => $errors
        ];
    }

    /**
     * Validate array of data with rules
     * @param array $data
     * @param array $rules
     * @return array
     */
    public static function validate(array $data, array $rules): array
    {
        $errors = [];
        $sanitized = [];

        foreach ($rules as $field => $fieldRules) {
            $value = $data[$field] ?? null;
            
            // Check if required
            if (in_array('required', $fieldRules) && (empty($value) && $value !== '0')) {
                $errors[$field][] = "The {$field} field is required";
                continue;
            }
            
            // Skip validation if field is empty and not required
            if (empty($value) && !in_array('required', $fieldRules)) {
                $sanitized[$field] = null;
                continue;
            }

            // Apply validation rules
            foreach ($fieldRules as $rule) {
                switch ($rule) {
                    case 'email':
                        if (!self::validateEmail($value)) {
                            $errors[$field][] = "The {$field} must be a valid email address";
                        } else {
                            $sanitized[$field] = self::sanitizeInput($value, 'email');
                        }
                        break;
                    
                    case 'int':
                        $sanitized_value = self::sanitizeInput($value, 'int');
                        if ($sanitized_value === false) {
                            $errors[$field][] = "The {$field} must be a valid integer";
                        } else {
                            $sanitized[$field] = $sanitized_value;
                        }
                        break;
                    
                    case 'phone':
                        if (!self::validatePhone($value)) {
                            $errors[$field][] = "The {$field} must be a valid phone number";
                        } else {
                            $sanitized[$field] = self::sanitizeInput($value, 'phone');
                        }
                        break;
                    
                    case 'date':
                        if (!self::validateDate($value)) {
                            $errors[$field][] = "The {$field} must be a valid date (Y-m-d)";
                        } else {
                            $sanitized[$field] = $value;
                        }
                        break;
                    
                    default:
                        if (!isset($sanitized[$field])) {
                            $sanitized[$field] = self::sanitizeInput($value, 'string');
                        }
                        break;
                }
            }
        }

        return [
            'valid' => empty($errors),
            'errors' => $errors,
            'data' => $sanitized
        ];
    }

    /**
     * Check for SQL injection patterns
     * @param string $input
     * @return bool
     */
    public static function hasSQLInjection(string $input): bool
    {
        $patterns = [
            '/(\b(select|insert|update|delete|drop|create|alter|exec|execute|union|script)\b)/i',
            '/(\b(or|and)\s+\d+\s*=\s*\d+)/i',
            '/([\'"]\s*(or|and)\s+[\'"]\s*[\'"]\s*=\s*[\'"]\s*[\'"]\s*)/i',
            '/(\b(waitfor|delay|sleep)\s*\()/i'
        ];

        foreach ($patterns as $pattern) {
            if (preg_match($pattern, $input)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Check for XSS patterns
     * @param string $input
     * @return bool
     */
    public static function hasXSS(string $input): bool
    {
        $patterns = [
            '/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi',
            '/javascript:/i',
            '/on\w+\s*=/i',
            '/<iframe/i',
            '/<object/i',
            '/<embed/i'
        ];

        foreach ($patterns as $pattern) {
            if (preg_match($pattern, $input)) {
                return true;
            }
        }

        return false;
    }
}
