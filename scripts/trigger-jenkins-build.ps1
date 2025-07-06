# Trigger Jenkins Build
# This script triggers a Jenkins build to test the Docker Hub integration

Write-Host "=== Triggering Jenkins Build ===" -ForegroundColor Green
Write-Host ""

# Check if Jenkins is running
$jenkinsRunning = docker ps | Select-String "jenkins"
if ($jenkinsRunning) {
    Write-Host "✓ Jenkins is running" -ForegroundColor Green
} else {
    Write-Host "✗ Jenkins is not running. Start with: docker-compose up -d" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🚀 Triggering Jenkins build..." -ForegroundColor Yellow

# Method 1: Try triggering via REST API
Write-Host "Method 1: REST API trigger" -ForegroundColor Cyan
try {
    # Note: This might need authentication depending on Jenkins security settings
    $response = Invoke-WebRequest -Uri "http://localhost:8081/job/SC-Group-2-DevOps-Project-1/build" -Method Post -TimeoutSec 10
    Write-Host "✓ Build triggered successfully via API" -ForegroundColor Green
} catch {
    Write-Host "⚠️ API trigger failed - Jenkins might need authentication" -ForegroundColor Yellow
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "📋 Manual trigger options:" -ForegroundColor Cyan
Write-Host "1. Open Jenkins: http://localhost:8081"
Write-Host "2. Go to your job: SC-Group-2-DevOps-Project-1"
Write-Host "3. Click 'Build Now'"
Write-Host ""

Write-Host "📊 Monitor build progress:" -ForegroundColor Cyan
Write-Host "1. Check build console: http://localhost:8081/job/SC-Group-2-DevOps-Project-1/lastBuild/console"
Write-Host "2. Watch for Docker push success in logs"
Write-Host "3. Verify new image on Docker Hub"
Write-Host ""

# Open Jenkins job page
Write-Host "🌐 Opening Jenkins job page..." -ForegroundColor Yellow
Start-Process "http://localhost:8081/job/SC-Group-2-DevOps-Project-1/"

Write-Host ""
Write-Host "✅ Build trigger complete!" -ForegroundColor Green
Write-Host "Check Jenkins for build progress and Docker push results."
