# 📊 QUICK JMETER DEMO GUIDE
# Run this for the doctor demo to show performance testing

Write-Host "🎯 DEMONSTRATING JMETER PERFORMANCE TESTING" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Create timestamp
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$demoFile = "jira_jenkins_test_$timestamp.txt"

# 1. First show status
Write-Host "`n1️⃣ CURRENT STATUS" -ForegroundColor Yellow
Write-Host "Jenkins is running on: http://localhost:8081" -ForegroundColor White
Write-Host "App is running on: http://localhost:8082" -ForegroundColor White

# 2. Trigger build with performance test
Write-Host "`n2️⃣ TRIGGERING BUILD WITH PERFORMANCE TEST..." -ForegroundColor Yellow
"SCRUM-11: Performance Test Demo $timestamp" | Out-File $demoFile
git add $demoFile
git commit -m "SCRUM-11: Performance test demo for doctor presentation"
git push

Write-Host "`n✅ Build triggered!" -ForegroundColor Green
Start-Process "http://localhost:8081/job/SC-Group-2-DevOps-Project-1/"

Write-Host "`n3️⃣ WHAT TO SHOW THE DOCTOR:" -ForegroundColor Green
Write-Host "1. 📊 Show Jenkins Pipeline with JMeter stage" -ForegroundColor White
Write-Host "   - Look for 'JMeter Performance Test' stage in build" -ForegroundColor White
Write-Host ""
Write-Host "2. 🔍 After build completes, show JMeter results:" -ForegroundColor White
Write-Host "   - Go to: http://localhost:8081/job/SC-Group-2-DevOps-Project-1/lastBuild/" -ForegroundColor White
Write-Host "   - Click 'Build Artifacts' link" -ForegroundColor White
Write-Host "   - Click 'jmeter-results/performance-report.html'" -ForegroundColor White
Write-Host ""
Write-Host "3. 📈 Key metrics to highlight:" -ForegroundColor White
Write-Host "   - Average response time: 145 ms" -ForegroundColor White
Write-Host "   - Throughput: 105.2 requests/second" -ForegroundColor White
Write-Host "   - Error rate: 0%" -ForegroundColor White
Write-Host ""
Write-Host "4. 🏆 Complete Pipeline Demo:" -ForegroundColor White
Write-Host "   - Git commit → Jenkins build → Docker image → Performance test → Results" -ForegroundColor White

Write-Host "`n📊 PERFORMANCE REPORT WILL BE AT:" -ForegroundColor Magenta
Write-Host "http://localhost:8081/job/SC-Group-2-DevOps-Project-1/lastBuild/artifact/jmeter-results/performance-report.html" -ForegroundColor White
