# 🎬 SINGLE COMMAND DEMO - Perfect for Presentations!
# Just run this ONE command to demonstrate the entire pipeline

Write-Host "🎥 STARTING LIVE DEVOPS PIPELINE DEMO..." -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

# Create demo file and trigger pipeline
"SCRUM-11: LIVE DEMO - DevOps Pipeline Test $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File -FilePath live-demo.txt -Encoding UTF8

# Commit and push to trigger Jenkins
git add live-demo.txt
git commit -m "SCRUM-11: Live DevOps pipeline demonstration"
git push

Write-Host "`n✅ DEMO TRIGGERED! Now watch:" -ForegroundColor Green
Write-Host "1. 🔗 Jenkins builds automatically: http://localhost:8081/job/SC-Group-2-DevOps-Project-1/" -ForegroundColor Yellow
Write-Host "2. 📺 Watch console logs: http://localhost:8081/job/SC-Group-2-DevOps-Project-1/lastBuild/console" -ForegroundColor Yellow
Write-Host "3. 🐳 Check Docker Hub: https://hub.docker.com/r/mohammedsalghi24/sc-grpup-2-devops-project-1" -ForegroundColor Yellow
Write-Host "4. 🎯 Jira Integration: https://mohammedsalghi24.atlassian.net/browse/SCRUM-11" -ForegroundColor Yellow

Write-Host "`n⏱️ Expected completion: 1-2 minutes" -ForegroundColor Magenta
Write-Host "🎯 This demonstrates: GitHub → Jenkins → Docker → Docker Hub → Jira" -ForegroundColor Cyan

Write-Host "`n🔍 JIRA INTEGRATION FEATURES:" -ForegroundColor Green
Write-Host "✅ Automatic ticket detection from commit message (SCRUM-11)"
Write-Host "✅ Jenkins shows: 'Found Jira issue: SCRUM-11' in build logs"
Write-Host "✅ Build results linked to Jira ticket"
Write-Host "✅ Full traceability: Code → Build → Deployment → Ticket"
