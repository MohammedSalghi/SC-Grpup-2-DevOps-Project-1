<?php
/**
 * ORIGINAL VULNERABLE CODE - Assignment 1 Case Study
 * This file demonstrates the SQL injection vulnerability identified in Part B
 * Location: login.php (lines 25-35)
 * Code Smell: SQL Injection Vulnerability (Critical Security Issue)
 */

session_start();

// VULNERABLE CODE - Code Smell #1: SQL Injection
if ($_POST) {
    // No input validation or sanitization
    $email = $_POST['email'];
    $password = $_POST['password'];
    
    // CRITICAL VULNERABILITY: Direct string concatenation in SQL query
    $query = "SELECT * FROM webuser WHERE email = '$email' AND password = '$password'";
    $result = $database->query($query);
    
    if($result->num_rows == 1) {
        $urow = $result->fetch_assoc();
        $_SESSION['user'] = $urow['email'];
        $_SESSION['usertype'] = 'p';
        
        // Redirect based on user type without proper validation
        if ($urow['usertype'] == 'p') {
            header("location: patient/index.php");
        } elseif ($urow['usertype'] == 'd') {
            header("location: doctor/index.php");
        } elseif ($urow['usertype'] == 'a') {
            header("location: admin/index.php");
        }
    } else {
        $error = '<label for="promter" class="form-label" style="color:rgb(255, 62, 62);text-align:center;">Wrong credentials: Invalid email or password</label>';
    }
}

/**
 * SECURITY VULNERABILITIES DEMONSTRATED:
 * 1. SQL Injection: User input directly concatenated into query
 * 2. No input validation or sanitization
 * 3. Plain text password comparison
 * 4. No protection against brute force attacks
 * 5. Session hijacking vulnerabilities
 * 
 * POTENTIAL ATTACKS:
 * - Email: admin@test.com' OR '1'='1' --
 * - Password: anything
 * - Result: Bypass authentication completely
 */
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>eDoc - Login (Vulnerable Version)</title>
    <link rel="stylesheet" href="../css/animations.css">
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="../css/login.css">
</head>
<body>
    <!-- Login form with vulnerable backend processing -->
    <form action="" method="post">
        <div class="container">
            <div class="login-container">
                <h2>Login</h2>
                
                <?php if(isset($error)) echo $error; ?>
                
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" required>
                </div>
                
                <button type="submit" class="login-btn">Login</button>
            </div>
        </div>
    </form>
</body>
</html>
