Write-Host "🔍 Jenkins Manual Build Check" -ForegroundColor Green

# Check if Jenkins is accessible
Write-Host "`nChecking Jenkins..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8081" -TimeoutSec 5
    Write-Host "✅ Jenkins is accessible" -ForegroundColor Green
} catch {
    if ($_.Exception.Message -match "403") {
        Write-Host "✅ Jenkins running but needs authentication" -ForegroundColor Green
    } else {
        Write-Host "❌ Jenkins not accessible: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Check Docker container
Write-Host "`nChecking Docker container..." -ForegroundColor Yellow
$dockerStatus = docker ps --filter "name=jenkins" --format "{{.Status}}"
if ($dockerStatus) {
    Write-Host "✅ Jenkins container: $dockerStatus" -ForegroundColor Green
} else {
    Write-Host "❌ Jenkins container not found" -ForegroundColor Red
}

# Show recent commits
Write-Host "`nRecent commits:" -ForegroundColor Yellow
git log --oneline -3

Write-Host "`n🎯 Manual Jenkins Build Steps:" -ForegroundColor Cyan
Write-Host "1. Go to: http://localhost:8081" -ForegroundColor White
Write-Host "2. Login to Jenkins" -ForegroundColor White
Write-Host "3. Find your project pipeline" -ForegroundColor White
Write-Host "4. Click 'Build Now' button" -ForegroundColor White
Write-Host "5. Watch the build progress" -ForegroundColor White

Write-Host "`n⚠️ If webhook not working:" -ForegroundColor Yellow
Write-Host "- Webhook might not be configured in GitHub" -ForegroundColor White
Write-Host "- Jenkins job might not have webhook trigger enabled" -ForegroundColor White
Write-Host "- Manual build will work the same way" -ForegroundColor White

Write-Host "`n🚀 Ready for manual build trigger!" -ForegroundColor Green
