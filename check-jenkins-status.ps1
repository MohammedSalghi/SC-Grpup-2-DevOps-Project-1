Write-Host "🚀 Jenkins Build Status Check" -ForegroundColor Green
Write-Host "============================" -ForegroundColor Green

# Check latest commit
Write-Host "`n📝 Latest Commit:" -ForegroundColor Yellow
$latestCommit = git log --oneline -1
Write-Host "   $latestCommit" -ForegroundColor Cyan

# Check if commit contains Jira issue
if ($latestCommit -match "SCRUM-\d+") {
    Write-Host "✅ Jira issue detected in commit" -ForegroundColor Green
} else {
    Write-Host "❌ No Jira issue found in commit" -ForegroundColor Red
}

# Check Docker status
Write-Host "`n🐳 Docker Jenkins Container:" -ForegroundColor Yellow
$dockerStatus = docker ps --filter "name=jenkins" --format "{{.Names}}: {{.Status}}"
Write-Host "   $dockerStatus" -ForegroundColor Cyan

# Try to check Jenkins job status (basic check)
Write-Host "`n🔧 Jenkins Access:" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8081" -TimeoutSec 3
    Write-Host "   ✅ Jenkins accessible (Status: $($response.StatusCode))" -ForegroundColor Green
} catch {
    if ($_.Exception.Message -match "403") {
        Write-Host "   ✅ Jenkins running but requires authentication" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Jenkins not accessible: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n🎯 Expected Jenkins Actions:" -ForegroundColor Yellow
Write-Host "   1. Detect SCRUM-11 in commit message" -ForegroundColor Cyan
Write-Host "   2. Run JMeter performance tests" -ForegroundColor Cyan
Write-Host "   3. Build Docker image: mohammedsalghi24/sc-grpup-2-devops-project-1" -ForegroundColor Cyan
Write-Host "   4. Push to Docker Hub" -ForegroundColor Cyan
Write-Host "   5. Create artifacts (HTML reports, JSON status)" -ForegroundColor Cyan
Write-Host "   6. Update GitHub commit and Jira issue" -ForegroundColor Cyan

Write-Host "`n📊 How to Check Results:" -ForegroundColor Yellow
Write-Host "   1. Go to: http://localhost:8081" -ForegroundColor Cyan
Write-Host "   2. Look for build number 30 or higher" -ForegroundColor Cyan
Write-Host "   3. Click on the latest build" -ForegroundColor Cyan
Write-Host "   4. Check 'Build Artifacts' section" -ForegroundColor Cyan
Write-Host "   5. View 'artifact-index.html' for complete overview" -ForegroundColor Cyan

Write-Host "`n⏰ Build should complete in 2-3 minutes" -ForegroundColor Green
Write-Host "🔄 Check Jenkins UI now to see if build #30+ started!" -ForegroundColor Green
