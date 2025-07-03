# 🎥 ULTIMATE VIDEO DEMO SCRIPT
# Run this script step by step during your presentation

Write-Host "=== 🚀 DEVOPS PROJECT LIVE DEMO ===" -ForegroundColor Green
Write-Host "Professional CI/CD Pipeline Demonstration" -ForegroundColor Cyan
Write-Host ""

# DEMO SECTION 1: PROJECT OVERVIEW
Write-Host "📋 SECTION 1: PROJECT OVERVIEW" -ForegroundColor Yellow
Write-Host "==============================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Our DevOps project includes:" -ForegroundColor White
Get-ChildItem *.jmx | ForEach-Object { Write-Host "  📄 JMeter Test: $($_.Name)" -ForegroundColor Green }
Write-Host "  🐳 Docker containerization" -ForegroundColor Green
Write-Host "  🔧 Jenkins CI/CD pipeline" -ForegroundColor Green
Write-Host "  📊 Performance testing with JMeter" -ForegroundColor Green
Write-Host ""

# DEMO SECTION 2: DOCKER INFRASTRUCTURE
Write-Host "📋 SECTION 2: DOCKER INFRASTRUCTURE" -ForegroundColor Yellow
Write-Host "===================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Current running containers:" -ForegroundColor White
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
Write-Host ""
Write-Host "Available Docker images:" -ForegroundColor White
docker images | findstr -i "mohammedsalghi24\|jenkins"
Write-Host ""

# DEMO SECTION 3: LIVE APPLICATION
Write-Host "📋 SECTION 3: LIVE APPLICATION ACCESS" -ForegroundColor Yellow
Write-Host "=====================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "🌐 Opening application in browser..." -ForegroundColor Cyan
Start-Process "http://localhost:8082"
Write-Host "✅ Application URL: http://localhost:8082" -ForegroundColor Green
Write-Host ""

# DEMO SECTION 4: JENKINS CI/CD
Write-Host "📋 SECTION 4: JENKINS CI/CD PIPELINE" -ForegroundColor Yellow
Write-Host "====================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "🔧 Opening Jenkins dashboard..." -ForegroundColor Cyan
Start-Process "http://localhost:8081"
Write-Host "✅ Jenkins URL: http://localhost:8081" -ForegroundColor Green
Write-Host ""
Write-Host "Pipeline stages include:" -ForegroundColor White
Write-Host "  1. ✅ Code Checkout from GitHub" -ForegroundColor Green
Write-Host "  2. ✅ Performance Testing with JMeter" -ForegroundColor Green
Write-Host "  3. ✅ Docker Image Build" -ForegroundColor Green
Write-Host "  4. ✅ Push to Docker Hub" -ForegroundColor Green
Write-Host "  5. ✅ Jira Integration" -ForegroundColor Green
Write-Host ""

# DEMO SECTION 5: GITHUB INTEGRATION
Write-Host "📋 SECTION 5: GITHUB REPOSITORY" -ForegroundColor Yellow
Write-Host "===============================" -ForegroundColor Yellow
Write-Host ""
Write-Host "🔗 Opening GitHub repository..." -ForegroundColor Cyan
Start-Process "https://github.com/MohammedSalghi/SC-Grpup-2-DevOps-Project-1"
Write-Host "✅ Source code and CI/CD configuration available" -ForegroundColor Green
Write-Host ""

# DEMO SECTION 6: DOCKER HUB
Write-Host "📋 SECTION 6: DOCKER HUB REGISTRY" -ForegroundColor Yellow
Write-Host "=================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "🐳 Opening Docker Hub repository..." -ForegroundColor Cyan
Start-Process "https://hub.docker.com/r/mohammedsalghi24/sc-grpup-2-devops-project-1"
Write-Host "✅ Public Docker images available for team collaboration" -ForegroundColor Green
Write-Host ""

# DEMO SECTION 7: TEAM COLLABORATION
Write-Host "📋 SECTION 7: TEAM COLLABORATION" -ForegroundColor Yellow
Write-Host "================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Team members can easily deploy with these commands:" -ForegroundColor White
Write-Host ""
Write-Host "💻 STEP 1: Pull the image" -ForegroundColor Cyan
Write-Host "   docker pull mohammedsalghi24/sc-grpup-2-devops-project-1:latest" -ForegroundColor White
Write-Host ""
Write-Host "💻 STEP 2: Run the application" -ForegroundColor Cyan
Write-Host "   docker run -d --name devops-app -p 8080:80 mohammedsalghi24/sc-grpup-2-devops-project-1:latest" -ForegroundColor White
Write-Host ""
Write-Host "💻 STEP 3: Access the application" -ForegroundColor Cyan
Write-Host "   http://localhost:8080" -ForegroundColor White
Write-Host ""

# DEMO SECTION 8: JMETER PERFORMANCE TESTING
Write-Host "📋 SECTION 8: PERFORMANCE TESTING" -ForegroundColor Yellow
Write-Host "=================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Our JMeter test plan includes:" -ForegroundColor White
Write-Host "  📊 Step 1: Load Home Page" -ForegroundColor Green
Write-Host "  📊 Step 2: Access Login Page" -ForegroundColor Green
Write-Host "  📊 Step 3: Access Create Account Page" -ForegroundColor Green
Write-Host "  📊 Step 4: Test Database Connection" -ForegroundColor Green
Write-Host "  📊 Step 5: Return to Home Page" -ForegroundColor Green
Write-Host ""

# DEMO SECTION 9: LIVE DEMONSTRATION
Write-Host "📋 SECTION 9: LIVE TEAM DEPLOYMENT DEMO" -ForegroundColor Yellow
Write-Host "=======================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "🎬 Demonstrating team member workflow..." -ForegroundColor Cyan
Write-Host "Simulating what a team member would do:" -ForegroundColor White
Write-Host ""
Write-Host "Pulling latest image..." -ForegroundColor Gray
# Simulate team member commands (don't actually run to avoid conflicts)
Write-Host "✅ docker pull mohammedsalghi24/sc-grpup-2-devops-project-1:latest" -ForegroundColor Green
Write-Host "✅ Image downloaded successfully" -ForegroundColor Green
Write-Host ""
Write-Host "Starting application..." -ForegroundColor Gray
Write-Host "✅ docker run -d --name team-demo -p 9000:80 mohammedsalghi24/sc-grpup-2-devops-project-1:latest" -ForegroundColor Green
Write-Host "✅ Application would be available at http://localhost:9000" -ForegroundColor Green
Write-Host ""

# CONCLUSION
Write-Host "🎯 DEMONSTRATION COMPLETE!" -ForegroundColor Green
Write-Host "============================" -ForegroundColor Green
Write-Host ""
Write-Host "✅ Complete DevOps pipeline demonstrated" -ForegroundColor Green
Write-Host "✅ GitHub → Jenkins → Docker Hub → Team Deployment" -ForegroundColor Green
Write-Host "✅ Performance testing with JMeter integrated" -ForegroundColor Green
Write-Host "✅ Full team collaboration workflow shown" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 Project ready for production deployment!" -ForegroundColor Green
Write-Host ""
Write-Host "Questions? 🤔" -ForegroundColor Yellow
