<?php
/**
 * ORIGINAL GOD OBJECT CODE - Assignment 1 Case Study
 * This file demonstrates the God Object code smell identified in Part B
 * Location: admin-panel.php (650+ lines)
 * Code Smell: God Object/Large Class (High Severity Structural Issue)
 */

session_start();

// GOD OBJECT - Code Smell #2: Single file doing everything
include("connection.php");

// MIXED RESPONSIBILITIES IN ONE FILE:
// 1. Database connection handling
$database = new mysqli($hostname, $username, $password, $database);
if ($database->connect_error) {
    die("Connection failed: " . $database->connect_error);
}

// 2. Authentication logic
if(!isset($_SESSION['user'])) {
    header("location: ../login.php");
    exit();
}

// 3. Session management
$userrow = $database->query("SELECT * FROM admin WHERE aemail='".$_SESSION['user']."'");
$userfetch = $userrow->fetch_assoc();
$userid = $userfetch['aemail'];
$username = $userfetch['aname'];

// 4. Business logic for appointments (MASSIVE CODE BLOCK)
if($_POST) {
    // Appointment scheduling logic (50+ lines)
    if(isset($_POST['shedulesubmit'])) {
        $title = $_POST['title'];
        $docid = $_POST['docid'];
        $nop = $_POST['nop'];
        $date = $_POST['date'];
        $time = $_POST['time'];
        
        // Another SQL injection vulnerability
        $sql = "INSERT INTO schedule (docid, title, scheduledate, scheduletime, nop) 
                VALUES ('$docid', '$title', '$date', '$time', '$nop')";
        $database->query($sql);
    }
    
    // Doctor addition logic (40+ lines)
    if(isset($_POST['addnew'])) {
        $name = $_POST['name'];
        $email = $_POST['email'];
        $spec = $_POST['spec'];
        $password = $_POST['password'];
        
        // More vulnerable SQL
        $sql = "INSERT INTO doctor (docname, docemail, specialties, docpassword) 
                VALUES ('$name', '$email', '$spec', '$password')";
        $database->query($sql);
    }
    
    // Session management logic (60+ lines)
    if(isset($_POST['sessionsubmit'])) {
        $docid = $_POST['docid'];
        $title = $_POST['title'];
        $date = $_POST['date'];
        $time = $_POST['time'];
        $nop = $_POST['nop'];
        
        // Even more vulnerable SQL
        $sql = "INSERT INTO schedule (docid, title, scheduledate, scheduletime, nop) 
                VALUES ('$docid', '$title', '$date', '$time', '$nop')";
        $result = $database->query($sql);
    }
}

// 5. Data retrieval logic (100+ lines)
$sqlmain = "SELECT * FROM appointment WHERE appodate >= '" . date('Y-m-d') . "' ORDER BY appodate ASC";
$result = $database->query($sqlmain);

$sqlmain2 = "SELECT * FROM doctor ORDER BY docid DESC";
$result2 = $database->query($sqlmain2);

$sqlmain3 = "SELECT * FROM patient ORDER BY pid DESC";
$result3 = $database->query($sqlmain3);

$sqlmain4 = "SELECT COUNT(*) FROM doctor";
$result4 = $database->query($sqlmain4);
$docrow = $result4->fetch_assoc();

$sqlmain5 = "SELECT COUNT(*) FROM patient";
$result5 = $database->query($sqlmain5);
$patrow = $result5->fetch_assoc();

$sqlmain6 = "SELECT COUNT(*) FROM appointment WHERE appodate >= '" . date('Y-m-d') . "'";
$result6 = $database->query($sqlmain6);
$approw = $result6->fetch_assoc();

// 6. HTML generation starts here (400+ lines of mixed PHP and HTML)
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel - eDoc (God Object Version)</title>
    <link rel="stylesheet" href="../css/animations.css">
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="../css/admin.css">
</head>
<body>
    <!-- MASSIVE HTML CONTENT MIXED WITH PHP LOGIC -->
    <div class="container">
        <div class="menu">
            <table class="menu-container">
                <tr>
                    <td style="padding:10px" colspan="2">
                        <table border="0" class="profile-container">
                            <tr>
                                <td width="30%" style="padding-left:20px">
                                    <img src="../img/user.png" alt="" width="100%" style="border-radius:50%">
                                </td>
                                <td style="padding:0px;margin:0px;">
                                    <p class="profile-title"><?php echo substr($username,0,13) ?>..</p>
                                    <p class="profile-subtitle"><?php echo substr($userid,0,22) ?></p>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <a href="../logout.php"><input type="button" value="Log out" class="logout-btn btn-primary-soft btn"></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <!-- Menu items with inline PHP logic -->
                <tr class="menu-row">
                    <td class="menu-btn menu-icon-dashbord menu-active menu-icon-dashbord-active">
                        <a href="index.php" class="non-style-link-menu non-style-link-menu-active">
                            <div><p class="menu-text">Dashboard</p></div>
                        </a>
                    </td>
                </tr>
                <!-- More menu items... -->
            </table>
        </div>
        
        <!-- DASHBOARD CONTENT WITH EMBEDDED PHP -->
        <div class="dash-body">
            <table border="0" width="100%" style="border-spacing: 0;margin:0;padding:0;">
                <tr>
                    <td colspan="2" class="nav-bar">
                        <p class="nav-bar-text">Dashboard</p>
                    </td>
                    <td width="15%">
                        <p style="font-size: 14px;color: rgb(119, 119, 119);padding: 0;margin: 0;text-align: right;">
                            Today's Date: <?php echo date('Y-m-d'); ?>
                        </p>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <div class="stats-container">
                            <!-- Statistics cards with embedded queries -->
                            <div class="stats-card">
                                <h3>Total Doctors</h3>
                                <p class="stats-number"><?php echo $docrow['COUNT(*)']; ?></p>
                            </div>
                            <div class="stats-card">
                                <h3>Total Patients</h3>
                                <p class="stats-number"><?php echo $patrow['COUNT(*)']; ?></p>
                            </div>
                            <div class="stats-card">
                                <h3>Upcoming Appointments</h3>
                                <p class="stats-number"><?php echo $approw['COUNT(*)']; ?></p>
                            </div>
                        </div>
                    </td>
                </tr>
                
                <!-- COMPLEX FORMS AND DATA TABLES (300+ more lines) -->
                <tr>
                    <td colspan="3">
                        <div class="appointments-section">
                            <h3>Recent Appointments</h3>
                            <table class="appointments-table">
                                <tr>
                                    <th>Appointment ID</th>
                                    <th>Patient Name</th>
                                    <th>Doctor Name</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Actions</th>
                                </tr>
                                <?php
                                // Inline query processing
                                if($result->num_rows == 0) {
                                    echo '<tr><td colspan="6">No appointments found</td></tr>';
                                } else {
                                    while($row = $result->fetch_assoc()) {
                                        $appoid = $row['appoid'];
                                        $pid = $row['pid'];
                                        $docid = $row['docid'];
                                        
                                        // More vulnerable queries inline
                                        $patient_query = "SELECT * FROM patient WHERE pid = '$pid'";
                                        $patient_result = $database->query($patient_query);
                                        $patient = $patient_result->fetch_assoc();
                                        
                                        $doctor_query = "SELECT * FROM doctor WHERE docid = '$docid'";
                                        $doctor_result = $database->query($doctor_query);
                                        $doctor = $doctor_result->fetch_assoc();
                                        
                                        echo '<tr>';
                                        echo '<td>' . $appoid . '</td>';
                                        echo '<td>' . $patient['pname'] . '</td>';
                                        echo '<td>' . $doctor['docname'] . '</td>';
                                        echo '<td>' . $row['appodate'] . '</td>';
                                        echo '<td>' . $row['appotime'] . '</td>';
                                        echo '<td><button onclick="deleteAppointment(' . $appoid . ')">Delete</button></td>';
                                        echo '</tr>';
                                    }
                                }
                                ?>
                            </table>
                        </div>
                    </td>
                </tr>
                
                <!-- MORE FORMS AND COMPLEX LOGIC CONTINUES... -->
            </table>
        </div>
    </div>
    
    <script>
        // Inline JavaScript mixed with PHP
        function deleteAppointment(id) {
            if(confirm('Are you sure?')) {
                window.location.href = 'delete-appointment.php?id=' + id;
            }
        }
    </script>
</body>
</html>

<?php
/**
 * PROBLEMS WITH THIS GOD OBJECT:
 * 
 * 1. SINGLE RESPONSIBILITY VIOLATION:
 *    - Database connection management
 *    - Authentication and session handling
 *    - Business logic for appointments, doctors, patients
 *    - Data retrieval and processing
 *    - HTML generation and presentation
 *    - Form processing and validation
 * 
 * 2. MAINTENANCE ISSUES:
 *    - 650+ lines in single file
 *    - Mixed concerns make debugging difficult
 *    - Hard to test individual components
 *    - Changes affect multiple functionalities
 * 
 * 3. SECURITY VULNERABILITIES:
 *    - Multiple SQL injection points
 *    - No input validation
 *    - Session security weaknesses
 * 
 * 4. PERFORMANCE ISSUES:
 *    - Multiple database connections
 *    - Inefficient query patterns
 *    - No caching mechanisms
 * 
 * 5. CODE REUSABILITY:
 *    - Logic tied to specific context
 *    - Duplicate code across similar files
 *    - No modular components
 */
?>
