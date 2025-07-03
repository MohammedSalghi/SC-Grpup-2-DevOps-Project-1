# Simple Jenkins Build Monitor
Write-Host "=== JENKINS BUILD MONITOR ===" -ForegroundColor Cyan

Write-Host "Checking Jenkins jobs..." -ForegroundColor Green
Start-Sleep 3

# Check Jenkins main page
Write-Host "Opening Jenkins dashboard..." -ForegroundColor Yellow
Start-Process "http://localhost:8081"

Write-Host ""
Write-Host "Manual checks to perform:" -ForegroundColor Yellow
Write-Host "1. Check if Jenkins triggered a new build" -ForegroundColor White
Write-Host "2. Verify build is running or completed" -ForegroundColor White  
Write-Host "3. Check console output for any errors" -ForegroundColor White
Write-Host "4. Verify Docker image was built and pushed" -ForegroundColor White
Write-Host ""
Write-Host "URLs to check:" -ForegroundColor Yellow
Write-Host "Jenkins: http://localhost:8081" -ForegroundColor White
Write-Host "App: http://localhost:8082" -ForegroundColor White
Write-Host "Docker Hub: https://hub.docker.com/u/mohammedsalghi24" -ForegroundColor White
