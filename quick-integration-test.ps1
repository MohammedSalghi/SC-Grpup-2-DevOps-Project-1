Write-Host "Jenkins Integration Test for Jira and GitHub" -ForegroundColor Cyan
Write-Host "========================================"

# Define the test parameters
$jiraIssue = "SCRUM-11"
try {
    $commitHash = (git rev-parse HEAD)
} catch {
    $commitHash = "unknown"
}
$buildNumber = 30
$jenkinsUrl = "http://localhost:8081"
$jenkinsJob = "SC-Grpup-2-DevOps-Project-1"

Write-Host "Test Parameters:" -ForegroundColor Yellow
Write-Host "Jira Issue: $jiraIssue"
if ($commitHash -ne "unknown") {
    Write-Host "Commit Hash: $($commitHash.Substring(0, 8))"
} else {
    Write-Host "Commit Hash: unknown"
}
Write-Host "Jenkins Build: $buildNumber"
Write-Host "Jenkins URL: $jenkinsUrl"
Write-Host "Jenkins Job: $jenkinsJob"

# Step 1: Check if Jenkins is accessible
Write-Host "Step 1: Checking Jenkins accessibility..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $jenkinsUrl -UseBasicParsing -TimeoutSec 5
    Write-Host "Jenkins is accessible (Status: $($response.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "Cannot access Jenkins: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 2: Test Jenkins build URL
$buildUrl = "$jenkinsUrl/job/$jenkinsJob/$buildNumber"
Write-Host "Step 2: Testing Jenkins build URL..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $buildUrl -UseBasicParsing -TimeoutSec 5
    Write-Host "Jenkins build URL is accessible: $buildUrl" -ForegroundColor Green
} catch {
    Write-Host "Cannot access Jenkins build: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 3: Check integration-status.json
$artifactUrl = "$buildUrl/artifact/integration-status.json"
Write-Host "Step 3: Checking integration-status.json..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $artifactUrl -UseBasicParsing -TimeoutSec 5
    Write-Host "Found integration-status.json" -ForegroundColor Green
} catch {
    Write-Host "Cannot access integration-status.json: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 4: Create a test integration file
Write-Host "Step 4: Creating test integration file..." -ForegroundColor Yellow
$integrationJson = @"
{
  "test_timestamp": "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")",
  "build": $buildNumber,
  "jira": {
    "issue": "$jiraIssue",
    "status": "test-updated"
  },
  "github": {
    "commit": "$(if ($commitHash -ne "unknown") { $commitHash.Substring(0, 8) } else { "unknown" })",
    "status": "test-commented"
  },
  "jenkins": {
    "url": "$buildUrl",
    "status": "test-success"
  }
}
"@

Set-Content -Path "test-integration-status.json" -Value $integrationJson
Write-Host "Created test integration file: test-integration-status.json" -ForegroundColor Green

Write-Host "Test completed!"
