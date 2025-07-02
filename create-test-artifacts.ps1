Write-Host "� Running Quick Artifact Test..." -ForegroundColor Cyan

# Set Variables
$buildNumber = 29
$jiraIssue = "SCRUM-11"
$commitHash = "abc1234"

# Create test-results.md
$testResults = @"
# DevOps Pipeline Test Results
Build: #$buildNumber

## 🚀 Performance Test Results
- ✅ **Status:** PASSED
- ⏱️ **Average Response:** 150ms
- 📈 **Success Rate:** 100%
- 🔄 **Throughput:** 2.0 req/sec
- ❌ **Error Rate:** 0%

## � External System Integration
- **Jira Issue:** $jiraIssue
- **GitHub Commit:** $commitHash

Generated for testing artifact visibility
"@
Set-Content -Path ".\test-results.md" -Value $testResults
Write-Host "✅ Created test-results.md" -ForegroundColor Green

# Create a minimal artifact-index.html
$artifactIndex = @"
<!DOCTYPE html>
<html>
<head>
    <title>Build #$buildNumber Artifacts</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { color: #2c3e50; }
        .artifact { padding: 10px; margin: 10px 0; border-left: 3px solid #3498db; background: #f8f9fa; }
    </style>
</head>
<body>
    <h1>Build #$buildNumber Artifacts</h1>
    <p>Test for Jenkins artifact visibility</p>
    
    <div class="artifact">
        <h3>📊 Test Results</h3>
        <a href="test-results.md">Test Results Summary</a>
    </div>
</body>
</html>
"@
Set-Content -Path ".\artifact-index.html" -Value $artifactIndex
Write-Host "✅ Created artifact-index.html" -ForegroundColor Green

# Create a minimal performance summary
$perfSummary = @"
Performance Test Results - Build #$buildNumber
==============================================
✅ Status: PASSED
⚡ Duration: ~3 seconds
📊 Average Response: 150ms
"@
Set-Content -Path ".\performance-summary.txt" -Value $perfSummary
Write-Host "✅ Created performance-summary.txt" -ForegroundColor Green

# Create minimal integration status
$integrationStatus = @"
{
  "build": $buildNumber,
  "jira": {
    "issue": "$jiraIssue",
    "status": "updated"
  },
  "github": {
    "commit": "$commitHash",
    "status": "commented"
  }
}
"@
Set-Content -Path ".\integration-status.json" -Value $integrationStatus
Write-Host "✅ Created integration-status.json" -ForegroundColor Green

# Create minimal performance results
$perfResults = @"
timeStamp,elapsed,label,responseCode,responseMessage,success,bytes
1654789123,150,HTTP Request,200,OK,true,1234
1654789124,180,HTTP Request,200,OK,true,1234
1654789125,120,HTTP Request,200,OK,true,1234
"@
Set-Content -Path ".\performance-results.jtl" -Value $perfResults
Write-Host "✅ Created performance-results.jtl" -ForegroundColor Green

# Create minimal HTML reports
$dashboardHtml = @"
<!DOCTYPE html>
<html>
<head><title>Performance Dashboard</title></head>
<body>
    <h1>Performance Dashboard</h1>
    <p>Average response: 150ms</p>
</body>
</html>
"@
Set-Content -Path ".\performance-dashboard.html" -Value $dashboardHtml
Write-Host "✅ Created performance-dashboard.html" -ForegroundColor Green

$jmeterHtml = @"
<!DOCTYPE html>
<html>
<head><title>JMeter Report</title></head>
<body>
    <h1>JMeter Test Report</h1>
    <p>Tests passed: 100%</p>
</body>
</html>
"@
Set-Content -Path ".\jmeter-report.html" -Value $jmeterHtml
Write-Host "✅ Created jmeter-report.html" -ForegroundColor Green

Write-Host "`n🚀 All test artifacts created successfully!" -ForegroundColor Green
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Trigger a Jenkins build"
Write-Host "2. Check that artifacts are visible in Jenkins UI"
Write-Host "3. Access artifacts through 'Build Artifacts' link in build page"
Write-Host "4. Verify all files are present and accessible"
