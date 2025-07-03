# Quick DevOps Integration Check
Write-Host "=== DEVOPS SYSTEM CHECK ===" -ForegroundColor Cyan

# Check Jenkins
Write-Host "Checking Jenkins..." -ForegroundColor Green
docker ps | findstr jenkins
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Jenkins container is running" -ForegroundColor Green
} else {
    Write-Host "✗ Jenkins container not found" -ForegroundColor Red
}

# Check App
Write-Host "Checking web app..." -ForegroundColor Green  
docker ps | findstr sc-grpup2
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Web app container is running" -ForegroundColor Green
} else {
    Write-Host "✗ Web app container not found" -ForegroundColor Red
}

# Check Docker images
Write-Host "Checking Docker images..." -ForegroundColor Green
docker images | findstr mohammedsalghi24

# Check Git status
Write-Host "Checking Git..." -ForegroundColor Green
git status --short

Write-Host ""
Write-Host "System check complete!" -ForegroundColor Green
Write-Host "Jenkins: http://localhost:8081" -ForegroundColor Yellow
Write-Host "App: http://localhost:8082" -ForegroundColor Yellow
