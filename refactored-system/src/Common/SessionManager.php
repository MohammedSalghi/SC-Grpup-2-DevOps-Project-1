<?php

namespace App\Common;

/**
 * Session Manager Class
 * Handles secure session management across the application
 */
class SessionManager
{
    private static $config;
    private static $isInitialized = false;

    /**
     * Initialize session configuration
     */
    private static function initialize(): void
    {
        if (self::$isInitialized) {
            return;
        }

        self::$config = include __DIR__ . '/../../config/app.php';
        
        // Configure session settings
        ini_set('session.cookie_httponly', self::$config['session']['httponly']);
        ini_set('session.cookie_secure', self::$config['session']['secure']);
        ini_set('session.cookie_samesite', self::$config['session']['samesite']);
        ini_set('session.gc_maxlifetime', self::$config['session']['lifetime']);
        
        session_name(self::$config['session']['name']);
        
        self::$isInitialized = true;
    }

    /**
     * Start session if not already started
     */
    public static function start(): void
    {
        self::initialize();
        
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
            
            // Regenerate session ID for security
            if (!isset($_SESSION['initiated'])) {
                session_regenerate_id(true);
                $_SESSION['initiated'] = true;
                $_SESSION['created'] = time();
            }
            
            // Check session timeout
            self::checkTimeout();
        }
    }

    /**
     * Check if user authentication is required
     * @param string $redirectTo
     */
    public static function requireAuth(string $redirectTo = '../login.php'): void
    {
        self::start();
        
        if (!self::isAuthenticated()) {
            header("Location: $redirectTo");
            exit();
        }
    }

    /**
     * Check if user is authenticated
     * @return bool
     */
    public static function isAuthenticated(): bool
    {
        self::start();
        return isset($_SESSION['user']) && isset($_SESSION['usertype']);
    }

    /**
     * Start user session after successful authentication
     * @param string $email
     * @param string $userType
     * @param array $additionalData
     */
    public static function startUserSession(string $email, string $userType, array $additionalData = []): void
    {
        self::start();
        
        // Regenerate session ID for security
        session_regenerate_id(true);
        
        $_SESSION['user'] = $email;
        $_SESSION['usertype'] = $userType;
        $_SESSION['login_time'] = time();
        $_SESSION['last_activity'] = time();
        
        // Store additional data
        foreach ($additionalData as $key => $value) {
            $_SESSION[$key] = $value;
        }
    }

    /**
     * Get current user email
     * @return string|null
     */
    public static function getCurrentUser(): ?string
    {
        self::start();
        return $_SESSION['user'] ?? null;
    }

    /**
     * Get current user type
     * @return string|null
     */
    public static function getCurrentUserType(): ?string
    {
        self::start();
        return $_SESSION['usertype'] ?? null;
    }

    /**
     * Get session data
     * @param string $key
     * @param mixed $default
     * @return mixed
     */
    public static function get(string $key, $default = null)
    {
        self::start();
        return $_SESSION[$key] ?? $default;
    }

    /**
     * Set session data
     * @param string $key
     * @param mixed $value
     */
    public static function set(string $key, $value): void
    {
        self::start();
        $_SESSION[$key] = $value;
    }

    /**
     * Remove session data
     * @param string $key
     */
    public static function remove(string $key): void
    {
        self::start();
        unset($_SESSION[$key]);
    }

    /**
     * Check session timeout
     */
    private static function checkTimeout(): void
    {
        $maxLifetime = self::$config['session']['lifetime'];
        
        if (isset($_SESSION['last_activity'])) {
            if (time() - $_SESSION['last_activity'] > $maxLifetime) {
                self::destroy();
                return;
            }
        }
        
        $_SESSION['last_activity'] = time();
    }

    /**
     * Destroy session completely
     */
    public static function destroy(): void
    {
        self::start();
        
        // Clear session data
        $_SESSION = [];
        
        // Delete session cookie
        if (ini_get("session.use_cookies")) {
            $params = session_get_cookie_params();
            setcookie(session_name(), '', time() - 42000,
                $params["path"], $params["domain"],
                $params["secure"], $params["httponly"]
            );
        }
        
        // Destroy session
        session_destroy();
    }

    /**
     * Regenerate session ID for security
     */
    public static function regenerateId(): void
    {
        self::start();
        session_regenerate_id(true);
    }

    /**
     * Check if session is valid
     * @return bool
     */
    public static function isValid(): bool
    {
        self::start();
        
        // Check if session has required data
        if (!isset($_SESSION['user']) || !isset($_SESSION['login_time'])) {
            return false;
        }
        
        // Check session age
        $maxLifetime = self::$config['session']['lifetime'];
        if (time() - $_SESSION['login_time'] > $maxLifetime) {
            return false;
        }
        
        return true;
    }
}
