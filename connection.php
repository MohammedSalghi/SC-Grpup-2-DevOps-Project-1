<?php
// Define database connection variables
$servername = "db";       // Hostname of the database server (e.g., Docker service name or localhost)
$username = "root";        // Database username
$password = "root";        // Database password
$dbname = "edoc";          // Name of the database to connect to

// Create a new MySQLi connection
$database = new mysqli($servername, $username, $password, $dbname);

// Check if the connection was successful
if ($database->connect_error) {
    // If there's a connection error, stop execution and display the error message (in French)
    die("Échec de la connexion : " . $database->connect_error);
}
?>
