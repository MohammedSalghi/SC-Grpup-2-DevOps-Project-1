Write-Host "🔧 Jenkins Credentials Setup Guide for GitHub and Jira Integration" -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Cyan

Write-Host "`nThis guide will help you set up the required credentials in Jenkins for GitHub and Jira integration."
Write-Host "These credentials are referenced in the Jenkinsfile and are necessary for API calls to work."

Write-Host "`n📋 Required Credentials:" -ForegroundColor Yellow
Write-Host "1. GitHub Personal Access Token (PAT)" -ForegroundColor White
Write-Host "2. Jira API Token" -ForegroundColor White

Write-Host "`n🔶 Step 1: Create a GitHub Personal Access Token" -ForegroundColor Magenta
Write-Host "  a) Go to GitHub > Settings > Developer settings > Personal access tokens" -ForegroundColor White
Write-Host "  b) Generate a new token with the following scopes:" -ForegroundColor White
Write-Host "     • repo (Full control of private repositories)" -ForegroundColor White
Write-Host "     • workflow (if using GitHub Actions)" -ForegroundColor White
Write-Host "  c) Copy the generated token (you'll only see it once!)" -ForegroundColor White

Write-Host "`n🔶 Step 2: Create a Jira API Token" -ForegroundColor Magenta
Write-Host "  a) Go to Atlassian account settings: https://id.atlassian.com/manage/api-tokens" -ForegroundColor White
Write-Host "  b) Click 'Create API token'" -ForegroundColor White
Write-Host "  c) Give it a name (e.g., 'Jenkins Integration')" -ForegroundColor White
Write-Host "  d) Copy the generated token (you'll only see it once!)" -ForegroundColor White

Write-Host "`n🔶 Step 3: Add Credentials to Jenkins" -ForegroundColor Magenta
Write-Host "  a) Go to Jenkins > Manage Jenkins > Manage Credentials" -ForegroundColor White
Write-Host "  b) Click on the appropriate domain (usually 'global')" -ForegroundColor White
Write-Host "  c) Click 'Add Credentials'" -ForegroundColor White
Write-Host "  d) For GitHub Token:" -ForegroundColor White
Write-Host "     • Kind: Secret text" -ForegroundColor White
Write-Host "     • Scope: Global" -ForegroundColor White
Write-Host "     • Secret: [paste GitHub token]" -ForegroundColor White
Write-Host "     • ID: github-token" -ForegroundColor White
Write-Host "     • Description: GitHub API Token" -ForegroundColor White
Write-Host "  e) For Jira Credentials:" -ForegroundColor White
Write-Host "     • Kind: Username with password" -ForegroundColor White
Write-Host "     • Scope: Global" -ForegroundColor White
Write-Host "     • Username: [your Jira email]" -ForegroundColor White
Write-Host "     • Password: [paste Jira API token]" -ForegroundColor White
Write-Host "     • ID: jira-credentials" -ForegroundColor White
Write-Host "     • Description: Jira API Credentials" -ForegroundColor White

Write-Host "`n⚠️ Important Note:" -ForegroundColor Yellow
Write-Host "Make sure the credential IDs match exactly what's in the Jenkinsfile:" -ForegroundColor White
Write-Host "  • GitHub token ID: 'github-token'" -ForegroundColor White
Write-Host "  • Jira credentials ID: 'jira-credentials'" -ForegroundColor White

Write-Host "`n✅ Verification:" -ForegroundColor Green
Write-Host "After setting up credentials, run a build and check the Jenkins logs for:" -ForegroundColor White
Write-Host "  • 'Successfully posted comment to GitHub commit'" -ForegroundColor White
Write-Host "  • 'Successfully added comment to Jira issue'" -ForegroundColor White

Write-Host "`nIf you see errors in the logs, verify your tokens are valid and have the right permissions." -ForegroundColor Yellow
