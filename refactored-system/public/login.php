<?php

require_once __DIR__ . '/src/Services/AuthenticationService.php';
require_once __DIR__ . '/src/Common/SessionManager.php';
require_once __DIR__ . '/src/Common/TemplateRenderer.php';
require_once __DIR__ . '/src/Security/InputValidator.php';
require_once __DIR__ . '/src/Security/CSRFProtection.php';

use App\Services\AuthenticationService;
use App\Common\SessionManager;
use App\Common\TemplateRenderer;
use App\Security\InputValidator;
use App\Security\CSRFProtection;

// Initialize session
SessionManager::start();

// Redirect if already logged in
if (SessionManager::isAuthenticated()) {
    $userType = SessionManager::getCurrentUserType();
    $redirectUrl = $userType === 'a' ? 'admin/' : ($userType === 'd' ? 'doctor/' : 'patient/');
    TemplateRenderer::redirect($redirectUrl);
}

$error = '';
$success = '';

// Handle form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        // Validate CSRF token
        if (!CSRFProtection::validateRequest($_POST)) {
            throw new Exception("Invalid security token. Please try again.");
        }
        
        // Validate input
        $validation = InputValidator::validate($_POST, [
            'useremail' => ['required', 'email'],
            'userpassword' => ['required']
        ]);
        
        if (!$validation['valid']) {
            throw new Exception(implode(', ', array_flatten($validation['errors'])));
        }
        
        // Authenticate user
        $authService = new AuthenticationService();
        $loginResult = $authService->login(
            $validation['data']['useremail'],
            $validation['data']['userpassword']
        );
        
        if ($loginResult['success']) {
            // Redirect to appropriate dashboard
            TemplateRenderer::redirect($loginResult['redirect']);
        } else {
            throw new Exception("Invalid email or password");
        }
        
    } catch (Exception $e) {
        $error = $e->getMessage();
        error_log("Login error: " . $e->getMessage());
    }
}

// Helper function to flatten array
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

// Render header
TemplateRenderer::renderHeader('Login - E-Doc', ['css/login.css']);
?>

<div class="full-height">
    <center>
        <table border="0">
            <tr>
                <td width="80%">
                    <font class="edoc-logo">eDoc. </font>
                    <font class="edoc-logo-sub">| THE MEDICAL CLINIC MANAGER</font>
                </td>
                <td width="10%">
                    <a href="signup.php" class="non-style-link">
                        <p class="nav-item">SIGNUP</p>
                    </a>
                </td>
                <td width="10%">
                    <a href="login.php" class="non-style-link">
                        <p class="nav-item" style="padding-right: 45px;padding-top: 40px;padding-bottom: 40px;">LOGIN</p>
                    </a>
                </td>
            </tr>
        </table>
    </center>

    <div class="container">
        <table border="0" style="margin: 0;padding: 0;width: 60%;">
            <tr>
                <td>
                    <p class="header-text">Welcome Back!</p>
                </td>
            </tr>
            <div class="form-body">
                <tr>
                    <td>
                        <p class="sub-text">Login with your details to continue</p>
                    </td>
                </tr>
                
                <?php if ($error): ?>
                <tr>
                    <td>
                        <div class="alert alert-error">
                            <?= TemplateRenderer::escape($error) ?>
                        </div>
                    </td>
                </tr>
                <?php endif; ?>
                
                <?php if ($success): ?>
                <tr>
                    <td>
                        <div class="alert alert-success">
                            <?= TemplateRenderer::escape($success) ?>
                        </div>
                    </td>
                </tr>
                <?php endif; ?>
                
                <tr>
                    <form action="login.php" method="POST">
                        <?= CSRFProtection::getTokenField() ?>
                        <td class="label-td">
                            <label for="useremail" class="form-label">Email: </label>
                        </td>
                </tr>
                <tr>
                    <td class="label-td">
                        <input type="email" 
                               name="useremail" 
                               id="useremail"
                               class="input-text" 
                               placeholder="Email Address" 
                               value="<?= TemplateRenderer::escape($_POST['useremail'] ?? '') ?>"
                               required>
                    </td>
                </tr>
                <tr>
                    <td class="label-td">
                        <label for="userpassword" class="form-label">Password: </label>
                    </td>
                </tr>
                <tr>
                    <td class="label-td">
                        <input type="password" 
                               name="userpassword" 
                               id="userpassword"
                               class="input-text" 
                               placeholder="Password" 
                               required>
                    </td>
                </tr>
                <tr>
                    <td><br></td>
                </tr>
                <tr>
                    <td>
                        <input type="submit" value="Login" class="login-btn btn-primary btn">
                    </td>
                </tr>
                </form>
                <tr>
                    <td>
                        <br>
                        <label for="" class="sub-text" style="font-weight: 280;">Don't have an account&#63; </label>
                        <a href="signup.php" class="hover-link1 non-style-link">Sign Up</a>
                        <br><br><br>
                    </td>
                </tr>
            </div>
        </table>
    </div>
</div>

<?php TemplateRenderer::renderFooter(); ?>
