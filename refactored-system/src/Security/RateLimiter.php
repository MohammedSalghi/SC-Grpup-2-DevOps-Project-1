<?php

namespace App\Security;

use App\Common\SessionManager;

/**
 * Rate Limiter Class
 * Provides rate limiting functionality to prevent abuse
 */
class RateLimiter
{
    private static $config;

    /**
     * Initialize rate limiter configuration
     */
    private static function initialize(): void
    {
        if (!self::$config) {
            self::$config = include __DIR__ . '/../../config/security.php';
        }
    }

    /**
     * Check if action is rate limited
     * @param string $action
     * @param string $identifier
     * @return bool
     */
    public static function isLimited(string $action, string $identifier): bool
    {
        self::initialize();
        
        $key = self::getKey($action, $identifier);
        $attempts = self::getAttempts($key);
        
        return $attempts >= self::$config['rate_limit']['max_attempts'];
    }

    /**
     * Record an attempt
     * @param string $action
     * @param string $identifier
     */
    public static function recordAttempt(string $action, string $identifier): void
    {
        $key = self::getKey($action, $identifier);
        $attempts = self::getAttempts($key);
        
        SessionManager::start();
        SessionManager::set($key, [
            'count' => $attempts + 1,
            'first_attempt' => $attempts === 0 ? time() : SessionManager::get($key)['first_attempt']
        ]);
    }

    /**
     * Clear attempts for an action
     * @param string $action
     * @param string $identifier
     */
    public static function clearAttempts(string $action, string $identifier): void
    {
        $key = self::getKey($action, $identifier);
        SessionManager::start();
        SessionManager::remove($key);
    }

    /**
     * Get remaining time until rate limit resets
     * @param string $action
     * @param string $identifier
     * @return int
     */
    public static function getRemainingTime(string $action, string $identifier): int
    {
        self::initialize();
        
        $key = self::getKey($action, $identifier);
        $data = SessionManager::get($key);
        
        if (!$data) {
            return 0;
        }
        
        $windowMinutes = self::$config['rate_limit']['window_minutes'];
        $elapsed = time() - $data['first_attempt'];
        $remaining = ($windowMinutes * 60) - $elapsed;
        
        return max(0, $remaining);
    }

    /**
     * Get attempt count
     * @param string $key
     * @return int
     */
    private static function getAttempts(string $key): int
    {
        self::initialize();
        
        SessionManager::start();
        $data = SessionManager::get($key);
        
        if (!$data) {
            return 0;
        }
        
        // Check if window has expired
        $windowMinutes = self::$config['rate_limit']['window_minutes'];
        if (time() - $data['first_attempt'] > ($windowMinutes * 60)) {
            SessionManager::remove($key);
            return 0;
        }
        
        return $data['count'];
    }

    /**
     * Generate key for rate limiting
     * @param string $action
     * @param string $identifier
     * @return string
     */
    private static function getKey(string $action, string $identifier): string
    {
        return 'rate_limit_' . $action . '_' . hash('sha256', $identifier);
    }

    /**
     * Check login rate limit
     * @param string $identifier
     * @return bool
     */
    public static function isLoginLimited(string $identifier): bool
    {
        return self::isLimited('login', $identifier);
    }

    /**
     * Record login attempt
     * @param string $identifier
     */
    public static function recordLoginAttempt(string $identifier): void
    {
        self::recordAttempt('login', $identifier);
    }

    /**
     * Clear login attempts
     * @param string $identifier
     */
    public static function clearLoginAttempts(string $identifier): void
    {
        self::clearAttempts('login', $identifier);
    }

    /**
     * Get remaining login time
     * @param string $identifier
     * @return int
     */
    public static function getRemainingLoginTime(string $identifier): int
    {
        return self::getRemainingTime('login', $identifier);
    }
}
