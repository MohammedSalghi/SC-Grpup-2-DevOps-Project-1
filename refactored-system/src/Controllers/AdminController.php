<?php

namespace App\Controllers;

use App\Services\AuthenticationService;
use App\Services\AppointmentService;
use App\Services\DoctorService;
use App\Common\SessionManager;
use App\Common\TemplateRenderer;
use App\Common\DatabaseConnection;
use App\Security\CSRFProtection;
use App\Security\InputValidator;
use Exception;

/**
 * Admin Controller Class
 * Handles admin panel operations with separated concerns
 */
class AdminController
{
    private $authService;
    private $appointmentService;
    private $doctorService;

    public function __construct()
    {
        $this->authService = new AuthenticationService();
        $this->appointmentService = new AppointmentService();
        $this->doctorService = new DoctorService();
    }

    /**
     * Display admin dashboard
     */
    public function dashboard(): void
    {
        $this->requireAdminAuth();
        
        try {
            $data = [
                'appointments' => $this->appointmentService->getTodaysAppointments(),
                'doctors' => $this->doctorService->getAllDoctors(),
                'totalDoctors' => $this->doctorService->getTotalCount(),
                'totalPatients' => $this->getTotalPatients(),
                'todayAppointments' => count($this->appointmentService->getTodaysAppointments()),
                'user' => $this->authService->getCurrentUser()
            ];
            
            TemplateRenderer::render(
                __DIR__ . '/../../templates/admin/dashboard.php',
                $data,
                'Admin Dashboard - E-Doc',
                ['css/admin.css']
            );
            
        } catch (Exception $e) {
            TemplateRenderer::renderError("Error loading dashboard: " . $e->getMessage());
        }
    }

    /**
     * Handle doctor management
     */
    public function manageDoctors(): void
    {
        $this->requireAdminAuth();
        
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $this->handleDoctorAction();
            return;
        }
        
        try {
            $doctors = $this->doctorService->getAllDoctors();
            
            TemplateRenderer::render(
                __DIR__ . '/../../templates/admin/doctors.php',
                ['doctors' => $doctors],
                'Manage Doctors - E-Doc',
                ['css/admin.css']
            );
            
        } catch (Exception $e) {
            TemplateRenderer::renderError("Error loading doctors: " . $e->getMessage());
        }
    }

    /**
     * Handle appointment scheduling
     */
    public function scheduleAppointment(): void
    {
        $this->requireAdminAuth();
        
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $this->handleAppointmentScheduling();
            return;
        }
        
        try {
            $data = [
                'doctors' => $this->doctorService->getAllDoctors(),
                'patients' => $this->getAllPatients()
            ];
            
            TemplateRenderer::render(
                __DIR__ . '/../../templates/admin/schedule.php',
                $data,
                'Schedule Appointment - E-Doc',
                ['css/admin.css']
            );
            
        } catch (Exception $e) {
            TemplateRenderer::renderError("Error loading schedule page: " . $e->getMessage());
        }
    }

    /**
     * Handle session management
     */
    public function manageSessions(): void
    {
        $this->requireAdminAuth();
        
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $this->handleSessionAction();
            return;
        }
        
        try {
            $sessions = $this->getAllSessions();
            
            TemplateRenderer::render(
                __DIR__ . '/../../templates/admin/sessions.php',
                ['sessions' => $sessions],
                'Manage Sessions - E-Doc',
                ['css/admin.css']
            );
            
        } catch (Exception $e) {
            TemplateRenderer::renderError("Error loading sessions: " . $e->getMessage());
        }
    }

    /**
     * Handle doctor actions (add, edit, delete)
     */
    private function handleDoctorAction(): void
    {
        try {
            // Validate CSRF token
            if (!CSRFProtection::validateRequest($_POST)) {
                throw new Exception("Invalid security token");
            }
            
            $action = $_POST['action'] ?? '';
            
            switch ($action) {
                case 'add':
                    $this->addDoctor();
                    break;
                case 'edit':
                    $this->editDoctor();
                    break;
                case 'delete':
                    $this->deleteDoctor();
                    break;
                default:
                    throw new Exception("Invalid action");
            }
            
        } catch (Exception $e) {
            $this->handleError($e->getMessage());
        }
    }

    /**
     * Add new doctor
     */
    private function addDoctor(): void
    {
        $validation = InputValidator::validate($_POST, [
            'name' => ['required'],
            'email' => ['required', 'email'],
            'password' => ['required'],
            'specialties' => ['required'],
            'phone' => ['phone']
        ]);
        
        if (!$validation['valid']) {
            throw new Exception(implode(', ', array_flatten($validation['errors'])));
        }
        
        $result = $this->doctorService->create($validation['data']);
        
        if ($result['success']) {
            TemplateRenderer::redirect('admin/doctors.php?success=doctor_added');
        } else {
            throw new Exception($result['message']);
        }
    }

    /**
     * Edit doctor
     */
    private function editDoctor(): void
    {
        $doctorId = (int)($_POST['doctor_id'] ?? 0);
        
        if (!$doctorId) {
            throw new Exception("Doctor ID is required");
        }
        
        $validation = InputValidator::validate($_POST, [
            'name' => ['required'],
            'email' => ['required', 'email'],
            'specialties' => ['required'],
            'phone' => ['phone']
        ]);
        
        if (!$validation['valid']) {
            throw new Exception(implode(', ', array_flatten($validation['errors'])));
        }
        
        $result = $this->doctorService->update($doctorId, $validation['data']);
        
        if ($result['success']) {
            TemplateRenderer::redirect('admin/doctors.php?success=doctor_updated');
        } else {
            throw new Exception($result['message']);
        }
    }

    /**
     * Delete doctor
     */
    private function deleteDoctor(): void
    {
        $doctorId = (int)($_POST['doctor_id'] ?? 0);
        
        if (!$doctorId) {
            throw new Exception("Doctor ID is required");
        }
        
        $result = $this->doctorService->delete($doctorId);
        
        if ($result['success']) {
            TemplateRenderer::redirect('admin/doctors.php?success=doctor_deleted');
        } else {
            throw new Exception($result['message']);
        }
    }

    /**
     * Handle appointment scheduling
     */
    private function handleAppointmentScheduling(): void
    {
        try {
            // Validate CSRF token
            if (!CSRFProtection::validateRequest($_POST)) {
                throw new Exception("Invalid security token");
            }
            
            $validation = InputValidator::validate($_POST, [
                'doctor_id' => ['required', 'int'],
                'patient_id' => ['required', 'int'],
                'appointment_date' => ['required', 'date'],
                'appointment_time' => ['required'],
                'session_id' => ['required', 'int']
            ]);
            
            if (!$validation['valid']) {
                throw new Exception(implode(', ', array_flatten($validation['errors'])));
            }
            
            $result = $this->appointmentService->create(
                $validation['data']['doctor_id'],
                $validation['data']['patient_id'],
                $validation['data']['appointment_date'],
                $validation['data']['appointment_time'],
                $validation['data']['session_id']
            );
            
            if ($result['success']) {
                TemplateRenderer::redirect('admin/schedule.php?success=appointment_scheduled');
            } else {
                throw new Exception($result['message']);
            }
            
        } catch (Exception $e) {
            $this->handleError($e->getMessage());
        }
    }

    /**
     * Handle session actions
     */
    private function handleSessionAction(): void
    {
        try {
            // Validate CSRF token
            if (!CSRFProtection::validateRequest($_POST)) {
                throw new Exception("Invalid security token");
            }
            
            $action = $_POST['action'] ?? '';
            
            switch ($action) {
                case 'create':
                    $this->createSession();
                    break;
                case 'delete':
                    $this->deleteSession();
                    break;
                default:
                    throw new Exception("Invalid action");
            }
            
        } catch (Exception $e) {
            $this->handleError($e->getMessage());
        }
    }

    /**
     * Create new session
     */
    private function createSession(): void
    {
        $validation = InputValidator::validate($_POST, [
            'doctor_id' => ['required', 'int'],
            'title' => ['required'],
            'schedule_date' => ['required', 'date'],
            'schedule_time' => ['required'],
            'max_patients' => ['required', 'int']
        ]);
        
        if (!$validation['valid']) {
            throw new Exception(implode(', ', array_flatten($validation['errors'])));
        }
        
        // Create session logic here
        // This would typically involve a SessionService
        TemplateRenderer::redirect('admin/sessions.php?success=session_created');
    }

    /**
     * Delete session
     */
    private function deleteSession(): void
    {
        $sessionId = (int)($_POST['session_id'] ?? 0);
        
        if (!$sessionId) {
            throw new Exception("Session ID is required");
        }
        
        // Delete session logic here
        TemplateRenderer::redirect('admin/sessions.php?success=session_deleted');
    }

    /**
     * Get all patients
     * @return array
     */
    private function getAllPatients(): array
    {
        $db = DatabaseConnection::getInstance()->getConnection();
        $result = $db->query("SELECT pid, pname, pemail FROM patient ORDER BY pname");
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    /**
     * Get total patients count
     * @return int
     */
    private function getTotalPatients(): int
    {
        $db = DatabaseConnection::getInstance()->getConnection();
        $result = $db->query("SELECT COUNT(*) as count FROM patient");
        return $result->fetch_assoc()['count'];
    }

    /**
     * Get all sessions
     * @return array
     */
    private function getAllSessions(): array
    {
        $db = DatabaseConnection::getInstance()->getConnection();
        $result = $db->query("
            SELECT s.*, d.docname 
            FROM schedule s 
            JOIN doctor d ON s.docid = d.docid 
            ORDER BY s.scheduledate DESC, s.scheduletime DESC
        ");
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    /**
     * Require admin authentication
     */
    private function requireAdminAuth(): void
    {
        SessionManager::requireAuth();
        
        if (SessionManager::getCurrentUserType() !== 'a') {
            TemplateRenderer::renderError("Access denied. Admin privileges required.", 403);
            exit;
        }
    }

    /**
     * Handle error response
     * @param string $message
     */
    private function handleError(string $message): void
    {
        if ($_SERVER['HTTP_ACCEPT'] && strpos($_SERVER['HTTP_ACCEPT'], 'application/json') !== false) {
            TemplateRenderer::renderJson([
                'success' => false,
                'message' => $message
            ], 400);
        } else {
            TemplateRenderer::renderError($message);
        }
    }
}

/**
 * Helper function to flatten array
 * @param array $array
 * @return array
 */
function array_flatten(array $array): array
{
    $result = [];
    foreach ($array as $item) {
        if (is_array($item)) {
            $result = array_merge($result, array_flatten($item));
        } else {
            $result[] = $item;
        }
    }
    return $result;
}
