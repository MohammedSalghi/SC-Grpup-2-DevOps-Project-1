Write-Host "🔍 Quick Jenkins Artifact Verification" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# Step 1: Check if artifact files exist
Write-Host "`nChecking if artifact files exist in the workspace:" -ForegroundColor Yellow
$artifactFiles = @(
    "artifact-index.html",
    "test-results.md",
    "performance-dashboard.html",
    "performance-summary.txt",
    "performance-results.jtl",
    "jmeter-report.html",
    "integration-status.json"
)

foreach ($file in $artifactFiles) {
    if (Test-Path $file) {
        Write-Host "✅ File exists: $file" -ForegroundColor Green
    } else {
        Write-Host "❌ File missing: $file" -ForegroundColor Red
    }
}

# Step 2: Check Jenkinsfile for archiving statements
Write-Host "`nChecking Jenkinsfile for artifact archiving:" -ForegroundColor Yellow
$archiveCount = (Select-String -Path .\Jenkinsfile -Pattern "archiveArtifacts" -AllMatches).Matches.Count
$fingerprintCount = (Select-String -Path .\Jenkinsfile -Pattern "fingerprint:\s*true" -AllMatches).Matches.Count
Write-Host "Found $archiveCount artifact archiving statements" -ForegroundColor Green
Write-Host "Found $fingerprintCount fingerprinting configurations" -ForegroundColor Green

# Step 3: Try to check if Jenkins is accessible
Write-Host "`nChecking if Jenkins server is accessible:" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8081" -UseBasicParsing -TimeoutSec 5
    Write-Host "✅ Jenkins server is accessible (Status: $($response.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "❌ Cannot access Jenkins server: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 4: Check Jenkinsfile.fast too
Write-Host "`nChecking Jenkinsfile.fast for integrations:" -ForegroundColor Yellow
if (Test-Path "Jenkinsfile.fast") {
    $content = Get-Content "Jenkinsfile.fast" -Raw
    
    if ($content -match "GitHub") { Write-Host "✅ GitHub integration found" -ForegroundColor Green }
    if ($content -match "Jira") { Write-Host "✅ Jira integration found" -ForegroundColor Green }
    if ($content -match "Docker") { Write-Host "✅ Docker integration found" -ForegroundColor Green }
    if ($content -match "JMeter") { Write-Host "✅ JMeter integration found" -ForegroundColor Green }
}

# Step 5: Show artifact URLs to check manually
Write-Host "`nJenkins artifact URLs to check manually:" -ForegroundColor Yellow
Write-Host "- Artifact directory: http://localhost:8081/job/SC-devops-pipeline/lastSuccessfulBuild/artifact/" -ForegroundColor White
Write-Host "- Artifact index: http://localhost:8081/job/SC-devops-pipeline/lastSuccessfulBuild/artifact/artifact-index.html" -ForegroundColor White
Write-Host "- Test results: http://localhost:8081/job/SC-devops-pipeline/lastSuccessfulBuild/artifact/test-results.md" -ForegroundColor White

Write-Host "`nRecommendation:" -ForegroundColor Magenta
Write-Host "1. Verify the job name in Jenkins - ensure it's 'SC-devops-pipeline'"
Write-Host "2. Check Jenkins UI for the 'Build Artifacts' link after a successful build"
Write-Host "3. Ensure artifacts are being properly archived in the Jenkinsfile"
Write-Host "4. If issues persist, check Jenkins logs for more details"

Write-Host "`n✅ Verification completed!" -ForegroundColor Green
