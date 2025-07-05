<?php

namespace App\Common;

/**
 * Template Renderer Class
 * Handles consistent template rendering with security headers
 */
class TemplateRenderer
{
    private static $securityHeaders = [
        'X-Content-Type-Options: nosniff',
        'X-Frame-Options: DENY',
        'X-XSS-Protection: 1; mode=block',
        'Content-Security-Policy: default-src \'self\'; script-src \'self\' \'unsafe-inline\'; style-src \'self\' \'unsafe-inline\';'
    ];

    /**
     * Render HTML header with security settings
     * @param string $title
     * @param array $cssFiles
     * @param array $metaTags
     */
    public static function renderHeader(string $title = 'E-Doc', array $cssFiles = [], array $metaTags = []): void
    {
        // Set security headers
        foreach (self::$securityHeaders as $header) {
            header($header);
        }
        
        // Set content type
        header('Content-Type: text/html; charset=UTF-8');
        
        // Default CSS files
        $defaultCss = [
            'css/animations.css',
            'css/main.css'
        ];
        
        $allCss = array_merge($defaultCss, $cssFiles);
        
        echo '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">';
    
        // Render additional meta tags
        foreach ($metaTags as $name => $content) {
            echo '<meta name="' . htmlspecialchars($name) . '" content="' . htmlspecialchars($content) . '">';
        }
        
        echo '<title>' . htmlspecialchars($title) . '</title>';
        
        // Render CSS files
        foreach ($allCss as $css) {
            echo '<link rel="stylesheet" href="' . htmlspecialchars($css) . '">';
        }
        
        echo '</head><body>';
    }

    /**
     * Render HTML footer with JavaScript files
     * @param array $jsFiles
     */
    public static function renderFooter(array $jsFiles = []): void
    {
        // Render JavaScript files
        foreach ($jsFiles as $js) {
            echo '<script src="' . htmlspecialchars($js) . '"></script>';
        }
        
        echo '</body></html>';
    }

    /**
     * Render a complete template
     * @param string $templatePath
     * @param array $data
     * @param string $title
     * @param array $cssFiles
     * @param array $jsFiles
     */
    public static function render(string $templatePath, array $data = [], string $title = 'E-Doc', array $cssFiles = [], array $jsFiles = []): void
    {
        // Extract data for template
        extract($data);
        
        // Start output buffering
        ob_start();
        
        // Include template file
        if (file_exists($templatePath)) {
            include $templatePath;
        } else {
            throw new \Exception("Template file not found: $templatePath");
        }
        
        // Get template content
        $content = ob_get_clean();
        
        // Render complete page
        self::renderHeader($title, $cssFiles);
        echo $content;
        self::renderFooter($jsFiles);
    }

    /**
     * Render JSON response
     * @param array $data
     * @param int $statusCode
     */
    public static function renderJson(array $data, int $statusCode = 200): void
    {
        http_response_code($statusCode);
        header('Content-Type: application/json');
        echo json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
        exit;
    }

    /**
     * Render error page
     * @param string $message
     * @param int $statusCode
     */
    public static function renderError(string $message, int $statusCode = 500): void
    {
        http_response_code($statusCode);
        
        self::renderHeader("Error $statusCode");
        
        echo '<div class="error-container">
            <h1>Error ' . $statusCode . '</h1>
            <p>' . htmlspecialchars($message) . '</p>
            <a href="/" class="btn">Go Home</a>
        </div>';
        
        self::renderFooter();
    }

    /**
     * Redirect to another page
     * @param string $url
     * @param int $statusCode
     */
    public static function redirect(string $url, int $statusCode = 302): void
    {
        http_response_code($statusCode);
        header("Location: $url");
        exit;
    }

    /**
     * Render alert message
     * @param string $message
     * @param string $type (success, error, warning, info)
     * @return string
     */
    public static function renderAlert(string $message, string $type = 'info'): string
    {
        $alertClass = 'alert alert-' . htmlspecialchars($type);
        return '<div class="' . $alertClass . '">' . htmlspecialchars($message) . '</div>';
    }

    /**
     * Sanitize output for display
     * @param string $text
     * @return string
     */
    public static function escape(string $text): string
    {
        return htmlspecialchars($text, ENT_QUOTES, 'UTF-8');
    }

    /**
     * Format date for display
     * @param string $date
     * @param string $format
     * @return string
     */
    public static function formatDate(string $date, string $format = 'Y-m-d H:i:s'): string
    {
        $dateTime = new \DateTime($date);
        return $dateTime->format($format);
    }

    /**
     * Generate CSRF token field
     * @return string
     */
    public static function csrfField(): string
    {
        $token = \App\Security\CSRFProtection::generateToken();
        return '<input type="hidden" name="_token" value="' . htmlspecialchars($token) . '">';
    }
}
