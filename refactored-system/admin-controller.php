<?php
/**
 * REFACTORED: Admin Panel Architecture
 * Fixes: God Object/Large Class (Code Smell #2)
 * Implementation: Modular architecture with separation of concerns
 */

require_once 'secure-database.php';
require_once 'error-handler.php';

/**
 * Authentication Manager - Handles user authentication and authorization
 */
class AuthManager {
    private $db;
    
    public function __construct($database) {
        $this->db = $database;
    }
    
    public function validateSession($requiredUserType = null) {
        session_start();
        
        if (!isset($_SESSION["user"]) || empty($_SESSION["user"])) {
            header("location: ../login.php");
            exit();
        }
        
        if ($requiredUserType && $_SESSION['usertype'] !== $requiredUserType) {
            header("location: ../login.php");
            exit();
        }
        
        return true;
    }
    
    public function getCurrentUser() {
        return [
            'email' => $_SESSION["user"] ?? '',
            'type' => $_SESSION["usertype"] ?? '',
            'username' => $_SESSION["username"] ?? ''
        ];
    }
    
    public function logout() {
        session_start();
        session_destroy();
        header("location: ../login.php");
        exit();
    }
}

/**
 * Doctor Manager - Handles doctor-related operations
 */
class DoctorManager {
    private $db;
    
    public function __construct($database) {
        $this->db = $database;
    }
    
    public function getAllDoctors($limit = null) {
        $query = "SELECT d.*, s.sname as specialty_name 
                  FROM doctor d 
                  LEFT JOIN specialties s ON d.specialties = s.id 
                  ORDER BY d.docid DESC";
        
        if ($limit) {
            $query .= " LIMIT ?";
            return $this->db->select($query, [$limit], "i");
        }
        
        return $this->db->select($query);
    }
    
    public function getDoctorById($id) {
        $query = "SELECT d.*, s.sname as specialty_name 
                  FROM doctor d 
                  LEFT JOIN specialties s ON d.specialties = s.id 
                  WHERE d.docid = ?";
        
        $result = $this->db->select($query, [$id], "i");
        return $result ? $result->fetch_assoc() : null;
    }
    
    public function addDoctor($data) {
        // Validate input
        $errors = ErrorHandler::validateInput($data, [
            'name' => ['required'],
            'email' => ['required', 'email'],
            'password' => ['required'],
            'specialties' => ['required']
        ]);
        
        if (!empty($errors)) {
            return ['success' => false, 'errors' => $errors];
        }
        
        // Check if email already exists
        $existing = $this->db->select("SELECT * FROM webuser WHERE email = ?", [$data['email']], "s");
        if ($existing && $existing->num_rows > 0) {
            return ['success' => false, 'error' => ErrorHandler::getError('validation', 'email_exists')];
        }
        
        // Use transaction for data integrity
        return $this->db->transaction(function($db) use ($data) {
            // Insert into doctor table
            $doctorQuery = "INSERT INTO doctor (docemail, docname, docpassword, docnic, doctel, specialties) 
                           VALUES (?, ?, ?, ?, ?, ?)";
            $doctorResult = $db->execute($doctorQuery, [
                $data['email'],
                $data['name'], 
                password_hash($data['password'], PASSWORD_DEFAULT), // Secure password hashing
                $data['nic'],
                $data['tel'],
                $data['specialties']
            ], "sssssi");
            
            if (!$doctorResult['success']) {
                return false;
            }
            
            // Insert into webuser table
            $userQuery = "INSERT INTO webuser (email, usertype) VALUES (?, 'd')";
            $userResult = $db->execute($userQuery, [$data['email']], "s");
            
            return $userResult['success'];
        });
    }
    
    public function deleteDoctor($id) {
        // Validate input
        $id = $this->db->sanitizeInput($id, 'int');
        if (!$id) {
            return ['success' => false, 'error' => 'Invalid doctor ID'];
        }
        
        // Get doctor email first
        $doctor = $this->getDoctorById($id);
        if (!$doctor) {
            return ['success' => false, 'error' => ErrorHandler::getError('database', 'record_not_found')];
        }
        
        // Use transaction for data integrity
        return $this->db->transaction(function($db) use ($doctor) {
            // Delete from webuser table
            $userResult = $db->execute("DELETE FROM webuser WHERE email = ?", [$doctor['docemail']], "s");
            
            if (!$userResult['success']) {
                return false;
            }
            
            // Delete from doctor table
            $doctorResult = $db->execute("DELETE FROM doctor WHERE docemail = ?", [$doctor['docemail']], "s");
            
            return $doctorResult['success'];
        });
    }
    
    public function searchDoctors($searchTerm) {
        $query = "SELECT d.*, s.sname as specialty_name 
                  FROM doctor d 
                  LEFT JOIN specialties s ON d.specialties = s.id 
                  WHERE d.docname LIKE ? OR d.docemail LIKE ?
                  ORDER BY d.docname ASC";
        
        $searchParam = "%$searchTerm%";
        return $this->db->select($query, [$searchParam, $searchParam], "ss");
    }
}

/**
 * Appointment Manager - Handles appointment operations
 */
class AppointmentManager {
    private $db;
    
    public function __construct($database) {
        $this->db = $database;
    }
    
    public function getUpcomingAppointments($limit = 10) {
        $today = date('Y-m-d');
        $query = "SELECT a.appoid, a.apponum, a.appodate, 
                         s.scheduleid, s.title, s.scheduledate, s.scheduletime,
                         d.docname, p.pname
                  FROM appointment a
                  INNER JOIN schedule s ON a.scheduleid = s.scheduleid
                  INNER JOIN doctor d ON s.docid = d.docid
                  INNER JOIN patient p ON a.pid = p.pid
                  WHERE a.appodate >= ?
                  ORDER BY a.appodate ASC, s.scheduletime ASC
                  LIMIT ?";
        
        return $this->db->select($query, [$today, $limit], "si");
    }
    
    public function getAppointmentsByDateRange($startDate, $endDate) {
        $query = "SELECT a.appoid, a.apponum, a.appodate,
                         s.scheduleid, s.title, s.scheduledate, s.scheduletime,
                         d.docname, p.pname
                  FROM appointment a
                  INNER JOIN schedule s ON a.scheduleid = s.scheduleid
                  INNER JOIN doctor d ON s.docid = d.docid
                  INNER JOIN patient p ON a.pid = p.pid
                  WHERE a.appodate BETWEEN ? AND ?
                  ORDER BY a.appodate ASC, s.scheduletime ASC";
        
        return $this->db->select($query, [$startDate, $endDate], "ss");
    }
    
    public function deleteAppointment($id) {
        $id = $this->db->sanitizeInput($id, 'int');
        if (!$id) {
            return ['success' => false, 'error' => 'Invalid appointment ID'];
        }
        
        $result = $this->db->execute("DELETE FROM appointment WHERE appoid = ?", [$id], "i");
        return $result;
    }
}

/**
 * Dashboard Data Provider - Provides dashboard statistics
 */
class DashboardDataProvider {
    private $db;
    
    public function __construct($database) {
        $this->db = $database;
    }
    
    public function getDashboardStats() {
        $today = date('Y-m-d');
        $nextWeek = date('Y-m-d', strtotime('+1 week'));
        
        // Get counts efficiently in a single query
        $stats = [];
        
        // Doctor count
        $result = $this->db->select("SELECT COUNT(*) as count FROM doctor");
        $stats['total_doctors'] = $result ? $result->fetch_assoc()['count'] : 0;
        
        // Patient count
        $result = $this->db->select("SELECT COUNT(*) as count FROM patient");
        $stats['total_patients'] = $result ? $result->fetch_assoc()['count'] : 0;
        
        // Today's appointments
        $result = $this->db->select("SELECT COUNT(*) as count FROM appointment WHERE appodate = ?", [$today], "s");
        $stats['today_appointments'] = $result ? $result->fetch_assoc()['count'] : 0;
        
        // This week's sessions
        $result = $this->db->select("SELECT COUNT(*) as count FROM schedule WHERE scheduledate BETWEEN ? AND ?", 
                                   [$today, $nextWeek], "ss");
        $stats['week_sessions'] = $result ? $result->fetch_assoc()['count'] : 0;
        
        return $stats;
    }
}

/**
 * Main Admin Controller - Orchestrates all admin operations
 */
class AdminController {
    private $auth;
    private $doctorManager;
    private $appointmentManager;
    private $dashboardData;
    private $db;
    
    public function __construct() {
        global $secureDB;
        $this->db = $secureDB;
        $this->auth = new AuthManager($this->db);
        $this->doctorManager = new DoctorManager($this->db);
        $this->appointmentManager = new AppointmentManager($this->db);
        $this->dashboardData = new DashboardDataProvider($this->db);
    }
    
    public function handleRequest() {
        // Validate admin session
        $this->auth->validateSession('a');
        
        // Route requests based on action
        $action = $_GET['action'] ?? 'dashboard';
        
        switch ($action) {
            case 'dashboard':
                return $this->renderDashboard();
            case 'doctors':
                return $this->handleDoctorActions();
            case 'appointments':
                return $this->handleAppointmentActions();
            default:
                return $this->renderDashboard();
        }
    }
    
    private function renderDashboard() {
        $stats = $this->dashboardData->getDashboardStats();
        $upcomingAppointments = $this->appointmentManager->getUpcomingAppointments(5);
        
        return [
            'template' => 'dashboard',
            'data' => [
                'stats' => $stats,
                'appointments' => $upcomingAppointments,
                'user' => $this->auth->getCurrentUser()
            ]
        ];
    }
    
    private function handleDoctorActions() {
        $subAction = $_POST['sub_action'] ?? $_GET['sub_action'] ?? 'list';
        
        switch ($subAction) {
            case 'add':
                if ($_POST) {
                    $result = $this->doctorManager->addDoctor($_POST);
                    return ['action' => 'add_doctor', 'result' => $result];
                }
                break;
            case 'delete':
                $id = $_GET['id'] ?? null;
                if ($id) {
                    $result = $this->doctorManager->deleteDoctor($id);
                    return ['action' => 'delete_doctor', 'result' => $result];
                }
                break;
            case 'search':
                $searchTerm = $_GET['search'] ?? '';
                $doctors = $this->doctorManager->searchDoctors($searchTerm);
                return ['action' => 'search_doctors', 'doctors' => $doctors];
            default:
                $doctors = $this->doctorManager->getAllDoctors();
                return ['action' => 'list_doctors', 'doctors' => $doctors];
        }
    }
    
    private function handleAppointmentActions() {
        $subAction = $_GET['sub_action'] ?? 'list';
        
        switch ($subAction) {
            case 'delete':
                $id = $_GET['id'] ?? null;
                if ($id) {
                    $result = $this->appointmentManager->deleteAppointment($id);
                    return ['action' => 'delete_appointment', 'result' => $result];
                }
                break;
            default:
                $appointments = $this->appointmentManager->getUpcomingAppointments(20);
                return ['action' => 'list_appointments', 'appointments' => $appointments];
        }
    }
}
?>
