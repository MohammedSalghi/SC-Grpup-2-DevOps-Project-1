<?php

namespace App\Services;

use App\Common\DatabaseConnection;
use App\Security\InputValidator;
use Exception;

/**
 * Appointment Service Class
 * Handles appointment management with secure database operations
 */
class AppointmentService
{
    private $database;

    public function __construct()
    {
        $this->database = DatabaseConnection::getInstance()->getConnection();
    }

    /**
     * Create new appointment
     * @param int $doctorId
     * @param int $patientId
     * @param string $appointmentDate
     * @param string $appointmentTime
     * @param int $sessionId
     * @return array
     * @throws Exception
     */
    public function create(int $doctorId, int $patientId, string $appointmentDate, string $appointmentTime, int $sessionId): array
    {
        // Validate inputs
        if (!InputValidator::validateDate($appointmentDate)) {
            throw new Exception("Invalid appointment date format");
        }

        if (!InputValidator::validateTime($appointmentTime)) {
            throw new Exception("Invalid appointment time format");
        }

        // Check if doctor exists
        if (!$this->doctorExists($doctorId)) {
            throw new Exception("Doctor not found");
        }

        // Check if patient exists
        if (!$this->patientExists($patientId)) {
            throw new Exception("Patient not found");
        }

        // Check if session exists and is available
        if (!$this->sessionAvailable($sessionId, $appointmentDate)) {
            throw new Exception("Session not available for the selected date");
        }

        // Check for conflicting appointments
        if ($this->hasConflictingAppointment($doctorId, $appointmentDate, $appointmentTime)) {
            throw new Exception("This time slot is already booked");
        }

        try {
            $this->database->begin_transaction();

            // Generate appointment number
            $appointmentNumber = $this->generateAppointmentNumber();

            // Insert appointment
            $stmt = $this->database->prepare(
                "INSERT INTO appointment (pid, apponum, scheduleid, appodate, appotime) VALUES (?, ?, ?, ?, ?)"
            );
            
            $stmt->bind_param("iisss", $patientId, $appointmentNumber, $sessionId, $appointmentDate, $appointmentTime);
            
            if ($stmt->execute()) {
                $appointmentId = $this->database->insert_id;
                $this->database->commit();
                
                return [
                    'success' => true,
                    'appointment_id' => $appointmentId,
                    'appointment_number' => $appointmentNumber,
                    'message' => 'Appointment created successfully'
                ];
            } else {
                throw new Exception("Failed to create appointment");
            }

        } catch (Exception $e) {
            $this->database->rollback();
            error_log("Appointment creation error: " . $e->getMessage());
            throw new Exception("Failed to create appointment: " . $e->getMessage());
        }
    }

    /**
     * Get appointments for today
     * @return array
     */
    public function getTodaysAppointments(): array
    {
        $today = date('Y-m-d');
        
        $stmt = $this->database->prepare("
            SELECT 
                a.appoid,
                a.apponum,
                a.appodate,
                a.appotime,
                p.pname as patient_name,
                p.pemail as patient_email,
                p.ptel as patient_phone,
                d.docname as doctor_name,
                s.title as session_title
            FROM appointment a
            JOIN patient p ON a.pid = p.pid
            JOIN schedule s ON a.scheduleid = s.scheduleid
            JOIN doctor d ON s.docid = d.docid
            WHERE DATE(a.appodate) = ?
            ORDER BY a.appotime ASC
        ");
        
        $stmt->bind_param("s", $today);
        $stmt->execute();
        
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    /**
     * Get appointments by patient ID
     * @param int $patientId
     * @param int $limit
     * @return array
     */
    public function getPatientAppointments(int $patientId, int $limit = 10): array
    {
        $stmt = $this->database->prepare("
            SELECT 
                a.appoid,
                a.apponum,
                a.appodate,
                a.appotime,
                d.docname as doctor_name,
                d.specialties,
                s.title as session_title
            FROM appointment a
            JOIN schedule s ON a.scheduleid = s.scheduleid
            JOIN doctor d ON s.docid = d.docid
            WHERE a.pid = ?
            ORDER BY a.appodate DESC, a.appotime DESC
            LIMIT ?
        ");
        
        $stmt->bind_param("ii", $patientId, $limit);
        $stmt->execute();
        
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    /**
     * Get appointments by doctor ID
     * @param int $doctorId
     * @param string|null $date
     * @return array
     */
    public function getDoctorAppointments(int $doctorId, ?string $date = null): array
    {
        $whereClause = "WHERE d.docid = ?";
        $params = [$doctorId];
        $types = "i";
        
        if ($date) {
            $whereClause .= " AND DATE(a.appodate) = ?";
            $params[] = $date;
            $types .= "s";
        }
        
        $stmt = $this->database->prepare("
            SELECT 
                a.appoid,
                a.apponum,
                a.appodate,
                a.appotime,
                p.pname as patient_name,
                p.pemail as patient_email,
                p.ptel as patient_phone,
                s.title as session_title
            FROM appointment a
            JOIN patient p ON a.pid = p.pid
            JOIN schedule s ON a.scheduleid = s.scheduleid
            JOIN doctor d ON s.docid = d.docid
            $whereClause
            ORDER BY a.appodate ASC, a.appotime ASC
        ");
        
        $stmt->bind_param($types, ...$params);
        $stmt->execute();
        
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    /**
     * Cancel appointment
     * @param int $appointmentId
     * @param int $userId
     * @param string $userType
     * @return bool
     * @throws Exception
     */
    public function cancel(int $appointmentId, int $userId, string $userType): bool
    {
        // Verify user has permission to cancel this appointment
        if (!$this->canCancelAppointment($appointmentId, $userId, $userType)) {
            throw new Exception("You don't have permission to cancel this appointment");
        }

        try {
            $stmt = $this->database->prepare("DELETE FROM appointment WHERE appoid = ?");
            $stmt->bind_param("i", $appointmentId);
            
            return $stmt->execute();
            
        } catch (Exception $e) {
            error_log("Appointment cancellation error: " . $e->getMessage());
            throw new Exception("Failed to cancel appointment");
        }
    }

    /**
     * Get appointment by ID
     * @param int $appointmentId
     * @return array|null
     */
    public function getById(int $appointmentId): ?array
    {
        $stmt = $this->database->prepare("
            SELECT 
                a.*,
                p.pname as patient_name,
                p.pemail as patient_email,
                d.docname as doctor_name,
                s.title as session_title,
                s.scheduletime,
                s.scheduledate
            FROM appointment a
            JOIN patient p ON a.pid = p.pid
            JOIN schedule s ON a.scheduleid = s.scheduleid
            JOIN doctor d ON s.docid = d.docid
            WHERE a.appoid = ?
        ");
        
        $stmt->bind_param("i", $appointmentId);
        $stmt->execute();
        $result = $stmt->get_result();
        
        return $result->num_rows > 0 ? $result->fetch_assoc() : null;
    }

    /**
     * Get available time slots for a session
     * @param int $sessionId
     * @param string $date
     * @return array
     */
    public function getAvailableSlots(int $sessionId, string $date): array
    {
        // Get session details
        $sessionStmt = $this->database->prepare("
            SELECT scheduletime, nop 
            FROM schedule 
            WHERE scheduleid = ? AND scheduledate = ?
        ");
        $sessionStmt->bind_param("is", $sessionId, $date);
        $sessionStmt->execute();
        $session = $sessionStmt->get_result()->fetch_assoc();
        
        if (!$session) {
            return [];
        }

        // Get booked appointments for this session
        $bookedStmt = $this->database->prepare("
            SELECT COUNT(*) as booked_count 
            FROM appointment 
            WHERE scheduleid = ? AND appodate = ?
        ");
        $bookedStmt->bind_param("is", $sessionId, $date);
        $bookedStmt->execute();
        $booked = $bookedStmt->get_result()->fetch_assoc();

        $availableSlots = max(0, $session['nop'] - $booked['booked_count']);
        
        return [
            'session_time' => $session['scheduletime'],
            'total_slots' => $session['nop'],
            'booked_slots' => $booked['booked_count'],
            'available_slots' => $availableSlots
        ];
    }

    /**
     * Check if doctor exists
     * @param int $doctorId
     * @return bool
     */
    private function doctorExists(int $doctorId): bool
    {
        $stmt = $this->database->prepare("SELECT docid FROM doctor WHERE docid = ?");
        $stmt->bind_param("i", $doctorId);
        $stmt->execute();
        
        return $stmt->get_result()->num_rows > 0;
    }

    /**
     * Check if patient exists
     * @param int $patientId
     * @return bool
     */
    private function patientExists(int $patientId): bool
    {
        $stmt = $this->database->prepare("SELECT pid FROM patient WHERE pid = ?");
        $stmt->bind_param("i", $patientId);
        $stmt->execute();
        
        return $stmt->get_result()->num_rows > 0;
    }

    /**
     * Check if session is available
     * @param int $sessionId
     * @param string $date
     * @return bool
     */
    private function sessionAvailable(int $sessionId, string $date): bool
    {
        $stmt = $this->database->prepare("
            SELECT scheduleid FROM schedule 
            WHERE scheduleid = ? AND scheduledate = ? AND scheduledate >= CURDATE()
        ");
        $stmt->bind_param("is", $sessionId, $date);
        $stmt->execute();
        
        return $stmt->get_result()->num_rows > 0;
    }

    /**
     * Check for conflicting appointments
     * @param int $doctorId
     * @param string $date
     * @param string $time
     * @return bool
     */
    private function hasConflictingAppointment(int $doctorId, string $date, string $time): bool
    {
        $stmt = $this->database->prepare("
            SELECT a.appoid 
            FROM appointment a
            JOIN schedule s ON a.scheduleid = s.scheduleid
            WHERE s.docid = ? AND a.appodate = ? AND a.appotime = ?
        ");
        $stmt->bind_param("iss", $doctorId, $date, $time);
        $stmt->execute();
        
        return $stmt->get_result()->num_rows > 0;
    }

    /**
     * Generate unique appointment number
     * @return int
     */
    private function generateAppointmentNumber(): int
    {
        do {
            $number = rand(100000, 999999);
            $stmt = $this->database->prepare("SELECT appoid FROM appointment WHERE apponum = ?");
            $stmt->bind_param("i", $number);
            $stmt->execute();
        } while ($stmt->get_result()->num_rows > 0);
        
        return $number;
    }

    /**
     * Check if user can cancel appointment
     * @param int $appointmentId
     * @param int $userId
     * @param string $userType
     * @return bool
     */
    private function canCancelAppointment(int $appointmentId, int $userId, string $userType): bool
    {
        switch ($userType) {
            case 'p': // Patient
                $stmt = $this->database->prepare("SELECT appoid FROM appointment WHERE appoid = ? AND pid = ?");
                $stmt->bind_param("ii", $appointmentId, $userId);
                break;
                
            case 'd': // Doctor
                $stmt = $this->database->prepare("
                    SELECT a.appoid 
                    FROM appointment a
                    JOIN schedule s ON a.scheduleid = s.scheduleid
                    WHERE a.appoid = ? AND s.docid = ?
                ");
                $stmt->bind_param("ii", $appointmentId, $userId);
                break;
                
            case 'a': // Admin
                return true; // Admin can cancel any appointment
                
            default:
                return false;
        }
        
        $stmt->execute();
        return $stmt->get_result()->num_rows > 0;
    }
}
