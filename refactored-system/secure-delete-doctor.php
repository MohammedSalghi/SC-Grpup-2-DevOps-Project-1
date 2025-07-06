<?php
/**
 * REFACTORED: Secure Doctor Deletion
 * Fixes: SQL Injection vulnerability from original admin/delete-doctor.php
 * Implementation: Prepared statements, input validation, transaction safety
 */

require_once '../refactored-system/secure-database.php';
require_once '../refactored-system/error-handler.php';

session_start();

// Authentication check using centralized method
if (!isset($_SESSION["user"]) || empty($_SESSION["user"]) || $_SESSION['usertype'] !== 'a') {
    header("location: ../login.php");
    exit();
}

if (!isset($_GET['id']) || empty($_GET['id'])) {
    header("location: doctors.php?error=invalid_id");
    exit();
}

try {
    global $secureDB;
    
    // Sanitize and validate input
    $doctorId = $secureDB->sanitizeInput($_GET['id'], 'int');
    
    if (!$doctorId || $doctorId <= 0) {
        throw new Exception("Invalid doctor ID provided");
    }
    
    // First, get doctor information to verify existence
    $doctorQuery = "SELECT docid, docemail, docname FROM doctor WHERE docid = ?";
    $doctorResult = $secureDB->select($doctorQuery, [$doctorId], "i");
    
    if (!$doctorResult || $doctorResult->num_rows === 0) {
        throw new Exception("Doctor not found");
    }
    
    $doctor = $doctorResult->fetch_assoc();
    $doctorEmail = $doctor['docemail'];
    $doctorName = $doctor['docname'];
    
    // Log the deletion attempt for audit trail
    ErrorHandler::logError("Admin {$_SESSION['user']} attempting to delete doctor: ID=$doctorId, Email=$doctorEmail, Name=$doctorName");
    
    // Perform deletion using transaction to ensure data integrity
    $deleteResult = $secureDB->transaction(function($db) use ($doctorEmail, $doctorId) {
        
        // Step 1: Delete from webuser table first (foreign key constraint)
        $deleteUserQuery = "DELETE FROM webuser WHERE email = ?";
        $userResult = $db->execute($deleteUserQuery, [$doctorEmail], "s");
        
        if (!$userResult['success']) {
            ErrorHandler::logError("Failed to delete from webuser table for email: $doctorEmail");
            return false;
        }
        
        // Step 2: Delete related appointments and schedules
        // Delete appointments first (foreign key to schedule)
        $deleteAppointmentsQuery = "DELETE a FROM appointment a 
                                   INNER JOIN schedule s ON a.scheduleid = s.scheduleid 
                                   WHERE s.docid = ?";
        $appointmentResult = $db->execute($deleteAppointmentsQuery, [$doctorId], "i");
        
        if (!$appointmentResult['success']) {
            ErrorHandler::logError("Failed to delete appointments for doctor ID: $doctorId");
            return false;
        }
        
        // Delete schedules
        $deleteScheduleQuery = "DELETE FROM schedule WHERE docid = ?";
        $scheduleResult = $db->execute($deleteScheduleQuery, [$doctorId], "i");
        
        if (!$scheduleResult['success']) {
            ErrorHandler::logError("Failed to delete schedules for doctor ID: $doctorId");
            return false;
        }
        
        // Step 3: Finally delete from doctor table
        $deleteDoctorQuery = "DELETE FROM doctor WHERE docid = ?";
        $doctorResult = $db->execute($deleteDoctorQuery, [$doctorId], "i");
        
        if (!$doctorResult['success']) {
            ErrorHandler::logError("Failed to delete from doctor table for ID: $doctorId");
            return false;
        }
        
        return true;
    });
    
    if ($deleteResult) {
        // Success - log and redirect
        ErrorHandler::logError("Successfully deleted doctor: ID=$doctorId, Email=$doctorEmail, Name=$doctorName");
        header("location: doctors.php?success=doctor_deleted&name=" . urlencode($doctorName));
    } else {
        // Transaction failed
        throw new Exception("Failed to delete doctor. Transaction rolled back.");
    }
    
} catch (Exception $e) {
    // Handle all errors consistently
    ErrorHandler::logError("Doctor deletion error: " . $e->getMessage());
    
    // Redirect with error message
    $errorMessage = urlencode("Failed to delete doctor. Please try again.");
    header("location: doctors.php?error=deletion_failed&message=$errorMessage");
}

exit();
?>
