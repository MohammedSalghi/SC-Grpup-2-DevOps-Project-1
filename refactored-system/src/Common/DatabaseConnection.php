<?php

namespace App\Common;

use mysqli;
use Exception;

/**
 * Singleton Database Connection Class
 * Provides secure and optimized database connectivity
 */
class DatabaseConnection
{
    private static $instance = null;
    private $connection;
    private $config;

    /**
     * Private constructor to prevent direct instantiation
     * @throws Exception
     */
    private function __construct()
    {
        $this->config = include __DIR__ . '/../../config/database.php';
        $this->connect();
    }

    /**
     * Get the singleton instance of DatabaseConnection
     * @return DatabaseConnection
     * @throws Exception
     */
    public static function getInstance(): DatabaseConnection
    {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    /**
     * Establish database connection
     * @throws Exception
     */
    private function connect(): void
    {
        try {
            $this->connection = new mysqli(
                $this->config['host'],
                $this->config['username'],
                $this->config['password'],
                $this->config['database'],
                $this->config['port']
            );

            if ($this->connection->connect_error) {
                throw new Exception("Database connection failed: " . $this->connection->connect_error);
            }

            // Set charset
            if (!$this->connection->set_charset($this->config['charset'])) {
                throw new Exception("Error setting charset: " . $this->connection->error);
            }

        } catch (Exception $e) {
            error_log("Database connection error: " . $e->getMessage());
            throw new Exception("Unable to connect to database");
        }
    }

    /**
     * Get the mysqli connection instance
     * @return mysqli
     */
    public function getConnection(): mysqli
    {
        // Check if connection is still alive
        if (!$this->connection->ping()) {
            $this->connect();
        }
        return $this->connection;
    }

    /**
     * Prepare a SQL statement
     * @param string $query
     * @return \mysqli_stmt|false
     */
    public function prepare(string $query)
    {
        return $this->getConnection()->prepare($query);
    }

    /**
     * Execute a query and return results
     * @param string $query
     * @return \mysqli_result|bool
     */
    public function query(string $query)
    {
        return $this->getConnection()->query($query);
    }

    /**
     * Get the last inserted ID
     * @return int
     */
    public function getLastInsertId(): int
    {
        return $this->getConnection()->insert_id;
    }

    /**
     * Begin transaction
     */
    public function beginTransaction(): void
    {
        $this->getConnection()->begin_transaction();
    }

    /**
     * Commit transaction
     */
    public function commit(): void
    {
        $this->getConnection()->commit();
    }

    /**
     * Rollback transaction
     */
    public function rollback(): void
    {
        $this->getConnection()->rollback();
    }

    /**
     * Escape string for safe SQL usage
     * @param string $string
     * @return string
     */
    public function escapeString(string $string): string
    {
        return $this->getConnection()->real_escape_string($string);
    }

    /**
     * Close database connection
     */
    public function close(): void
    {
        if ($this->connection) {
            $this->connection->close();
            $this->connection = null;
        }
    }

    /**
     * Prevent cloning of the instance
     */
    private function __clone() {}

    /**
     * Prevent unserialization of the instance
     */
    public function __wakeup()
    {
        throw new Exception("Cannot unserialize singleton");
    }

    /**
     * Close connection on destruction
     */
    public function __destruct()
    {
        $this->close();
    }
}
