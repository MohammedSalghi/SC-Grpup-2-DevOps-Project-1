# Quick Docker Credentials Fix
Write-Host "DOCKER HUB CREDENTIALS MISSING!" -ForegroundColor Red
Write-Host ""
Write-Host "STEPS TO FIX:" -ForegroundColor Yellow
Write-Host "1. Open Jenkins: http://localhost:8081" -ForegroundColor Green
Write-Host "2. Manage Jenkins > Manage Credentials" -ForegroundColor Green  
Write-Host "3. Add Credentials:" -ForegroundColor Green
Write-Host "   - Username: mohammedsalghi24" -ForegroundColor White
Write-Host "   - Password: [Your Docker Hub Password]" -ForegroundColor White
Write-Host "   - ID: docker-hub-credentials" -ForegroundColor White
Write-Host ""
Start-Process "http://localhost:8081/manage/credentials/"
Write-Host "Credentials page opened!" -ForegroundColor Green
