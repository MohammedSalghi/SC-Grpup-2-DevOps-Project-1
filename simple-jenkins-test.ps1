Write-Host "🚀 Quick Jenkins Test" -ForegroundColor Green

# Check Docker
Write-Host "`nDocker Status:" -ForegroundColor Yellow
docker ps --filter "name=jenkins"

# Check Jenkinsfile
Write-Host "`nJenkinsfile Check:" -ForegroundColor Yellow
if (Test-Path "Jenkinsfile") {
    Write-Host "✅ Jenkinsfile exists" -ForegroundColor Green
    $dockerCount = (Select-String -Path "Jenkinsfile" -Pattern "Docker").Count
    $jmeterCount = (Select-String -Path "Jenkinsfile" -Pattern "JMeter").Count
    Write-Host "   Docker references: $dockerCount" -ForegroundColor Cyan
    Write-Host "   JMeter references: $jmeterCount" -ForegroundColor Cyan
}

# Create test commit
Write-Host "`nCreating test commit:" -ForegroundColor Yellow
git add .
git commit -m "SCRUM-11: Test Jenkins integration $(Get-Date -Format 'HH:mm')"

Write-Host "`n✅ Test complete! Check Jenkins at http://localhost:8081" -ForegroundColor Green
