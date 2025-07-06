# 🚀 QUICK PRESENTER REFERENCE CARD
# Keep this open during your presentation for quick reference and copy-paste commands

# =============== COMMANDS ===============

# 1. CHECK SYSTEM STATUS
Write-Host "--- SYSTEM STATUS COMMANDS ---" -ForegroundColor Cyan
Write-Host "docker ps" -ForegroundColor Yellow
Write-Host "curl http://localhost:8081" -ForegroundColor Yellow
Write-Host "curl http://localhost:8082" -ForegroundColor Yellow
Write-Host "git status" -ForegroundColor Yellow

# 2. OPEN KEY URLS
Write-Host "`n--- OPEN APPLICATION URLS ---" -ForegroundColor Cyan
Write-Host "Start-Process 'http://localhost:8081'" -ForegroundColor Yellow
Write-Host "Start-Process 'http://localhost:8082'" -ForegroundColor Yellow
Write-Host "Start-Process 'https://github.com/MohammedSalghi/SC-Grpup-2-DevOps-Project-1'" -ForegroundColor Yellow
Write-Host "Start-Process 'https://hub.docker.com/r/mohammedsalghi24/sc-grpup-2-devops-project-1'" -ForegroundColor Yellow
Write-Host "Start-Process 'https://mohammedsalghi24.atlassian.net/browse/SCRUM-11'" -ForegroundColor Yellow

# 3. TRIGGER PIPELINE MANUALLY
Write-Host "`n--- TRIGGER PIPELINE MANUALLY ---" -ForegroundColor Cyan
Write-Host @'
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
"SCRUM-11: Manual demo trigger $timestamp" | Out-File "demo-$timestamp.txt"
git add "demo-$timestamp.txt"
git commit -m "SCRUM-11: Manual pipeline demonstration"
git push
'@ -ForegroundColor Yellow

# 4. DOCKER COMMANDS
Write-Host "`n--- DOCKER COMMANDS ---" -ForegroundColor Cyan
Write-Host "docker images | findstr mohammedsalghi24" -ForegroundColor Yellow
Write-Host "docker pull mohammedsalghi24/sc-grpup-2-devops-project-1:latest" -ForegroundColor Yellow
Write-Host "docker run -d --name demo-app -p 3000:80 mohammedsalghi24/sc-grpup-2-devops-project-1:latest" -ForegroundColor Yellow
Write-Host "docker stop demo-app; docker rm demo-app" -ForegroundColor Yellow

# 5. JENKINS BUILD URLS
Write-Host "`n--- JENKINS BUILD URLS ---" -ForegroundColor Cyan
Write-Host "Start-Process 'http://localhost:8081/job/SC-Group-2-DevOps-Project-1/'" -ForegroundColor Yellow
Write-Host "Start-Process 'http://localhost:8081/job/SC-Group-2-DevOps-Project-1/lastBuild/console'" -ForegroundColor Yellow
Write-Host "Start-Process 'http://localhost:8081/job/SC-Group-2-DevOps-Project-1/lastBuild/artifact/'" -ForegroundColor Yellow
Write-Host "Start-Process 'http://localhost:8081/job/SC-Group-2-DevOps-Project-1/lastBuild/artifact/jmeter-results/performance-report.html'" -ForegroundColor Yellow

# =============== TALKING POINTS ===============

Write-Host "`n=== KEY TALKING POINTS ===" -ForegroundColor Magenta

# 1. GitHub Integration
Write-Host "`n--- GITHUB INTEGRATION ---" -ForegroundColor Cyan
Write-Host "• Source code repository for application" -ForegroundColor White
Write-Host "• Webhook triggers Jenkins build on push" -ForegroundColor White
Write-Host "• Commit messages parsed for Jira tickets" -ForegroundColor White
Write-Host "• Code history and audit trail" -ForegroundColor White

# 2. Jenkins Pipeline
Write-Host "`n--- JENKINS PIPELINE ---" -ForegroundColor Cyan
Write-Host "• Automates build, test, and deploy" -ForegroundColor White
Write-Host "• Stages: Quick Build, Fast Docker, JMeter" -ForegroundColor White
Write-Host "• Extracts Jira ticket numbers" -ForegroundColor White
Write-Host "• Archives test results and artifacts" -ForegroundColor White

# 3. Docker Integration
Write-Host "`n--- DOCKER INTEGRATION ---" -ForegroundColor Cyan
Write-Host "• Containerizes application" -ForegroundColor White
Write-Host "• Builds image from Dockerfile" -ForegroundColor White
Write-Host "• Tags with build number and 'latest'" -ForegroundColor White
Write-Host "• Pushes to Docker Hub for distribution" -ForegroundColor White

# 4. JMeter Performance Testing
Write-Host "`n--- JMETER PERFORMANCE TESTING ---" -ForegroundColor Cyan
Write-Host "• Automated load testing" -ForegroundColor White
Write-Host "• Simulates user traffic" -ForegroundColor White
Write-Host "• Measures response times" -ForegroundColor White
Write-Host "• Generates HTML reports with graphs" -ForegroundColor White

# 5. Jira Integration
Write-Host "`n--- JIRA INTEGRATION ---" -ForegroundColor Cyan
Write-Host "• Tracks features and issues" -ForegroundColor White
Write-Host "• Links code changes to tickets" -ForegroundColor White
Write-Host "• Shows build status in tickets" -ForegroundColor White
Write-Host "• Full traceability from requirement to deployment" -ForegroundColor White

# =============== DEMO SCRIPTS ===============

Write-Host "`n=== AVAILABLE DEMO SCRIPTS ===" -ForegroundColor Magenta
Write-Host "• .\interactive-demo-guide.ps1" -ForegroundColor Green
Write-Host "  - Interactive walkthrough with prompts and explanations" -ForegroundColor White

Write-Host "• .\ultimate-pipeline-test.ps1" -ForegroundColor Green
Write-Host "  - Full pipeline test with verification checklist" -ForegroundColor White

Write-Host "• .\demo-live.ps1" -ForegroundColor Green
Write-Host "  - Quick single-command demo" -ForegroundColor White

Write-Host "• .\demo-jmeter.ps1" -ForegroundColor Green
Write-Host "  - Focus on JMeter performance testing" -ForegroundColor White

Write-Host "`n=== HOW TO USE THIS REFERENCE CARD ===" -ForegroundColor Magenta
Write-Host "1. Keep this terminal window open during your presentation" -ForegroundColor White
Write-Host "2. Copy and paste commands as needed" -ForegroundColor White
Write-Host "3. Use talking points to guide your presentation" -ForegroundColor White
Write-Host "4. Run full demo scripts for comprehensive demonstrations" -ForegroundColor White
