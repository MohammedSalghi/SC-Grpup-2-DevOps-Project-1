# 🎥 PRESENTATION DEMO COMMANDS
# Use these commands during your presentation to show the working DevOps pipeline

# 1. SHOW CURRENT STATUS
Write-Host "=== CURRENT PIPELINE STATUS ===" -ForegroundColor Cyan
docker ps --filter "name=jenkins"
docker images mohammedsalghi24/sc-grpup-2-devops-project-1 | Select-Object -First 3

# 2. TRIGGER A LIVE BUILD (Main Demo Command)
Write-Host "`n=== TRIGGERING LIVE BUILD FOR DEMO ===" -ForegroundColor Yellow
"SCRUM-11: LIVE PRESENTATION DEMO - $(Get-Date)" | Out-File -FilePath presentation-demo.txt
git add .
git commit -m "SCRUM-11: Live presentation demo build"
git push

# 3. MONITOR THE BUILD
Write-Host "`n=== MONITORING BUILD PROGRESS ===" -ForegroundColor Green
Write-Host "🔗 Jenkins Job: http://localhost:8081/job/SC-Group-2-DevOps-Project-1/"
Write-Host "📺 Latest Build Console: http://localhost:8081/job/SC-Group-2-DevOps-Project-1/lastBuild/console"
Write-Host "🐳 Docker Hub: https://hub.docker.com/r/mohammedsalghi24/sc-grpup-2-devops-project-1"
Write-Host "🎯 Jira Ticket: https://mohammedsalghi24.atlassian.net/browse/SCRUM-11"

# 4. VERIFY RESULTS AFTER BUILD
Write-Host "`n=== VERIFYING RESULTS ===" -ForegroundColor Magenta
# Run this after the build completes
docker images mohammedsalghi24/sc-grpup-2-devops-project-1 | Select-Object -First 2
docker pull mohammedsalghi24/sc-grpup-2-devops-project-1:latest

# 5. SHOW RUNNING SERVICES
Write-Host "`n=== SHOW ALL SERVICES ===" -ForegroundColor Blue
docker ps
Write-Host "🌐 Jenkins: http://localhost:8081"
Write-Host "🌐 App: http://localhost:8082"

# 6. JIRA INTEGRATION DEMO
Write-Host "`n=== JIRA INTEGRATION ===" -ForegroundColor Cyan
Write-Host "✅ Pipeline automatically detects SCRUM-11 from commit message"
Write-Host "✅ Jenkins logs show: 'Found Jira issue: SCRUM-11'"
Write-Host "✅ Build results linked to Jira ticket"
Write-Host "🔗 Check Jira: https://mohammedsalghi24.atlassian.net/browse/SCRUM-11"
