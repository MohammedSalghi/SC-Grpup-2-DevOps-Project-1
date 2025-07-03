# 🎬 QUICK REFERENCE CARD - VIDEO DEMO COMMANDS
# Keep this open during your presentation for easy copy-paste

# ===== ESSENTIAL COMMANDS ONLY =====

# 1. PROJECT OVERVIEW
Get-ChildItem *.jmx
docker ps

# 2. OPEN KEY APPLICATIONS
Start-Process "http://localhost:8082"
Start-Process "http://localhost:8081"  
Start-Process "https://github.com/MohammedSalghi/SC-Grpup-2-DevOps-Project-1"
Start-Process "https://hub.docker.com/r/mohammedsalghi24/sc-grpup-2-devops-project-1"

# 3. SHOW DOCKER CAPABILITIES
docker images | findstr mohammedsalghi24
docker pull mohammedsalghi24/sc-grpup-2-devops-project-1:latest
docker run -d --name demo-app -p 3000:80 mohammedsalghi24/sc-grpup-2-devops-project-1:latest

# 4. JMETER DEMONSTRATION
Get-Content devops-web-app-load-test.jmx | Select-String -Pattern "testname" | Select-Object -First 3
jmeter

# 5. TEAM COLLABORATION
Write-Host "Team Pull Command:" -ForegroundColor Yellow
Write-Host "docker pull mohammedsalghi24/sc-grpup-2-devops-project-1:latest" -ForegroundColor Cyan
Write-Host "docker run -d --name devops-app -p 8080:80 mohammedsalghi24/sc-grpup-2-devops-project-1:latest" -ForegroundColor Cyan

# 6. CLEANUP (if needed)
docker stop demo-app; docker rm demo-app
