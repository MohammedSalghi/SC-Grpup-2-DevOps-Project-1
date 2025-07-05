<?php

namespace App\Services;

use App\Common\DatabaseConnection;
use App\Security\InputValidator;
use Exception;

/**
 * Doctor Service Class
 * Handles doctor management operations
 */
class DoctorService
{
    private $database;

    public function __construct()
    {
        $this->database = DatabaseConnection::getInstance()->getConnection();
    }

    /**
     * Get all doctors
     * @return array
     */
    public function getAllDoctors(): array
    {
        $stmt = $this->database->prepare("
            SELECT docid, docname, docemail, specialties, doctel 
            FROM doctor 
            ORDER BY docname ASC
        ");
        
        $stmt->execute();
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    /**
     * Get doctor by ID
     * @param int $doctorId
     * @return array|null
     */
    public function getById(int $doctorId): ?array
    {
        $stmt = $this->database->prepare("
            SELECT docid, docname, docemail, specialties, doctel 
            FROM doctor 
            WHERE docid = ?
        ");
        
        $stmt->bind_param("i", $doctorId);
        $stmt->execute();
        $result = $stmt->get_result();
        
        return $result->num_rows > 0 ? $result->fetch_assoc() : null;
    }

    /**
     * Create new doctor
     * @param array $doctorData
     * @return array
     * @throws Exception
     */
    public function create(array $doctorData): array
    {
        // Validate required fields
        $validation = InputValidator::validate($doctorData, [
            'name' => ['required'],
            'email' => ['required', 'email'],
            'password' => ['required'],
            'specialties' => ['required']
        ]);
        
        if (!$validation['valid']) {
            throw new Exception(implode(', ', array_flatten($validation['errors'])));
        }
        
        // Check if email already exists
        if ($this->emailExists($validation['data']['email'])) {
            throw new Exception("Doctor with this email already exists");
        }
        
        try {
            $this->database->begin_transaction();
            
            // Hash password
            $hashedPassword = password_hash($validation['data']['password'], PASSWORD_DEFAULT);
            
            // Insert into doctor table
            $stmt = $this->database->prepare("
                INSERT INTO doctor (docname, docemail, docpassword, specialties, doctel) 
                VALUES (?, ?, ?, ?, ?)
            ");
            
            $phone = $doctorData['phone'] ?? '';
            
            $stmt->bind_param("sssss", 
                $validation['data']['name'],
                $validation['data']['email'],
                $hashedPassword,
                $validation['data']['specialties'],
                $phone
            );
            
            if (!$stmt->execute()) {
                throw new Exception("Failed to create doctor record");
            }
            
            $doctorId = $this->database->insert_id;
            
            // Insert into webuser table
            $webUserStmt = $this->database->prepare("INSERT INTO webuser (email, usertype) VALUES (?, 'd')");
            $webUserStmt->bind_param("s", $validation['data']['email']);
            
            if (!$webUserStmt->execute()) {
                throw new Exception("Failed to create web user record");
            }
            
            $this->database->commit();
            
            return [
                'success' => true,
                'doctor_id' => $doctorId,
                'message' => 'Doctor created successfully'
            ];
            
        } catch (Exception $e) {
            $this->database->rollback();
            error_log("Doctor creation error: " . $e->getMessage());
            throw new Exception("Failed to create doctor: " . $e->getMessage());
        }
    }

    /**
     * Update doctor
     * @param int $doctorId
     * @param array $doctorData
     * @return array
     * @throws Exception
     */
    public function update(int $doctorId, array $doctorData): array
    {
        // Check if doctor exists
        if (!$this->exists($doctorId)) {
            throw new Exception("Doctor not found");
        }
        
        // Validate input
        $validation = InputValidator::validate($doctorData, [
            'name' => ['required'],
            'email' => ['required', 'email'],
            'specialties' => ['required']
        ]);
        
        if (!$validation['valid']) {
            throw new Exception(implode(', ', array_flatten($validation['errors'])));
        }
        
        try {
            $this->database->begin_transaction();
            
            // Update doctor table
            $stmt = $this->database->prepare("
                UPDATE doctor 
                SET docname = ?, docemail = ?, specialties = ?, doctel = ? 
                WHERE docid = ?
            ");
            
            $phone = $doctorData['phone'] ?? '';
            
            $stmt->bind_param("ssssi", 
                $validation['data']['name'],
                $validation['data']['email'],
                $validation['data']['specialties'],
                $phone,
                $doctorId
            );
            
            if (!$stmt->execute()) {
                throw new Exception("Failed to update doctor record");
            }
            
            // Update webuser table if email changed
            $currentDoctor = $this->getById($doctorId);
            if ($currentDoctor && $currentDoctor['docemail'] !== $validation['data']['email']) {
                $webUserStmt = $this->database->prepare("UPDATE webuser SET email = ? WHERE email = ?");
                $webUserStmt->bind_param("ss", $validation['data']['email'], $currentDoctor['docemail']);
                $webUserStmt->execute();
            }
            
            $this->database->commit();
            
            return [
                'success' => true,
                'message' => 'Doctor updated successfully'
            ];
            
        } catch (Exception $e) {
            $this->database->rollback();
            error_log("Doctor update error: " . $e->getMessage());
            throw new Exception("Failed to update doctor: " . $e->getMessage());
        }
    }

    /**
     * Delete doctor
     * @param int $doctorId
     * @return array
     * @throws Exception
     */
    public function delete(int $doctorId): array
    {
        // Check if doctor exists
        $doctor = $this->getById($doctorId);
        if (!$doctor) {
            throw new Exception("Doctor not found");
        }
        
        // Check if doctor has appointments
        if ($this->hasActiveAppointments($doctorId)) {
            throw new Exception("Cannot delete doctor with active appointments");
        }
        
        try {
            $this->database->begin_transaction();
            
            // Delete from doctor table
            $stmt = $this->database->prepare("DELETE FROM doctor WHERE docid = ?");
            $stmt->bind_param("i", $doctorId);
            
            if (!$stmt->execute()) {
                throw new Exception("Failed to delete doctor record");
            }
            
            // Delete from webuser table
            $webUserStmt = $this->database->prepare("DELETE FROM webuser WHERE email = ?");
            $webUserStmt->bind_param("s", $doctor['docemail']);
            $webUserStmt->execute();
            
            $this->database->commit();
            
            return [
                'success' => true,
                'message' => 'Doctor deleted successfully'
            ];
            
        } catch (Exception $e) {
            $this->database->rollback();
            error_log("Doctor deletion error: " . $e->getMessage());
            throw new Exception("Failed to delete doctor: " . $e->getMessage());
        }
    }

    /**
     * Get doctors by specialty
     * @param string $specialty
     * @return array
     */
    public function getBySpecialty(string $specialty): array
    {
        $stmt = $this->database->prepare("
            SELECT docid, docname, docemail, specialties 
            FROM doctor 
            WHERE specialties LIKE ?
            ORDER BY docname ASC
        ");
        
        $searchTerm = "%$specialty%";
        $stmt->bind_param("s", $searchTerm);
        $stmt->execute();
        
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    /**
     * Get total doctors count
     * @return int
     */
    public function getTotalCount(): int
    {
        $result = $this->database->query("SELECT COUNT(*) as count FROM doctor");
        return $result->fetch_assoc()['count'];
    }

    /**
     * Get doctor's schedule
     * @param int $doctorId
     * @param string|null $date
     * @return array
     */
    public function getSchedule(int $doctorId, ?string $date = null): array
    {
        $whereClause = "WHERE docid = ?";
        $params = [$doctorId];
        $types = "i";
        
        if ($date) {
            $whereClause .= " AND scheduledate = ?";
            $params[] = $date;
            $types .= "s";
        }
        
        $stmt = $this->database->prepare("
            SELECT scheduleid, title, scheduledate, scheduletime, nop 
            FROM schedule 
            $whereClause
            ORDER BY scheduledate ASC, scheduletime ASC
        ");
        
        $stmt->bind_param($types, ...$params);
        $stmt->execute();
        
        return $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    }

    /**
     * Check if doctor exists
     * @param int $doctorId
     * @return bool
     */
    private function exists(int $doctorId): bool
    {
        $stmt = $this->database->prepare("SELECT docid FROM doctor WHERE docid = ?");
        $stmt->bind_param("i", $doctorId);
        $stmt->execute();
        
        return $stmt->get_result()->num_rows > 0;
    }

    /**
     * Check if email exists
     * @param string $email
     * @return bool
     */
    private function emailExists(string $email): bool
    {
        $stmt = $this->database->prepare("SELECT docemail FROM doctor WHERE docemail = ?");
        $stmt->bind_param("s", $email);
        $stmt->execute();
        
        return $stmt->get_result()->num_rows > 0;
    }

    /**
     * Check if doctor has active appointments
     * @param int $doctorId
     * @return bool
     */
    private function hasActiveAppointments(int $doctorId): bool
    {
        $stmt = $this->database->prepare("
            SELECT a.appoid 
            FROM appointment a
            JOIN schedule s ON a.scheduleid = s.scheduleid
            WHERE s.docid = ? AND a.appodate >= CURDATE()
            LIMIT 1
        ");
        
        $stmt->bind_param("i", $doctorId);
        $stmt->execute();
        
        return $stmt->get_result()->num_rows > 0;
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
