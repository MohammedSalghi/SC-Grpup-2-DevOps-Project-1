# 🎬 FINAL DEMO COMMANDS FOR PRESENTATION
# Use these commands to demonstrate working Jenkins pipeline to your doctor

Write-Host "🎯 JENKINS PIPELINE DEMONSTRATION" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

Write-Host "`n1️⃣ SHOW CURRENT STATUS" -ForegroundColor Yellow
Write-Host "Services running:" -ForegroundColor Green
docker ps --filter "name=jenkins"
docker ps --filter "name=sc-grpup2-test"

Write-Host "`n📊 Recent builds:" -ForegroundColor Green
docker images mohammedsalghi24/sc-grpup-2-devops-project-1 | Select-Object -First 3

Write-Host "`n2️⃣ TRIGGER LIVE BUILD" -ForegroundColor Yellow
Write-Host "Creating demo file and triggering pipeline..." -ForegroundColor Green
"SCRUM-11: LIVE DOCTOR DEMO - DevOps Pipeline Working $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File doctor-demo.txt
git add doctor-demo.txt
git commit -m "SCRUM-11: Doctor demonstration - full pipeline test"
git push

Write-Host "`n3️⃣ OPEN JENKINS TO WATCH" -ForegroundColor Yellow
Write-Host "Opening Jenkins in browser..." -ForegroundColor Green
start http://localhost:8081/job/SC-Group-2-DevOps-Project-1/

Write-Host "`n4️⃣ WHAT TO SHOW THE DOCTOR:" -ForegroundColor Cyan
Write-Host "✅ GitHub Push → Jenkins automatically triggered" -ForegroundColor Green
Write-Host "✅ Jenkins builds Docker image" -ForegroundColor Green
Write-Host "✅ Docker image pushed to Docker Hub" -ForegroundColor Green
Write-Host "✅ JMeter performance tests executed" -ForegroundColor Green
Write-Host "✅ Jira ticket integration (SCRUM-11)" -ForegroundColor Green
Write-Host "✅ Build completes in under 2 minutes" -ForegroundColor Green

Write-Host "`n🔗 URLS TO SHOW:" -ForegroundColor Yellow
Write-Host "Jenkins: http://localhost:8081/job/SC-Group-2-DevOps-Project-1/"
Write-Host "Build Console: http://localhost:8081/job/SC-Group-2-DevOps-Project-1/lastBuild/console"
Write-Host "Docker Hub: https://hub.docker.com/r/mohammedsalghi24/sc-grpup-2-devops-project-1"
Write-Host "Jira: https://mohammedsalghi24.atlassian.net/browse/SCRUM-11"
Write-Host "Running App: http://localhost:8082"

Write-Host "`n⏱️ EXPECTED TIMELINE:" -ForegroundColor Magenta
Write-Host "0:00 - Git push triggers Jenkins"
Write-Host "0:30 - Jenkins starts building"
Write-Host "1:00 - Docker image building"
Write-Host "1:30 - JMeter tests running"
Write-Host "2:00 - Build complete, image pushed"

Write-Host "`n🏆 DEMONSTRATION COMPLETE!" -ForegroundColor Green
