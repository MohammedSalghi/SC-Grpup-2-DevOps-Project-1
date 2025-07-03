# 🎯 JIRA INTEGRATION TEST
# This script tests and demonstrates Jira integration specifically

Write-Host "🎯 TESTING JIRA INTEGRATION..." -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan

Write-Host "`n📝 Creating commit with different Jira tickets to test detection:" -ForegroundColor Yellow

# Test 1: SCRUM ticket
"Test 1: SCRUM-11 integration test $(Get-Date)" | Out-File jira-test-scrum.txt
git add jira-test-scrum.txt
git commit -m "SCRUM-11: Testing Jira integration with SCRUM ticket"

Write-Host "✅ Test 1: SCRUM-11 ticket committed" -ForegroundColor Green

# Test 2: Different project ticket  
"Test 2: DEV-123 integration test $(Get-Date)" | Out-File jira-test-dev.txt
git add jira-test-dev.txt
git commit -m "DEV-123: Testing Jira integration with DEV ticket"

Write-Host "✅ Test 2: DEV-123 ticket committed" -ForegroundColor Green

Write-Host "`n🚀 Pushing to trigger Jenkins..." -ForegroundColor Yellow
git push

Write-Host "`n🔍 WHAT TO CHECK IN JENKINS BUILD LOGS:" -ForegroundColor Cyan
Write-Host "1. Look for: 'Found Jira issue: DEV-123'" -ForegroundColor White
Write-Host "2. Jira URL: https://mohammedsalghi24.atlassian.net/browse/DEV-123" -ForegroundColor White
Write-Host "3. Build links to the correct Jira ticket" -ForegroundColor White

Write-Host "`n📺 Monitor here:" -ForegroundColor Yellow
Write-Host "🔗 Jenkins: http://localhost:8081/job/SC-Group-2-DevOps-Project-1/lastBuild/console"
Write-Host "🎯 Jira: https://mohammedsalghi24.atlassian.net/browse/DEV-123"

Write-Host "`n✅ JIRA INTEGRATION FEATURES DEMONSTRATED:" -ForegroundColor Green
Write-Host "- Automatic ticket detection from commit messages ✓"
Write-Host "- Support for multiple project prefixes (SCRUM-, DEV-, etc.) ✓"  
Write-Host "- Jenkins logs show detected ticket ✓"
Write-Host "- Build results linked to correct Jira ticket ✓"
# 1. Show current status
docker ps --filter "name=jenkins"

# 2. Trigger live build  
"SCRUM-11: LIVE DEMO $(Get-Date)" | Out-File live-demo.txt
git add . 
git commit -m "SCRUM-11: Live presentation demo"
git push

# 3. Open Jenkins to watch
start http://localhost:8081/job/SC-Group-2-DevOps-Project-1/


# 1. Show Jenkins is running
docker ps --filter "name=jenkins"

# 2. Show recent builds  
docker images mohammedsalghi24/sc-grpup-2-devops-project-1 | Select-Object -First 3

# 3. Trigger live build
"SCRUM-11: Doctor Demo $(Get-Date)" | Out-File doctor-demo.txt
git add doctor-demo.txt
git commit -m "SCRUM-11: Doctor demo - Jenkins working"
git push

# 4. Open Jenkins
Start-Process http://localhost:8081/job/SC-Group-2-DevOps-Project-1/