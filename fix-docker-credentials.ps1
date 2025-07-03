# Fix Docker Hub Credentials in Jenkins
Write-Host "=== FIXING DOCKER HUB CREDENTIALS ===" -ForegroundColor Cyan

Write-Host "Steps to fix Docker Hub credentials in Jenkins:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Open Jenkins: http://localhost:8081" -ForegroundColor Green
Write-Host "2. Go to: Manage Jenkins > Manage Credentials" -ForegroundColor Green
Write-Host "3. Click: (global) > Add Credentials" -ForegroundColor Green
Write-Host "4. Select: Username with password" -ForegroundColor Green
Write-Host "5. Enter:" -ForegroundColor Green
Write-Host "   Username: mohammedsalghi24" -ForegroundColor White
Write-Host "   Password: [Your Docker Hub Password/Token]" -ForegroundColor White
Write-Host "   ID: docker-hub-credentials" -ForegroundColor White
Write-Host "   Description: Docker Hub Login" -ForegroundColor White
Write-Host "6. Click: OK" -ForegroundColor Green
Write-Host ""
Write-Host "Alternative: Use Docker Hub Access Token instead of password" -ForegroundColor Yellow
Write-Host "Generate token at: https://hub.docker.com/settings/security" -ForegroundColor White
Write-Host ""

# Open Jenkins credentials page directly
Start-Process "http://localhost:8081/manage/credentials/"
Write-Host "✓ Opened Jenkins credentials page" -ForegroundColor Green
Write-Host ""
Write-Host "After adding credentials, run: .\test-everything.ps1" -ForegroundColor Cyan
