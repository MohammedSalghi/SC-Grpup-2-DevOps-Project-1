# 🎥 VIDEO PRESENTATION - ESSENTIAL TEST COMMANDS
# Quick copy-paste commands for live testing during your 10-minute demo

Write-Host "=== 🎬 ESSENTIAL DEMO COMMANDS FOR VIDEO ===" -ForegroundColor Green
Write-Host "Copy these commands for live testing during presentation" -ForegroundColor Cyan
Write-Host ""

# QUICK STATUS CHECK (30 seconds)
Write-Host "� QUICK STATUS CHECK:" -ForegroundColor Red
Write-Host "docker ps | findstr jenkins" -ForegroundColor White
Write-Host "docker images | findstr mohammedsalghi24" -ForegroundColor White
Write-Host "Start-Process 'http://localhost:8080'" -ForegroundColor White
Write-Host ""

# JENKINS PIPELINE TEST (2 minutes)
Write-Host "📋 JENKINS PIPELINE TEST:" -ForegroundColor Yellow
Write-Host "# 1. Open Jenkins UI and trigger build" -ForegroundColor Cyan
Write-Host "Start-Process 'http://localhost:8080'" -ForegroundColor White
Write-Host "# 2. Go to job → Build Now → Watch progress" -ForegroundColor Cyan
Write-Host ""

Write-Host "📋 PART 2: DOCKER DEMONSTRATION (2 minutes)" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "4. Show Docker images:" -ForegroundColor Cyan
Write-Host "   docker images | findstr mohammedsalghi24" -ForegroundColor Green
Write-Host ""
Write-Host "5. Show running application:" -ForegroundColor Cyan
Write-Host "   Start-Process 'http://localhost:8082'" -ForegroundColor Green
Write-Host ""
Write-Host "6. Show Docker Hub (in browser):" -ForegroundColor Cyan
Write-Host "   Start-Process 'https://hub.docker.com/r/mohammedsalghi24/sc-grpup-2-devops-project-1'" -ForegroundColor Green
Write-Host ""

Write-Host "📋 PART 3: JENKINS CI/CD PIPELINE (3 minutes)" -ForegroundColor Yellow
Write-Host "===============================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "7. Open Jenkins dashboard:" -ForegroundColor Cyan
Write-Host "   Start-Process 'http://localhost:8081'" -ForegroundColor Green
Write-Host ""
Write-Host "8. Show GitHub integration:" -ForegroundColor Cyan
Write-Host "   Start-Process 'https://github.com/MohammedSalghi/SC-Grpup-2-DevOps-Project-1'" -ForegroundColor Green
Write-Host ""
Write-Host "9. Display pipeline configuration:" -ForegroundColor Cyan
Write-Host "   Get-Content Jenkinsfile | Select-String -Pattern 'stage' | Select-Object -First 10" -ForegroundColor Green
Write-Host ""

Write-Host "📋 PART 4: JMETER PERFORMANCE TESTING (2 minutes)" -ForegroundColor Yellow
Write-Host "===================================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "10. Show JMeter test plan details:" -ForegroundColor Cyan
Write-Host "    Get-Content devops-web-app-load-test.jmx | Select-String -Pattern 'testname' | Select-Object -First 5" -ForegroundColor Green
Write-Host ""
Write-Host "11. Run quick JMeter demo (if available):" -ForegroundColor Cyan
Write-Host "    jmeter" -ForegroundColor Green
Write-Host "    # Or show existing results:" -ForegroundColor Gray
Write-Host "    Get-Content performance-summary.txt" -ForegroundColor Green
Write-Host ""

Write-Host "📋 PART 5: TEAM COLLABORATION DEMO (1 minute)" -ForegroundColor Yellow
Write-Host "===============================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "12. Show team pull commands:" -ForegroundColor Cyan
Write-Host "    Write-Host 'Team members can pull with:' -ForegroundColor Yellow" -ForegroundColor Green
Write-Host "    Write-Host 'docker pull mohammedsalghi24/sc-grpup-2-devops-project-1:latest' -ForegroundColor Cyan" -ForegroundColor Green
Write-Host "    Write-Host 'docker run -d --name devops-app -p 8080:80 mohammedsalghi24/sc-grpup-2-devops-project-1:latest' -ForegroundColor Cyan" -ForegroundColor Green
Write-Host ""
Write-Host "13. Show Jira integration:" -ForegroundColor Cyan
Write-Host "    Start-Process 'https://mohammedsalghi24.atlassian.net/'" -ForegroundColor Green
Write-Host ""

# DOCKER HUB TEST (2 minutes)
Write-Host "🐳 DOCKER HUB INTEGRATION TEST:" -ForegroundColor Yellow
Write-Host "# 3. Pull latest image from Docker Hub" -ForegroundColor Cyan
Write-Host "docker pull mohammedsalghi24/sc-grpup-2-devops-project-1:latest" -ForegroundColor White
Write-Host ""
Write-Host "# 4. Run the application" -ForegroundColor Cyan
Write-Host "docker run -d --name demo-app -p 3000:80 mohammedsalghi24/sc-grpup-2-devops-project-1:latest" -ForegroundColor White
Write-Host ""
Write-Host "# 5. Test the running app" -ForegroundColor Cyan
Write-Host "Start-Process 'http://localhost:3000'" -ForegroundColor White
Write-Host ""

# JMETER PERFORMANCE TEST (2 minutes)
Write-Host "⚡ JMETER PERFORMANCE TEST:" -ForegroundColor Yellow
Write-Host "# 6. Run performance test against live app" -ForegroundColor Cyan
Write-Host "jmeter -n -t devops-web-app-load-test.jmx -l quick-results.jtl" -ForegroundColor White
Write-Host ""
Write-Host "# 7. Check results quickly" -ForegroundColor Cyan
Write-Host "Get-Content quick-results.jtl | Select-Object -Last 5" -ForegroundColor White
Write-Host ""

# JENKINS ARTIFACTS (1 minute)
Write-Host "📁 JENKINS ARTIFACTS CHECK:" -ForegroundColor Yellow
Write-Host "# 8. Go to Jenkins → Latest Build → Artifacts" -ForegroundColor Cyan
Write-Host "# 9. Show jmeter-dashboard.html" -ForegroundColor Cyan
Write-Host "# 10. Download performance-summary.txt" -ForegroundColor Cyan
Write-Host ""

# TEAM DEMO (1 minute)
Write-Host "👥 TEAM COLLABORATION DEMO:" -ForegroundColor Yellow
Write-Host "# 11. Show team can pull and run" -ForegroundColor Cyan
Write-Host "docker run -d --name team-demo -p 4000:80 mohammedsalghi24/sc-grpup-2-devops-project-1:latest" -ForegroundColor White
Write-Host "Start-Process 'http://localhost:4000'" -ForegroundColor White
Write-Host ""

# CLEANUP (30 seconds)
Write-Host "🧹 CLEANUP:" -ForegroundColor Red
Write-Host "docker stop demo-app team-demo" -ForegroundColor White
Write-Host "docker rm demo-app team-demo" -ForegroundColor White
Write-Host ""

# EMERGENCY BACKUP COMMANDS
Write-Host "🆘 BACKUP COMMANDS (if something fails):" -ForegroundColor Red
Write-Host "docker restart jenkins-container" -ForegroundColor White
Write-Host "docker pull mohammedsalghi24/sc-grpup-2-devops-project-1:latest" -ForegroundColor White
Write-Host "Start-Process 'http://localhost:8080'" -ForegroundColor White
Write-Host ""

Write-Host "🎯 30-SECOND QUICK TEST:" -ForegroundColor Green
Write-Host "docker pull mohammedsalghi24/sc-grpup-2-devops-project-1:latest && docker run -d --name test -p 5000:80 mohammedsalghi24/sc-grpup-2-devops-project-1:latest && Start-Process 'http://localhost:5000'" -ForegroundColor White

Write-Host "🎯 PRESENTATION FLOW SUMMARY:" -ForegroundColor Yellow
Write-Host "1. Project Structure → 2. Docker → 3. Jenkins → 4. JMeter → 5. Team Collaboration" -ForegroundColor White
Write-Host ""
Write-Host "⏱️ TIMING: 10 minutes total" -ForegroundColor Yellow
Write-Host "🎬 READY FOR YOUR PRESENTATION!" -ForegroundColor Green
