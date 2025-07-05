<?php

/**
 * Simple PSR-4 Autoloader
 * Maps App\ namespace to src/ directory
 */
spl_autoload_register(function ($class) {
    // Base directory for the namespace prefix
    $baseDir = __DIR__ . '/src/';
    
    // Does the class use the namespace prefix?
    $prefix = 'App\\';
    $len = strlen($prefix);
    
    if (strncmp($prefix, $class, $len) !== 0) {
        // Move to the next registered autoloader
        return;
    }
    
    // Get the relative class name
    $relativeClass = substr($class, $len);
    
    // Replace the namespace prefix with the base directory,
    // replace namespace separators with directory separators
    // in the relative class name, append with .php
    $file = $baseDir . str_replace('\\', '/', $relativeClass) . '.php';
    
    // If the file exists, require it
    if (file_exists($file)) {
        require $file;
    }
});
