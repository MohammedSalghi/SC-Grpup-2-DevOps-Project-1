# Quick Jenkins Docker Fix Script
Write-Host "🔧 Quick Jenkins Docker Fix - Starting..." -ForegroundColor Yellow

# Stop current Jenkins
Write-Host "⏹️ Stopping current Jenkins container..." -ForegroundColor Blue
docker stop jenkins-server

# Remove old container
Write-Host "🗑️ Removing old Jenkins container..." -ForegroundColor Blue
docker rm jenkins-server

# Start new Jenkins with Docker access
Write-Host "🚀 Starting Jenkins with Docker access..." -ForegroundColor Green
docker run -d `
  --name jenkins-server `
  -p 8081:8080 `
  -p 50000:50000 `
  -v jenkins_home:/var/jenkins_home `
  -v /var/run/docker.sock:/var/run/docker.sock `
  -v //c/Users/HP/SC-Grpup-2-DevOps-Project-1:/workspace `
  --user root `
  jenkins/jenkins:lts

# Wait for Jenkins to start
Write-Host "⏳ Waiting for Jenkins to start (30 seconds)..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Install Docker inside Jenkins container
Write-Host "🐳 Installing Docker inside Jenkins..." -ForegroundColor Blue
docker exec jenkins-server bash -c "apt-get update && apt-get install -y docker.io && usermod -aG docker jenkins"

# Fix permissions
Write-Host "🔐 Fixing Docker permissions..." -ForegroundColor Blue
docker exec jenkins-server bash -c "chmod 666 /var/run/docker.sock"

Write-Host "✅ Jenkins with Docker is ready!" -ForegroundColor Green
Write-Host "🌐 Access Jenkins at: http://localhost:8081" -ForegroundColor Cyan
Write-Host "🔑 If you need the admin password, run: docker exec jenkins-server cat /var/jenkins_home/secrets/initialAdminPassword" -ForegroundColor Yellow
