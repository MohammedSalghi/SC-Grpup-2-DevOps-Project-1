# Test Docker Hub Credentials
# This script tests if Docker Hub credentials are properly configured

Write-Host "=== Testing Docker Hub Credentials ===" -ForegroundColor Green
Write-Host ""

# Test 1: Check if we can login to Docker Hub manually
Write-Host "🔍 Test 1: Manual Docker Hub login test" -ForegroundColor Yellow
Write-Host "Username: mohammedsalghi24"
Write-Host "Run this command to test manual login:"
Write-Host "   docker login -u mohammedsalghi24" -ForegroundColor Cyan
Write-Host ""

# Test 2: Check if image exists on Docker Hub
Write-Host "🔍 Test 2: Check if image exists on Docker Hub" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "https://hub.docker.com/v2/repositories/mohammedsalghi24/sc-grpup-2-devops-project-1/" -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        Write-Host "✓ Docker Hub repository exists and is accessible" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️ Repository might be private or not exist yet" -ForegroundColor Yellow
}

# Test 3: Try pulling the image
Write-Host ""
Write-Host "🔍 Test 3: Try pulling existing image" -ForegroundColor Yellow
try {
    docker pull mohammedsalghi24/sc-grpup-2-devops-project-1:latest
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Successfully pulled image from Docker Hub" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Could not pull image - might need authentication" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠️ Error pulling image" -ForegroundColor Yellow
}

# Test 4: Check local Docker images
Write-Host ""
Write-Host "🔍 Test 4: Local Docker images" -ForegroundColor Yellow
$images = docker images | Select-String "mohammedsalghi24"
if ($images) {
    Write-Host "✓ Found local images:" -ForegroundColor Green
    docker images | Select-String "mohammedsalghi24"
} else {
    Write-Host "⚠️ No local images found for mohammedsalghi24" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📋 Next steps if credentials are working:" -ForegroundColor Cyan
Write-Host "1. Trigger a Jenkins build:"
Write-Host "   .\trigger-jenkins-build.ps1"
Write-Host "2. Check build logs for Docker push success"
Write-Host "3. Verify new image appears on Docker Hub"
Write-Host ""

Write-Host "✅ Credential test complete!" -ForegroundColor Green
