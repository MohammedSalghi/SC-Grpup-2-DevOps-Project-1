Write-Host "=== DevOps Pipeline Status Check ===" -ForegroundColor Green
Write-Host ""

# Check Jenkins
Write-Host "Checking Jenkins..." -ForegroundColor Yellow
$jenkinsContainer = docker ps | Select-String "jenkins"
if ($jenkinsContainer) {
    Write-Host "✓ Jenkins is running on port 8081" -ForegroundColor Green
} else {
    Write-Host "✗ Jenkins is not running" -ForegroundColor Red
}

# Check Docker images
Write-Host ""
Write-Host "Checking Docker images..." -ForegroundColor Yellow
$images = docker images | Select-String "mohammedsalghi24"
if ($images) {
    Write-Host "✓ Found Docker images:" -ForegroundColor Green
    docker images | Select-String "mohammedsalghi24"
} else {
    Write-Host "⚠ No local images found for mohammedsalghi24" -ForegroundColor Yellow
}

# Check running containers
Write-Host ""
Write-Host "Checking running containers..." -ForegroundColor Yellow
$containers = docker ps
Write-Host $containers

Write-Host ""
Write-Host "Key URLs:" -ForegroundColor Cyan
Write-Host "- Jenkins: http://localhost:8081"
Write-Host "- App: http://localhost:8082"
Write-Host "- Jenkins Credentials: http://localhost:8081/manage/credentials/"
Write-Host "- Jenkins Job: http://localhost:8081/job/SC-Group-2-DevOps-Project-1/"

Write-Host ""
Write-Host "Next steps after adding Docker Hub credentials:" -ForegroundColor Yellow
Write-Host "1. Trigger a build in Jenkins"
Write-Host "2. Monitor build logs for Docker push success"
Write-Host "3. Verify image appears on Docker Hub"
Write-Host "4. Test full integration with .\test-everything.ps1"
