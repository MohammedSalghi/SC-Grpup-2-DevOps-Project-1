<?php

require_once __DIR__ . '/autoload.php';

use App\Common\TemplateRenderer;
use App\Common\SessionManager;

// Start session
SessionManager::start();

// Check if user is logged in and redirect accordingly
if (SessionManager::isAuthenticated()) {
    $userType = SessionManager::getCurrentUserType();
    
    switch ($userType) {
        case 'a':
            TemplateRenderer::redirect('admin/dashboard.php');
            break;
        case 'd':
            TemplateRenderer::redirect('doctor/dashboard.php');
            break;
        case 'p':
            TemplateRenderer::redirect('patient/dashboard.php');
            break;
        default:
            TemplateRenderer::redirect('login.php');
    }
} else {
    // Redirect to login page
    TemplateRenderer::redirect('login.php');
}
