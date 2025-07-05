<?php

namespace App\Security;

use App\Common\SessionManager;

/**
 * CSRF Protection Class
 * Provides Cross-Site Request Forgery protection
 */
class CSRFProtection
{
    private const TOKEN_NAME = '_token';
    private const TOKEN_LENGTH = 32;

    /**
     * Generate CSRF token
     * @return string
     */
    public static function generateToken(): string
    {
        SessionManager::start();
        
        $token = bin2hex(random_bytes(self::TOKEN_LENGTH));
        SessionManager::set(self::TOKEN_NAME, $token);
        
        return $token;
    }

    /**
     * Validate CSRF token
     * @param string $token
     * @return bool
     */
    public static function validateToken(string $token): bool
    {
        SessionManager::start();
        
        $sessionToken = SessionManager::get(self::TOKEN_NAME);
        
        if (!$sessionToken || !$token) {
            return false;
        }
        
        return hash_equals($sessionToken, $token);
    }

    /**
     * Validate CSRF token from request
     * @param array $request
     * @return bool
     */
    public static function validateRequest(array $request): bool
    {
        $token = $request[self::TOKEN_NAME] ?? '';
        return self::validateToken($token);
    }

    /**
     * Get token field HTML
     * @return string
     */
    public static function getTokenField(): string
    {
        $token = self::generateToken();
        return '<input type="hidden" name="' . self::TOKEN_NAME . '" value="' . htmlspecialchars($token) . '">';
    }

    /**
     * Get current token
     * @return string|null
     */
    public static function getToken(): ?string
    {
        SessionManager::start();
        return SessionManager::get(self::TOKEN_NAME);
    }

    /**
     * Clear token
     */
    public static function clearToken(): void
    {
        SessionManager::start();
        SessionManager::remove(self::TOKEN_NAME);
    }

    /**
     * Regenerate token
     * @return string
     */
    public static function regenerateToken(): string
    {
        self::clearToken();
        return self::generateToken();
    }
}
