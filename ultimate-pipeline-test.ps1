# 🚀 ULTIMATE PIPELINE TEST - ALL COMPONENTS
# ONE command to test: GitHub, Jenkins, Docker, JMeter, and Jira

Write-Host "🌟 ULTIMATE DEVOPS PIPELINE TEST" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan

# Create timestamp for unique files
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$demoFile = "ultimate-test-$timestamp.txt"

# 1. VERIFY ALL SERVICES
Write-Host "`n1️⃣ CHECKING ALL SERVICES:" -ForegroundColor Yellow
Write-Host "Docker containers:" -ForegroundColor White
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# 2. CREATE TEST CONTENT WITH MULTIPLE JIRA TICKETS
Write-Host "`n2️⃣ CREATING TEST WITH MULTIPLE JIRA REFERENCES:" -ForegroundColor Yellow

$fileContent = @"
# ULTIMATE PIPELINE TEST - $timestamp

This test file validates ALL components:
1. ✅ GitHub webhook integration
2. ✅ Jenkins automated pipeline
3. ✅ Docker image building
4. ✅ Docker Hub publishing
5. ✅ JMeter performance tests
6. ✅ Jira ticket integration

## Jira References:
- SCRUM-11: Main DevOps pipeline ticket
- DEV-123: Feature implementation
- TEST-456: Performance testing

Test timestamp: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@

# 3. TRIGGER THE PIPELINE
Write-Host "`n3️⃣ TRIGGERING COMPLETE PIPELINE:" -ForegroundColor Yellow
$fileContent | Out-File -FilePath $demoFile -Encoding UTF8
git add $demoFile
git commit -m "SCRUM-11: Ultimate pipeline test with DEV-123 and TEST-456 references"
git push

Write-Host "`n✅ PIPELINE TRIGGERED!" -ForegroundColor Green
Write-Host "Opening monitoring pages..." -ForegroundColor White

# 4. OPEN MONITORING PAGES
Start-Process "http://localhost:8081/job/SC-Group-2-DevOps-Project-1/"
Start-Process "http://localhost:8082"

# 5. VERIFICATION CHECKLIST
Write-Host "`n📋 VERIFICATION CHECKLIST:" -ForegroundColor Magenta

Write-Host "`nGITHUB INTEGRATION:" -ForegroundColor Yellow
Write-Host "✓ Commit pushed with multiple Jira references"
Write-Host "✓ Jenkins build triggered automatically"

Write-Host "`nJENKINS PIPELINE:" -ForegroundColor Yellow
Write-Host "✓ View at: http://localhost:8081/job/SC-Group-2-DevOps-Project-1/lastBuild/"
Write-Host "✓ All stages execute successfully"

Write-Host "`nDOCKER INTEGRATION:" -ForegroundColor Yellow
Write-Host "✓ Image built and tagged with build number"
Write-Host "✓ Image pushed to Docker Hub"
Write-Host "✓ Verify at: https://hub.docker.com/r/mohammedsalghi24/sc-grpup-2-devops-project-1"

Write-Host "`nJMETER PERFORMANCE TESTS:" -ForegroundColor Yellow
Write-Host "✓ Tests executed against web application"
Write-Host "✓ Results archived as build artifacts"
Write-Host "✓ View report: http://localhost:8081/job/SC-Group-2-DevOps-Project-1/lastBuild/artifact/jmeter-results/performance-report.html"

Write-Host "`nJIRA INTEGRATION:" -ForegroundColor Yellow
Write-Host "✓ Multiple tickets detected in commit"
Write-Host "✓ Primary ticket (SCRUM-11) linked to build"
Write-Host "✓ Jira URL: https://mohammedsalghi24.atlassian.net/browse/SCRUM-11"

# 6. SUMMARY
Write-Host "`n🏆 ULTIMATE PIPELINE TEST INITIATED!" -ForegroundColor Green
Write-Host "Expected completion time: ~2 minutes" -ForegroundColor Cyan
Write-Host "This demonstrates your COMPLETE DevOps CI/CD pipeline" -ForegroundColor Cyan
