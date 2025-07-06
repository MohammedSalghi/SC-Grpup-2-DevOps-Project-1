<?php
/**
 * REFACTORED: Secure Database Layer
 * Fixes: SQL Injection vulnerabilities (Code Smell #1)
 * Implementation: Prepared statements and input validation
 */

class SecureDatabase {
    private $connection;
    private $host;
    private $username; 
    private $password;
    private $database;
    
    public function __construct($host = "db", $username = "root", $password = "root", $database = "edoc") {
        $this->host = $host;
        $this->username = $username;
        $this->password = $password;
        $this->database = $database;
        $this->connect();
    }
    
    private function connect() {
        try {
            $this->connection = new mysqli($this->host, $this->username, $this->password, $this->database);
            
            if ($this->connection->connect_error) {
                throw new Exception("Database connection failed: " . $this->connection->connect_error);
            }
            
            // Set charset to prevent character set confusion attacks
            $this->connection->set_charset("utf8");
            
        } catch (Exception $e) {
            error_log("Database connection error: " . $e->getMessage());
            die("Database connection failed. Please try again later.");
        }
    }
    
    /**
     * Secure method to execute SELECT queries with prepared statements
     */
    public function select($query, $params = [], $types = "") {
        try {
            $stmt = $this->connection->prepare($query);
            
            if (!$stmt) {
                throw new Exception("Prepare failed: " . $this->connection->error);
            }
            
            if (!empty($params)) {
                if (empty($types)) {
                    // Auto-detect parameter types
                    $types = str_repeat('s', count($params));
                }
                $stmt->bind_param($types, ...$params);
            }
            
            $stmt->execute();
            $result = $stmt->get_result();
            $stmt->close();
            
            return $result;
            
        } catch (Exception $e) {
            error_log("Database select error: " . $e->getMessage());
            return false;
        }
    }
    
    /**
     * Secure method to execute INSERT/UPDATE/DELETE queries
     */
    public function execute($query, $params = [], $types = "") {
        try {
            $stmt = $this->connection->prepare($query);
            
            if (!$stmt) {
                throw new Exception("Prepare failed: " . $this->connection->error);
            }
            
            if (!empty($params)) {
                if (empty($types)) {
                    $types = str_repeat('s', count($params));
                }
                $stmt->bind_param($types, ...$params);
            }
            
            $result = $stmt->execute();
            $affected_rows = $stmt->affected_rows;
            $insert_id = $this->connection->insert_id;
            $stmt->close();
            
            return [
                'success' => $result,
                'affected_rows' => $affected_rows,
                'insert_id' => $insert_id
            ];
            
        } catch (Exception $e) {
            error_log("Database execute error: " . $e->getMessage());
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }
    
    /**
     * Secure method for transactions
     */
    public function transaction($callback) {
        try {
            $this->connection->autocommit(false);
            
            $result = $callback($this);
            
            if ($result) {
                $this->connection->commit();
                return true;
            } else {
                $this->connection->rollback();
                return false;
            }
            
        } catch (Exception $e) {
            $this->connection->rollback();
            error_log("Transaction error: " . $e->getMessage());
            return false;
        } finally {
            $this->connection->autocommit(true);
        }
    }
    
    /**
     * Input validation and sanitization
     */
    public function sanitizeInput($input, $type = 'string') {
        switch ($type) {
            case 'int':
                return filter_var($input, FILTER_VALIDATE_INT);
            case 'email':
                return filter_var($input, FILTER_VALIDATE_EMAIL);
            case 'string':
            default:
                return htmlspecialchars(trim($input), ENT_QUOTES, 'UTF-8');
        }
    }
    
    public function getConnection() {
        return $this->connection;
    }
    
    public function close() {
        if ($this->connection) {
            $this->connection->close();
        }
    }
    
    public function __destruct() {
        $this->close();
    }
}

// Create global secure database instance
$secureDB = new SecureDatabase();
?>
