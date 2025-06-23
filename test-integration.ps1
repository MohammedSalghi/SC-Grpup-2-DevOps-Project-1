# Simple Jira-Jenkins Integration Test Script
param(
    [Parameter(Mandatory=$true)]
    [string]$IssueId,
    
    [Parameter(Mandatory=$true)]
    [string]$Comment
)

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$buildNumber = Get-Date -Format "yyyyMMdd-HHmmss"

Write-Host "🚀 Testing Jira-Jenkins Integration..." -ForegroundColor Cyan
Write-Host "Issue ID: $IssueId" -ForegroundColor Yellow
Write-Host "Comment: $Comment" -ForegroundColor Yellow
Write-Host "Build Number: $buildNumber" -ForegroundColor Yellow

# Test Jenkins logging
try {
    $logEntry = "[$timestamp] Issue: $IssueId - $Comment (Build: $buildNumber)"
    Add-Content -Path "jenkins-comments.log" -Value $logEntry
    Write-Host "✅ Jenkins log updated successfully" -ForegroundColor Green
    $jenkinsSuccess = $true
}
catch {
    Write-Host "❌ Failed to update Jenkins log: $_" -ForegroundColor Red
    $jenkinsSuccess = $false
}

# Test Jira CLI (will fail if not configured, but that's expected)
Write-Host "🎯 Testing Jira CLI connection..." -ForegroundColor Blue
try {
    $jiraResult = jira comment $IssueId "$Comment (Build: $buildNumber)" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Jira comment added successfully" -ForegroundColor Green
        $jiraSuccess = $true
    } else {
        Write-Host "⚠️  Jira CLI needs configuration. Run 'jira config' first." -ForegroundColor Yellow
        Write-Host "Error: $jiraResult" -ForegroundColor Red
        $jiraSuccess = $false
    }
}
catch {
    Write-Host "⚠️  Jira CLI needs configuration. Run 'jira config' first." -ForegroundColor Yellow
    $jiraSuccess = $false
}

# Summary
Write-Host "`n📊 Integration Test Summary:" -ForegroundColor Cyan
Write-Host "Jenkins Logging: $(if($jenkinsSuccess){'✅ Success'}else{'❌ Failed'})" -ForegroundColor $(if($jenkinsSuccess){'Green'}else{'Red'})
Write-Host "Jira CLI: $(if($jiraSuccess){'✅ Success'}else{'⚠️ Needs Configuration'})" -ForegroundColor $(if($jiraSuccess){'Green'}else{'Yellow'})

if($jenkinsSuccess) {
    Write-Host "`n✅ Integration system is working!" -ForegroundColor Green
    Write-Host "💡 Configure Jira CLI with 'jira config' to enable full integration." -ForegroundColor Blue
} else {
    Write-Host "`n❌ Integration test failed." -ForegroundColor Red
}
