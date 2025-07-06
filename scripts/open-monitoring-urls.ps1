# 🔗 QUICK URL LAUNCHER
# Opens all the important monitoring URLs in your browser

Write-Host "🔗 OPENING ALL MONITORING URLS..." -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

# Jenkins URLs
Write-Host "`n🏗️ Opening Jenkins URLs..." -ForegroundColor Yellow
Start-Process "http://localhost:8081/job/SC-Group-2-DevOps-Project-1/"
Start-Process "http://localhost:8081/job/SC-Group-2-DevOps-Project-1/lastBuild/console"
Start-Process "http://localhost:8081/job/SC-Group-2-DevOps-Project-1/lastBuild/artifact/"

# Web App
Write-Host "🌐 Opening Web Application..." -ForegroundColor Yellow
Start-Process "http://localhost:8082"

# External services
Write-Host "🌐 Opening External Services..." -ForegroundColor Yellow
Start-Process "https://github.com/MohammedSalghi/SC-Grpup-2-DevOps-Project-1"
Start-Process "https://hub.docker.com/r/mohammedsalghi24/sc-grpup-2-devops-project-1"
Start-Process "https://mohammedsalghi24.atlassian.net/browse/SCRUM-11"

Write-Host "`n✅ All monitoring URLs opened!" -ForegroundColor Green
Write-Host "You can now monitor all aspects of the pipeline in real-time." -ForegroundColor Cyan
