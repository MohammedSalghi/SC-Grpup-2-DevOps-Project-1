# 📊 JMETER RESULTS DEMONSTRATION
# Use this script to show JMeter performance testing results

Write-Host "📊 JMETER PERFORMANCE TESTING DEMO" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

Write-Host "`n🔍 Checking JMeter integration..." -ForegroundColor Yellow

# Check if JMeter is available
try {
    $jmeterVersion = jmeter --version 2>&1
    if ($jmeterVersion -match "Apache JMeter") {
        Write-Host "✅ JMeter is installed and available" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️ JMeter not found in PATH, but pipeline will create demo results" -ForegroundColor Yellow
}

# Check for JMeter test file
if (Test-Path "devops-web-app-load-test.jmx") {
    Write-Host "✅ JMeter test file exists: devops-web-app-load-test.jmx" -ForegroundColor Green
} else {
    Write-Host "❌ JMeter test file missing" -ForegroundColor Red
}

Write-Host "`n🚀 To see JMeter results in Jenkins:" -ForegroundColor Yellow
Write-Host "1. Trigger a build (any git push)"
Write-Host "2. Wait for build to complete"
Write-Host "3. Check Jenkins build artifacts"
Write-Host "4. Look for jmeter-results folder"

Write-Host "`n📺 JMeter Results Locations:" -ForegroundColor Cyan
Write-Host "🔗 Jenkins Build: http://localhost:8081/job/SC-Group-2-DevOps-Project-1/lastBuild/"
Write-Host "📦 Build Artifacts: http://localhost:8081/job/SC-Group-2-DevOps-Project-1/lastBuild/artifact/"
Write-Host "📊 JMeter Results: Look for jmeter-results/ folder in artifacts"

Write-Host "`n🎯 JMeter Test Configuration:" -ForegroundColor Green
Write-Host "- Target: http://localhost:8082 (your web app)"
Write-Host "- Users: 5 concurrent users"
Write-Host "- Loops: 3 requests per user"
Write-Host "- Ramp-up: 10 seconds"
Write-Host "- Total Requests: 15 (5 users × 3 loops)"

Write-Host "`n✅ JMeter Results Include:" -ForegroundColor Green
Write-Host "- Response times ✓"
Write-Host "- Throughput ✓"
Write-Host "- Error rates ✓"
Write-Host "- Performance graphs ✓"

Write-Host "`n🔄 Triggering build to generate fresh JMeter results..." -ForegroundColor Yellow
"JMeter Demo Test $(Get-Date)" | Out-File jmeter-demo-test.txt
git add jmeter-demo-test.txt
git commit -m "SCRUM-11: JMeter performance test demo"
git push

Write-Host "`n🏁 Build triggered! Check Jenkins for JMeter results in ~2 minutes" -ForegroundColor Green
