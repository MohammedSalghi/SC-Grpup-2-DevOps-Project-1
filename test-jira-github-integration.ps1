Write-Host "🔍 Jenkins Integration Test: Jira and GitHub" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Define the test parameters
$jiraIssue = "SCRUM-11"
$commitHash = (git rev-parse HEAD)
$buildNumber = 30  # You might need to adjust this to match your latest Jenkins build
$jenkinsUrl = "http://localhost:8081"
$jenkinsJob = "SC-Grpup-2-DevOps-Project-1"  # This should match your actual Jenkins job name

Write-Host "`n🔧 Test Parameters:" -ForegroundColor Yellow
Write-Host "Jira Issue: $jiraIssue"
Write-Host "Commit Hash: $($commitHash.Substring(0, 8))"
Write-Host "Jenkins Build: $buildNumber"
Write-Host "Jenkins URL: $jenkinsUrl"
Write-Host "Jenkins Job: $jenkinsJob"

# Step 1: Check if Jenkins is accessible
Write-Host "`n🔄 Step 1: Checking Jenkins accessibility..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $jenkinsUrl -UseBasicParsing -TimeoutSec 5
    Write-Host "✅ Jenkins is accessible (Status: $($response.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "❌ Cannot access Jenkins: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 2: Test Jenkins build URL
$buildUrl = "$jenkinsUrl/job/$jenkinsJob/$buildNumber"
Write-Host "`n🔄 Step 2: Testing Jenkins build URL..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $buildUrl -UseBasicParsing -TimeoutSec 5
    Write-Host "✅ Jenkins build URL is accessible: $buildUrl" -ForegroundColor Green
} catch {
    Write-Host "❌ Cannot access Jenkins build: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 3: Check Jira integration in Jenkins build
$artifactUrl = "$buildUrl/artifact/integration-status.json"
Write-Host "`n🔄 Step 3: Checking Jira integration in build artifacts..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $artifactUrl -UseBasicParsing -TimeoutSec 5
    $integrationStatus = $response.Content | ConvertFrom-Json
    
    Write-Host "✅ Found integration status artifact" -ForegroundColor Green
    Write-Host "Jira Issue: $($integrationStatus.jira.issue)" -ForegroundColor Green
    Write-Host "Jira Status: $($integrationStatus.jira.status)" -ForegroundColor Green
} catch {
    Write-Host "❌ Cannot access integration status: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 4: Test Jira direct access
$jiraUrl = "https://mohammedsalghi24.atlassian.net/browse/$jiraIssue"
Write-Host "`n🔄 Step 4: Testing Jira direct access..." -ForegroundColor Yellow
Write-Host "Jira URL: $jiraUrl" -ForegroundColor White
Write-Host "⚠️ Note: This requires authentication - cannot be fully automated" -ForegroundColor Yellow

# Step 5: Test GitHub direct access
$githubUrl = "https://github.com/MohammedSalghi/SC-Grpup-2-DevOps-Project-1/commit/$commitHash"
Write-Host "`n🔄 Step 5: Testing GitHub direct access..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $githubUrl -UseBasicParsing -TimeoutSec 5
    Write-Host "✅ GitHub commit URL is accessible: $githubUrl" -ForegroundColor Green
} catch {
    Write-Host "⚠️ GitHub commit URL might require authentication: $githubUrl" -ForegroundColor Yellow
}

# Step 6: Create simulated integration update
Write-Host "`n🔄 Step 6: Creating test integration file..." -ForegroundColor Yellow
$integrationJson = @"
{
  "test_timestamp": "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")",
  "build": $buildNumber,
  "jira": {
    "issue": "$jiraIssue",
    "url": "$jiraUrl",
    "status": "test-updated"
  },
  "github": {
    "commit": "$($commitHash.Substring(0, 8))",
    "url": "$githubUrl",
    "status": "test-commented"
  },
  "jenkins": {
    "url": "$buildUrl",
    "status": "test-success"
  }
}
"@

Set-Content -Path "test-integration-status.json" -Value $integrationJson
Write-Host "✅ Created test integration file: test-integration-status.json" -ForegroundColor Green

# Step 7: Suggest manual verification steps
Write-Host "`n📋 Step 7: Manual verification steps:" -ForegroundColor Magenta
Write-Host "1. Trigger a new Jenkins build (with a Jira ID in the commit message)" -ForegroundColor White
Write-Host "2. Watch the Jenkins console output for Jira and GitHub integration steps" -ForegroundColor White
Write-Host "3. Check the build artifacts for integration-status.json" -ForegroundColor White
Write-Host "4. Verify that the Jira issue shows the Jenkins build in its comments" -ForegroundColor White
Write-Host "5. Verify that the GitHub commit shows the Jenkins build status" -ForegroundColor White

Write-Host "`n✅ Integration test completed!" -ForegroundColor Green
Write-Host "To trigger a Jenkins build with this test data, use:" -ForegroundColor Green
Write-Host "curl -X POST $jenkinsUrl/job/$jenkinsJob/build?token=YOUR_TRIGGER_TOKEN" -ForegroundColor Yellow
