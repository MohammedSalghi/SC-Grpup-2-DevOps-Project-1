<?php

namespace App\Services;

use App\Common\DatabaseConnection;
use App\Common\SessionManager;
use App\Security\InputValidator;
use App\Security\RateLimiter;
use Exception;
use InvalidArgumentException;

/**
 * Authentication Service Class
 * Handles secure user authentication with SQL injection protection
 */
class AuthenticationService
{
    private $database;
    private $config;

    public function __construct()
    {
        $this->database = DatabaseConnection::getInstance()->getConnection();
        $this->config = include __DIR__ . '/../../config/security.php';
    }

    /**
     * Authenticate user with email and password
     * @param string $email
     * @param string $password
     * @return array|false
     * @throws Exception
     */
    public function authenticate(string $email, string $password)
    {
        // Input validation and sanitization
        $email = InputValidator::sanitizeInput($email, 'email');
        
        if (!InputValidator::validateEmail($email)) {
            throw new InvalidArgumentException("Invalid email format");
        }

        // Check rate limiting
        $identifier = $this->getClientIdentifier() . '_' . $email;
        if (RateLimiter::isLoginLimited($identifier)) {
            $remainingTime = RateLimiter::getRemainingLoginTime($identifier);
            throw new Exception("Too many login attempts. Please try again in " . ceil($remainingTime / 60) . " minutes.");
        }

        try {
            // Prepared statement for secure database query
            $stmt = $this->database->prepare("SELECT email, password, usertype FROM webuser WHERE email = ? LIMIT 1");
            
            if (!$stmt) {
                throw new Exception("Database query preparation failed");
            }

            $stmt->bind_param("s", $email);
            $stmt->execute();
            $result = $stmt->get_result();

            if ($result->num_rows === 1) {
                $user = $result->fetch_assoc();
                
                // Use password_verify for secure password comparison
                if (password_verify($password, $user['password'])) {
                    // Clear rate limiting on successful login
                    RateLimiter::clearLoginAttempts($identifier);
                    
                    return [
                        'email' => $user['email'],
                        'usertype' => $user['usertype']
                    ];
                }
            }

            // Record failed login attempt
            RateLimiter::recordLoginAttempt($identifier);
            return false;

        } catch (Exception $e) {
            error_log("Authentication error: " . $e->getMessage());
            throw new Exception("Authentication failed");
        }
    }

    /**
     * Login user and start session
     * @param string $email
     * @param string $password
     * @return array
     * @throws Exception
     */
    public function login(string $email, string $password): array
    {
        $user = $this->authenticate($email, $password);
        
        if (!$user) {
            throw new Exception("Invalid email or password");
        }

        // Get additional user data based on user type
        $userData = $this->getUserData($user['email'], $user['usertype']);
        
        // Start user session
        SessionManager::startUserSession(
            $user['email'], 
            $user['usertype'], 
            $userData
        );

        return [
            'success' => true,
            'user' => $user,
            'data' => $userData,
            'redirect' => $this->getRedirectUrl($user['usertype'])
        ];
    }

    /**
     * Get additional user data based on user type
     * @param string $email
     * @param string $usertype
     * @return array
     */
    private function getUserData(string $email, string $usertype): array
    {
        $data = [];
        
        try {
            switch ($usertype) {
                case 'a':
                    $stmt = $this->database->prepare("SELECT aname as name FROM admin WHERE aemail = ?");
                    break;
                case 'd':
                    $stmt = $this->database->prepare("SELECT docname as name, docid, specialties FROM doctor WHERE docemail = ?");
                    break;
                case 'p':
                    $stmt = $this->database->prepare("SELECT pname as name, pid, pdob, ptel FROM patient WHERE pemail = ?");
                    break;
                default:
                    return $data;
            }

            if ($stmt) {
                $stmt->bind_param("s", $email);
                $stmt->execute();
                $result = $stmt->get_result();
                
                if ($result->num_rows === 1) {
                    $data = $result->fetch_assoc();
                }
            }
        } catch (Exception $e) {
            error_log("Error fetching user data: " . $e->getMessage());
        }

        return $data;
    }

    /**
     * Get redirect URL based on user type
     * @param string $usertype
     * @return string
     */
    private function getRedirectUrl(string $usertype): string
    {
        switch ($usertype) {
            case 'a':
                return 'admin/';
            case 'd':
                return 'doctor/';
            case 'p':
                return 'patient/';
            default:
                return 'login.php';
        }
    }

    /**
     * Register new user
     * @param array $userData
     * @return array
     * @throws Exception
     */
    public function register(array $userData): array
    {
        // Validate required fields
        $requiredFields = ['email', 'password', 'usertype'];
        $validation = InputValidator::validateRequired($userData, $requiredFields);
        
        if (!$validation['valid']) {
            throw new InvalidArgumentException(implode(', ', $validation['errors']));
        }

        // Validate email
        if (!InputValidator::validateEmail($userData['email'])) {
            throw new InvalidArgumentException("Invalid email format");
        }

        // Validate password
        $passwordValidation = InputValidator::validatePassword($userData['password']);
        if (!$passwordValidation['valid']) {
            throw new InvalidArgumentException(implode(', ', $passwordValidation['errors']));
        }

        // Check if user already exists
        if ($this->userExists($userData['email'])) {
            throw new Exception("User with this email already exists");
        }

        // Hash password
        $hashedPassword = password_hash($userData['password'], PASSWORD_DEFAULT, [
            'cost' => $this->config['password']['cost']
        ]);

        try {
            $this->database->begin_transaction();

            // Insert into webuser table
            $stmt = $this->database->prepare("INSERT INTO webuser (email, usertype) VALUES (?, ?)");
            $stmt->bind_param("ss", $userData['email'], $userData['usertype']);
            $stmt->execute();

            // Insert into specific user type table
            $this->insertUserTypeData($userData, $hashedPassword);

            $this->database->commit();

            return [
                'success' => true,
                'message' => 'User registered successfully'
            ];

        } catch (Exception $e) {
            $this->database->rollback();
            error_log("Registration error: " . $e->getMessage());
            throw new Exception("Registration failed");
        }
    }

    /**
     * Insert user type specific data
     * @param array $userData
     * @param string $hashedPassword
     * @throws Exception
     */
    private function insertUserTypeData(array $userData, string $hashedPassword): void
    {
        switch ($userData['usertype']) {
            case 'a':
                $stmt = $this->database->prepare("INSERT INTO admin (aemail, apassword, aname) VALUES (?, ?, ?)");
                $stmt->bind_param("sss", $userData['email'], $hashedPassword, $userData['name'] ?? '');
                break;
            
            case 'd':
                $stmt = $this->database->prepare("INSERT INTO doctor (docemail, docpassword, docname, specialties) VALUES (?, ?, ?, ?)");
                $stmt->bind_param("ssss", $userData['email'], $hashedPassword, $userData['name'] ?? '', $userData['specialties'] ?? '');
                break;
            
            case 'p':
                $stmt = $this->database->prepare("INSERT INTO patient (pemail, ppassword, pname, pdob, ptel) VALUES (?, ?, ?, ?, ?)");
                $stmt->bind_param("sssss", $userData['email'], $hashedPassword, $userData['name'] ?? '', $userData['dob'] ?? '', $userData['tel'] ?? '');
                break;
            
            default:
                throw new InvalidArgumentException("Invalid user type");
        }

        if (!$stmt->execute()) {
            throw new Exception("Failed to insert user type data");
        }
    }

    /**
     * Check if user exists
     * @param string $email
     * @return bool
     */
    private function userExists(string $email): bool
    {
        $stmt = $this->database->prepare("SELECT email FROM webuser WHERE email = ? LIMIT 1");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();
        
        return $result->num_rows > 0;
    }

    /**
     * Logout user
     */
    public function logout(): void
    {
        SessionManager::destroy();
    }

    /**
     * Check if user is authenticated
     * @return bool
     */
    public function isAuthenticated(): bool
    {
        return SessionManager::isAuthenticated();
    }

    /**
     * Get current user
     * @return array|null
     */
    public function getCurrentUser(): ?array
    {
        if (!$this->isAuthenticated()) {
            return null;
        }

        return [
            'email' => SessionManager::getCurrentUser(),
            'usertype' => SessionManager::getCurrentUserType(),
            'name' => SessionManager::get('name'),
            'id' => SessionManager::get('id')
        ];
    }

    /**
     * Change user password
     * @param string $email
     * @param string $currentPassword
     * @param string $newPassword
     * @return bool
     * @throws Exception
     */
    public function changePassword(string $email, string $currentPassword, string $newPassword): bool
    {
        // Authenticate with current password
        if (!$this->authenticate($email, $currentPassword)) {
            throw new Exception("Current password is incorrect");
        }

        // Validate new password
        $passwordValidation = InputValidator::validatePassword($newPassword);
        if (!$passwordValidation['valid']) {
            throw new InvalidArgumentException(implode(', ', $passwordValidation['errors']));
        }

        // Hash new password
        $hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT, [
            'cost' => $this->config['password']['cost']
        ]);

        try {
            // Update password in respective table based on user type
            $userType = $this->getUserType($email);
            
            switch ($userType) {
                case 'a':
                    $stmt = $this->database->prepare("UPDATE admin SET apassword = ? WHERE aemail = ?");
                    break;
                case 'd':
                    $stmt = $this->database->prepare("UPDATE doctor SET docpassword = ? WHERE docemail = ?");
                    break;
                case 'p':
                    $stmt = $this->database->prepare("UPDATE patient SET ppassword = ? WHERE pemail = ?");
                    break;
                default:
                    throw new Exception("Invalid user type");
            }

            $stmt->bind_param("ss", $hashedPassword, $email);
            return $stmt->execute();

        } catch (Exception $e) {
            error_log("Password change error: " . $e->getMessage());
            throw new Exception("Failed to change password");
        }
    }

    /**
     * Get user type by email
     * @param string $email
     * @return string|null
     */
    private function getUserType(string $email): ?string
    {
        $stmt = $this->database->prepare("SELECT usertype FROM webuser WHERE email = ? LIMIT 1");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows === 1) {
            return $result->fetch_assoc()['usertype'];
        }
        
        return null;
    }

    /**
     * Get client identifier for rate limiting
     * @return string
     */
    private function getClientIdentifier(): string
    {
        return hash('sha256', $_SERVER['REMOTE_ADDR'] . ($_SERVER['HTTP_USER_AGENT'] ?? ''));
    }
}
