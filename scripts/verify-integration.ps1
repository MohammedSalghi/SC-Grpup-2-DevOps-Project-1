Write-Host "🔍 Verifying Jira and GitHub Integration"
Write-Host "============================================"

# Jira test
$jiraUrl = "https://mohammedsalghi24.atlassian.net/rest/api/2/issue/SCRUM-11"
Write-Host "🎯 Testing Jira connection to: $jiraUrl"
try {
    $jiraResponse = Invoke-WebRequest -Uri $jiraUrl -Method HEAD -ErrorAction SilentlyContinue
    if ($jiraResponse.StatusCode -eq 200) {
        Write-Host "✅ Jira connection successful!" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Jira responded with status code: $($jiraResponse.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Cannot connect to Jira. Error: $_" -ForegroundColor Red
    Write-Host "💡 Make sure your Jira URL is correct and accessible from this machine." -ForegroundColor Yellow
}

# GitHub test
$githubUrl = "https://api.github.com/repos/MohammedSalghi/SC-Grpup-2-DevOps-Project-1"
Write-Host "`n🔗 Testing GitHub connection to: $githubUrl"
try {
    $githubResponse = Invoke-WebRequest -Uri $githubUrl -Method HEAD -ErrorAction SilentlyContinue
    if ($githubResponse.StatusCode -eq 200) {
        Write-Host "✅ GitHub connection successful!" -ForegroundColor Green
    } else {
        Write-Host "⚠️ GitHub responded with status code: $($githubResponse.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Cannot connect to GitHub. Error: $_" -ForegroundColor Red
    Write-Host "💡 Make sure your GitHub repository is public and the URL is correct." -ForegroundColor Yellow
}

# Jenkins test
$jenkinsUrl = "http://localhost:8081"
Write-Host "`n🏗️ Testing Jenkins connection to: $jenkinsUrl"
try {
    $jenkinsResponse = Invoke-WebRequest -Uri $jenkinsUrl -Method HEAD -ErrorAction SilentlyContinue
    if ($jenkinsResponse.StatusCode -eq 200) {
        Write-Host "✅ Jenkins connection successful!" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Jenkins responded with status code: $($jenkinsResponse.StatusCode)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Cannot connect to Jenkins. Error: $_" -ForegroundColor Red
    Write-Host "💡 Make sure Jenkins is running on port 8081." -ForegroundColor Yellow
}

Write-Host "`n📋 Integration verification completed!"
