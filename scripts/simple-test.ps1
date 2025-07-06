# Simple Integration Test
param($IssueId, $Comment)

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$buildNumber = Get-Date -Format "yyyyMMdd-HHmmss"

Write-Host "Testing Jira-Jenkins Integration..." -ForegroundColor Cyan
Write-Host "Issue ID: $IssueId" -ForegroundColor Yellow
Write-Host "Comment: $Comment" -ForegroundColor Yellow

# Test Jenkins logging
$logEntry = "[$timestamp] Issue: $IssueId - $Comment (Build: $buildNumber)"
Add-Content -Path "jenkins-comments.log" -Value $logEntry
Write-Host "Jenkins log updated successfully" -ForegroundColor Green

# Test Jira CLI
Write-Host "Testing Jira CLI..." -ForegroundColor Blue
jira comment $IssueId "$Comment (Build: $buildNumber)"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Jira comment added successfully" -ForegroundColor Green
} else {
    Write-Host "Jira CLI needs configuration. Run 'jira config' first." -ForegroundColor Yellow
}

Write-Host "Integration test completed!" -ForegroundColor Green
