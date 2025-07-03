# Team Member Guide: Pulling and Running Docker Image from Docker Hub
# Instructions for team members to get the latest version of our DevOps project

Write-Host "=== 🐳 DOCKER HUB DEPLOYMENT GUIDE FOR TEAM MEMBERS ===" -ForegroundColor Green
Write-Host "Follow these steps to run the project on your workstation" -ForegroundColor Cyan
Write-Host ""

Write-Host "📋 PREREQUISITES:" -ForegroundColor Yellow
Write-Host "✅ Docker Desktop installed and running" -ForegroundColor White
Write-Host "✅ Internet connection" -ForegroundColor White
Write-Host "✅ Basic command line access" -ForegroundColor White
Write-Host ""

Write-Host "🚀 STEP 1: PULL THE LATEST IMAGE" -ForegroundColor Yellow
Write-Host "Run this command to download the latest version:" -ForegroundColor Cyan
Write-Host "docker pull mohammedsalghi24/sc-grpup-2-devops-project-1:latest" -ForegroundColor Green
Write-Host ""

Write-Host "🔍 STEP 2: VERIFY THE IMAGE" -ForegroundColor Yellow
Write-Host "Check that the image was downloaded successfully:" -ForegroundColor Cyan
Write-Host "docker images | grep mohammedsalghi24/sc-grpup-2-devops-project-1" -ForegroundColor Green
Write-Host ""

Write-Host "▶️ STEP 3: RUN THE APPLICATION" -ForegroundColor Yellow
Write-Host "Start the application container:" -ForegroundColor Cyan
Write-Host "docker run -d --name devops-app -p 8080:80 mohammedsalghi24/sc-grpup-2-devops-project-1:latest" -ForegroundColor Green
Write-Host ""

Write-Host "🌐 STEP 4: ACCESS THE APPLICATION" -ForegroundColor Yellow
Write-Host "Open your browser and go to:" -ForegroundColor Cyan
Write-Host "http://localhost:8080" -ForegroundColor Green
Write-Host ""

Write-Host "📊 OPTIONAL: RUN WITH CUSTOM PORT" -ForegroundColor Yellow
Write-Host "If port 8080 is busy, use a different port:" -ForegroundColor Cyan
Write-Host "docker run -d --name devops-app -p 3000:80 mohammedsalghi24/sc-grpup-2-devops-project-1:latest" -ForegroundColor Green
Write-Host "Then access via: http://localhost:3000" -ForegroundColor Green
Write-Host ""

Write-Host "🔄 STEP 5: STOP/START/RESTART" -ForegroundColor Yellow
Write-Host "Manage the container:" -ForegroundColor Cyan
Write-Host "docker stop devops-app       # Stop the container" -ForegroundColor Green
Write-Host "docker start devops-app      # Start the container" -ForegroundColor Green
Write-Host "docker restart devops-app    # Restart the container" -ForegroundColor Green
Write-Host ""

Write-Host "🗑️ STEP 6: CLEANUP (OPTIONAL)" -ForegroundColor Yellow
Write-Host "Remove container and image when done:" -ForegroundColor Cyan
Write-Host "docker stop devops-app && docker rm devops-app" -ForegroundColor Green
Write-Host "docker rmi mohammedsalghi24/sc-grpup-2-devops-project-1:latest" -ForegroundColor Green
Write-Host ""

Write-Host "🏷️ STEP 7: PULL SPECIFIC VERSION (OPTIONAL)" -ForegroundColor Yellow
Write-Host "To get a specific build version:" -ForegroundColor Cyan
Write-Host "docker pull mohammedsalghi24/sc-grpup-2-devops-project-1:15" -ForegroundColor Green
Write-Host "docker pull mohammedsalghi24/sc-grpup-2-devops-project-1:16" -ForegroundColor Green
Write-Host ""

Write-Host "🚨 TROUBLESHOOTING:" -ForegroundColor Yellow
Write-Host "If you encounter issues:" -ForegroundColor Cyan
Write-Host "• Check Docker is running: docker --version" -ForegroundColor White
Write-Host "• Check container status: docker ps -a" -ForegroundColor White
Write-Host "• View container logs: docker logs devops-app" -ForegroundColor White
Write-Host "• Check port availability: netstat -an | findstr :8080" -ForegroundColor White
Write-Host ""

Write-Host "✨ READY TO COLLABORATE! ✨" -ForegroundColor Green
