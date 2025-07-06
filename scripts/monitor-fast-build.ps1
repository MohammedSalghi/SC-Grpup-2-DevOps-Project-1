Write-Host "🚀 ULTRA FAST BUILD MONITOR" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Check if Jenkins is running
$jenkinsRunning = docker ps --filter "name=jenkins" --format "{{.Names}}" | Select-String "jenkins"
if ($jenkinsRunning) {
    Write-Host "✅ Jenkins is running" -ForegroundColor Green
} else {
    Write-Host "❌ Jenkins is not running" -ForegroundColor Red
    exit 1
}

# Get latest Docker images (should show new build)
Write-Host "`n🐳 Latest Docker images:" -ForegroundColor Yellow
docker images mohammedsalghi24/sc-grpup-2-devops-project-1 --format "table {{.Tag}}\t{{.CreatedAt}}\t{{.Size}}" | Select-Object -First 5

Write-Host "`n⚡ Jenkins URLs:" -ForegroundColor Yellow
Write-Host "Job Page: http://localhost:8081/job/SC-Group-2-DevOps-Project-1/"
Write-Host "Latest Build: http://localhost:8081/job/SC-Group-2-DevOps-Project-1/lastBuild/console"

Write-Host "`n🎯 Expected optimizations:" -ForegroundColor Cyan
Write-Host "- Build time: Under 2 minutes"
Write-Host "- Docker cache usage: ✓"
Write-Host "- Simplified pipeline: ✓" 
Write-Host "- Fast Docker push: ✓"

Write-Host "`n🏁 Monitor complete!" -ForegroundColor Green
