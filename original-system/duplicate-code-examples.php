<?php
/**
 * ORIGINAL DUPLICATE CODE - Assignment 1 Case Study
 * This file demonstrates the code duplication smell identified in Part B
 * Code Smell #3: Duplicate Code (Medium Severity Maintenance Issue)
 * 
 * The following code blocks are REPEATED across multiple files:
 * - admin-panel.php
 * - doctor-panel.php  
 * - patient-panel.php
 * - appointment.php
 * - schedule.php
 */

// DUPLICATE CODE BLOCK #1: Database Connection (Found in 8 files)
include("connection.php");
$db_connection = new mysqli($hostname, $username, $password, $database_name);
if ($db_connection->connect_error) {
    die("Connection failed: " . $db_connection->connect_error);
}

// DUPLICATE CODE BLOCK #2: Session Validation (Found in 6 files)
session_start();
if(!isset($_SESSION['user'])) {
    header("location: ../login.php");
    exit();
}

// DUPLICATE CODE BLOCK #3: HTML Header Generation (Found in 5 files)
function generateHTMLHeader($title = 'eDoc', $cssFiles = []) {
    echo '<!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>' . $title . '</title>
        <link rel="stylesheet" href="../css/animations.css">
        <link rel="stylesheet" href="../css/main.css">
        <link rel="stylesheet" href="../css/admin.css">
    </head>
    <body>';
}

// DUPLICATE CODE BLOCK #4: User Information Retrieval (Found in 4 files)
function getUserInfo($userType, $database) {
    if ($userType == 'admin') {
        $userrow = $database->query("SELECT * FROM admin WHERE aemail='".$_SESSION['user']."'");
    } elseif ($userType == 'doctor') {
        $userrow = $database->query("SELECT * FROM doctor WHERE docemail='".$_SESSION['user']."'");
    } elseif ($userType == 'patient') {
        $userrow = $database->query("SELECT * FROM patient WHERE pemail='".$_SESSION['user']."'");
    }
    return $userrow->fetch_assoc();
}

// DUPLICATE CODE BLOCK #5: Form Validation (Found in 4 files)
function validateForm($data) {
    $errors = [];
    
    if (empty($data['email'])) {
        $errors[] = "Email is required";
    }
    
    if (empty($data['password'])) {
        $errors[] = "Password is required";
    }
    
    if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
        $errors[] = "Invalid email format";
    }
    
    return $errors;
}

// DUPLICATE CODE BLOCK #6: Date/Time Formatting (Found in 3 files)
function formatDateTime($date, $time) {
    $formatted_date = date('Y-m-d', strtotime($date));
    $formatted_time = date('H:i:s', strtotime($time));
    return $formatted_date . ' ' . $formatted_time;
}

// DUPLICATE CODE BLOCK #7: Error Message Display (Found in 5 files)
function displayError($message) {
    echo '<div class="error-message" style="color: red; background: #ffe6e6; padding: 10px; border: 1px solid red; margin: 10px 0;">
            <strong>Error:</strong> ' . htmlspecialchars($message) . '
          </div>';
}

// DUPLICATE CODE BLOCK #8: Success Message Display (Found in 5 files)
function displaySuccess($message) {
    echo '<div class="success-message" style="color: green; background: #e6ffe6; padding: 10px; border: 1px solid green; margin: 10px 0;">
            <strong>Success:</strong> ' . htmlspecialchars($message) . '
          </div>';
}

// DUPLICATE CODE BLOCK #9: Navigation Menu Generation (Found in 3 files)
function generateNavigationMenu($userType, $currentPage) {
    echo '<div class="menu">
            <table class="menu-container">
                <tr>
                    <td style="padding:10px" colspan="2">
                        <table border="0" class="profile-container">
                            <tr>
                                <td width="30%" style="padding-left:20px">
                                    <img src="../img/user.png" alt="" width="100%" style="border-radius:50%">
                                </td>
                                <td style="padding:0px;margin:0px;">
                                    <p class="profile-title">User Name</p>
                                    <p class="profile-subtitle">user@email.com</p>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <a href="../logout.php">
                                        <input type="button" value="Log out" class="logout-btn btn-primary-soft btn">
                                    </a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>';
    
    // Menu items based on user type
    if ($userType == 'admin') {
        echo '<tr class="menu-row">
                <td class="menu-btn">
                    <a href="index.php" class="non-style-link-menu">
                        <div><p class="menu-text">Dashboard</p></div>
                    </a>
                </td>
              </tr>
              <tr class="menu-row">
                <td class="menu-btn">
                    <a href="doctors.php" class="non-style-link-menu">
                        <div><p class="menu-text">Doctors</p></div>
                    </a>
                </td>
              </tr>
              <tr class="menu-row">
                <td class="menu-btn">
                    <a href="patients.php" class="non-style-link-menu">
                        <div><p class="menu-text">Patients</p></div>
                    </a>
                </td>
              </tr>';
    }
    
    echo '</table></div>';
}

// DUPLICATE CODE BLOCK #10: Footer Generation (Found in 5 files)
function generateHTMLFooter($jsFiles = []) {
    foreach ($jsFiles as $js) {
        echo '<script src="' . $js . '"></script>';
    }
    echo '</body></html>';
}

/**
 * PROBLEMS WITH CODE DUPLICATION:
 * 
 * 1. MAINTENANCE OVERHEAD:
 *    - Same code exists in multiple files
 *    - Bug fixes need to be applied in multiple places
 *    - High risk of inconsistent updates
 *    - Increased development time
 * 
 * 2. CONSISTENCY ISSUES:
 *    - Different versions of same functionality
 *    - Behavioral inconsistencies across modules
 *    - Different error handling approaches
 * 
 * 3. CODE BLOAT:
 *    - Unnecessary file size increase
 *    - Reduced readability
 *    - Higher memory usage
 *    - Slower load times
 * 
 * 4. TESTING COMPLEXITY:
 *    - Same functionality tested multiple times
 *    - Harder to ensure complete coverage
 *    - More test maintenance required
 * 
 * 5. REFACTORING DIFFICULTIES:
 *    - Changes require updates in multiple files
 *    - Higher risk of breaking functionality
 *    - Coordination between team members needed
 * 
 * IMPACT ANALYSIS:
 * - Database Connection: Repeated 8 times (87.5% duplication)
 * - Session Validation: Repeated 6 times (83.3% duplication)  
 * - HTML Headers: Repeated 5 times (80% duplication)
 * - Form Validation: Repeated 4 times (75% duplication)
 * 
 * SOLUTION: Extract to common utility classes and configuration files
 * (See refactored-system/ for the improved implementation)
 */
?>
