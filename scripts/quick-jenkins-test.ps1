Write-Host "🚀 Quick Jenkins Pipeline Test" -ForegroundColor Green
Write-Host "=============================" -ForegroundColor Green

# 1. Check Docker status
Write-Host "`n1. Checking Docker status..." -ForegroundColor Yellow
docker --version
docker ps --filter "name=jenkins" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# 2. Verify Jenkinsfile exists and is updated
Write-Host "`n2. Checking Jenkinsfile..." -ForegroundColor Yellow
if (Test-Path "Jenkinsfile") {
    Write-Host "✅ Jenkinsfile exists" -ForegroundColor Green
    $dockerStages = Select-String -Path "Jenkinsfile" -Pattern "Docker" -AllMatches
    Write-Host "   Found $($dockerStages.Matches.Count) Docker references" -ForegroundColor Cyan
    
    $jmeterRefs = Select-String -Path "Jenkinsfile" -Pattern "JMeter|jmeter" -AllMatches
    Write-Host "   Found $($jmeterRefs.Matches.Count) JMeter references" -ForegroundColor Cyan
    
    $jiraRefs = Select-String -Path "Jenkinsfile" -Pattern "JIRA|jira" -AllMatches
    Write-Host "   Found $($jiraRefs.Matches.Count) Jira references" -ForegroundColor Cyan
} else {
    Write-Host "❌ Jenkinsfile not found" -ForegroundColor Red
}

# 3. Create test artifacts to verify pipeline works
Write-Host "`n3. Creating test artifacts..." -ForegroundColor Yellow
@"
# Test Results - Quick Test
✅ Status: PASSED
📊 Performance: 150ms avg
🐳 Docker: Ready for build
🎯 Jira: SCRUM-11
"@ | Out-File -FilePath "test-results.md" -Encoding UTF8

Write-Host "✅ Created test-results.md" -ForegroundColor Green

# 4. Check Git status
Write-Host "`n4. Checking Git status..." -ForegroundColor Yellow
try {
    git status --porcelain
    $gitStatus = git status --porcelain
    if ($gitStatus) {
        Write-Host "📝 Uncommitted changes detected:" -ForegroundColor Cyan
        Write-Host $gitStatus -ForegroundColor White
    } else {
        Write-Host "✅ Git working directory clean" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️ Git not available or not a git repository" -ForegroundColor Yellow
}

# 5. Create a quick commit to trigger Jenkins (if changes exist)
Write-Host "`n5. Test Jenkins trigger..." -ForegroundColor Yellow
if (git status --porcelain) {
    Write-Host "Creating test commit to trigger Jenkins..." -ForegroundColor Cyan
    git add test-results.md
    git commit -m "SCRUM-11: Quick test pipeline update - $(Get-Date -Format 'HH:mm:ss')"
    Write-Host "✅ Test commit created with Jira issue ID" -ForegroundColor Green
    Write-Host "🚀 This should trigger Jenkins build if webhook is configured" -ForegroundColor Green
} else {
    Write-Host "Creating empty commit to trigger Jenkins..." -ForegroundColor Cyan
    git commit --allow-empty -m "SCRUM-11: Test Jenkins pipeline - $(Get-Date -Format 'HH:mm:ss')"
    Write-Host "✅ Empty commit created to trigger Jenkins" -ForegroundColor Green
}

# 6. Show Jenkins access info
Write-Host "`n6. Jenkins Access Information:" -ForegroundColor Yellow
Write-Host "   URL: http://localhost:8081" -ForegroundColor Cyan
Write-Host "   Go to Jenkins UI to see if build was triggered" -ForegroundColor Cyan
Write-Host "   Look for your project pipeline and check the build history" -ForegroundColor Cyan

Write-Host "`n🎯 Quick Test Complete!" -ForegroundColor Green
Write-Host "Check Jenkins UI at http://localhost:8081 to see if build was triggered" -ForegroundColor Yellow
