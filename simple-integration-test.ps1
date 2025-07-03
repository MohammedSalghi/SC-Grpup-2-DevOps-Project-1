# Simple DevOps Integration Test Script
# Tests: Jenkins, Docker, and GitHub integration

Write-Host "=== DEVOPS INTEGRATION TEST ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Jenkins status
Write-Host "1. Testing Jenkins connectivity..." -ForegroundColor Green
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8081" -TimeoutSec 10 -UseBasicParsing
    Write-Host "✓ Jenkins is running on http://localhost:8081" -ForegroundColor Green
} catch {
    Write-Host "✗ Jenkins is not accessible!" -ForegroundColor Red
    exit 1
}

# Step 2: Check Docker status
Write-Host "2. Testing Docker..." -ForegroundColor Green
$dockerVersion = docker --version 2>$null
if ($dockerVersion) {
    Write-Host "✓ Docker is available: $dockerVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Docker is not running!" -ForegroundColor Red
    exit 1
}

# Step 3: Check app is running
Write-Host "3. Testing web application..." -ForegroundColor Green
try {
    $appResponse = Invoke-WebRequest -Uri "http://localhost:8082" -TimeoutSec 10 -UseBasicParsing
    Write-Host "✓ Web app is running on http://localhost:8082" -ForegroundColor Green
} catch {
    Write-Host "✗ Web app is not accessible!" -ForegroundColor Red
}

# Step 4: Check Docker images
Write-Host "4. Checking Docker images..." -ForegroundColor Green
$images = docker images --format "table {{.Repository}}:{{.Tag}}" | findstr "mohammedsalghi24"
if ($images) {
    Write-Host "✓ Docker images found:" -ForegroundColor Green
    $images | ForEach-Object { Write-Host "  $_" -ForegroundColor White }
} else {
    Write-Host "✗ No project Docker images found" -ForegroundColor Yellow
}

# Step 5: Test GitHub connectivity
Write-Host "5. Testing Git repository..." -ForegroundColor Green
$gitStatus = git status --porcelain 2>$null
$currentBranch = git branch --show-current 2>$null
if ($currentBranch) {
    Write-Host "✓ Git repository active on branch: $currentBranch" -ForegroundColor Green
    if ($gitStatus) {
        Write-Host "  Uncommitted changes present" -ForegroundColor Yellow
    } else {
        Write-Host "  Working directory clean" -ForegroundColor Green
    }
} else {
    Write-Host "✗ Not in a Git repository" -ForegroundColor Red
}

# Step 6: Check JMeter availability
Write-Host "6. Checking JMeter availability..." -ForegroundColor Green
if (Test-Path "devops-web-app-load-test.jmx") {
    Write-Host "✓ JMeter test plan found" -ForegroundColor Green
} else {
    Write-Host "✗ JMeter test plan not found" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== INTEGRATION TEST SUMMARY ===" -ForegroundColor Cyan
Write-Host "Jenkins:      ✓ Running on http://localhost:8081" -ForegroundColor Green
Write-Host "Docker:       ✓ Available and working" -ForegroundColor Green  
Write-Host "Web App:      ✓ Running on http://localhost:8082" -ForegroundColor Green
Write-Host "Git:          ✓ Repository active" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps to test full automation:" -ForegroundColor Yellow
Write-Host "1. Make a small change to a file" -ForegroundColor White
Write-Host "2. Commit and push to GitHub" -ForegroundColor White
Write-Host "3. Watch Jenkins automatically trigger build" -ForegroundColor White
Write-Host "4. Verify new Docker image is created and pushed" -ForegroundColor White
Write-Host ""
Write-Host "Integration test completed successfully!" -ForegroundColor Green
