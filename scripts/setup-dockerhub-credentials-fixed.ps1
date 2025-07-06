# Setup Docker Hub Credentials in Jenkins
# Run this script to verify and guide Docker Hub credential setup

Write-Host "=== Docker Hub Credentials Setup Guide ===" -ForegroundColor Green
Write-Host ""

# Check if Jenkins is running
$jenkinsRunning = docker ps | Select-String "jenkins"
if ($jenkinsRunning) {
    Write-Host "✓ Jenkins is running on port 8081" -ForegroundColor Green
} else {
    Write-Host "✗ Jenkins is not running. Start with: docker-compose up -d" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "📋 Docker Hub Credential Information:" -ForegroundColor Yellow
Write-Host "   Username: mohammedsalghi24"
Write-Host "   Password: [provided separately]"
Write-Host "   Credential ID: dockerhub-credentials"
Write-Host ""

Write-Host "🔧 Steps to add Docker Hub credentials in Jenkins:" -ForegroundColor Cyan
Write-Host "1. Open Jenkins: http://localhost:8081"
Write-Host "2. Go to: Manage Jenkins > Manage Credentials"
Write-Host "3. Click on 'System' under 'Stores scoped to Jenkins'"
Write-Host "4. Click on 'Global credentials (unrestricted)'"
Write-Host "5. Click 'Add Credentials'"
Write-Host "6. Select 'Username with password'"
Write-Host "7. Fill in:"
Write-Host "   - Username: mohammedsalghi24"
Write-Host "   - Password: [your Docker Hub password]"
Write-Host "   - ID: dockerhub-credentials"
Write-Host "   - Description: Docker Hub Credentials"
Write-Host "8. Click 'OK'"
Write-Host ""

Write-Host "📱 Quick verification commands:" -ForegroundColor Cyan
Write-Host "After setting up credentials, run:"
Write-Host "   .\test-docker-credentials.ps1"
Write-Host "   .\trigger-jenkins-build.ps1"
Write-Host ""

# Open Jenkins credentials page
Write-Host "🌐 Opening Jenkins credentials page..." -ForegroundColor Yellow
Start-Process "http://localhost:8081/manage/credentials/store/system/domain/_/"

Write-Host ""
Write-Host "✅ Setup guide complete!" -ForegroundColor Green
Write-Host "Next: Add the credentials manually in Jenkins, then test the pipeline."
