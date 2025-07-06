Write-Host "Simulating Git Commit with Jira Issue for Jenkins Test" -ForegroundColor Cyan
Write-Host "=================================================="

$jiraIssue = "SCRUM-11"
$message = "[${jiraIssue}] Test commit for Jenkins-Jira-GitHub integration"

# Create a test file
$testFileName = "jira_jenkins_test_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
$testContent = @"
This is a test file created to test the Jenkins pipeline with Jira and GitHub integration.
Jira Issue: $jiraIssue
Created: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@

Write-Host "Creating test file: $testFileName" -ForegroundColor Yellow
Set-Content -Path $testFileName -Value $testContent
Write-Host "Test file created!" -ForegroundColor Green

Write-Host "`nTo add and commit this file with a Jira reference, run:" -ForegroundColor Yellow
Write-Host "git add $testFileName" -ForegroundColor White
Write-Host "git commit -m `"${message}`"" -ForegroundColor White
Write-Host "git push" -ForegroundColor White

Write-Host "`nAfter pushing, trigger a Jenkins build to test the integration!" -ForegroundColor Magenta
