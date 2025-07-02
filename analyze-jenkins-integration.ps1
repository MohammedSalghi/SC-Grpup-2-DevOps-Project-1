Write-Host "Jenkins Pipeline Integration Analysis" -ForegroundColor Cyan
Write-Host "=================================="

# Check Jenkinsfile for integration configuration
Write-Host "Analyzing Jenkinsfile for integration points..." -ForegroundColor Yellow
$jenkinsfile = Get-Content -Path .\Jenkinsfile -Raw

# Check for Jira integration
Write-Host "`nJira Integration:" -ForegroundColor Magenta
$jiraPatterns = @(
    "JIRA_URL_BASE",
    "env.JIRA_ISSUE",
    "Updating Jira issue",
    "jiraComment"
)

foreach ($pattern in $jiraPatterns) {
    $matchResults = Select-String -InputObject $jenkinsfile -Pattern $pattern -AllMatches
    if ($matchResults) {
        Write-Host "✅ Found $($matchResults.Matches.Count) references to '$pattern'" -ForegroundColor Green
    } else {
        Write-Host "⚠️ No references found for '$pattern'" -ForegroundColor Yellow
    }
}

# Check for GitHub integration
Write-Host "`nGitHub Integration:" -ForegroundColor Magenta
$githubPatterns = @(
    "GITHUB_REPO_URL",
    "env.GITHUB_URL",
    "Posting comment to GitHub",
    "githubComment"
)

foreach ($pattern in $githubPatterns) {
    $matchResults = Select-String -InputObject $jenkinsfile -Pattern $pattern -AllMatches
    if ($matchResults) {
        Write-Host "✅ Found $($matchResults.Matches.Count) references to '$pattern'" -ForegroundColor Green
    } else {
        Write-Host "⚠️ No references found for '$pattern'" -ForegroundColor Yellow
    }
}

# Check for integration artifact creation
Write-Host "`nIntegration Artifacts:" -ForegroundColor Magenta
$artifactPatterns = @(
    "integration-status.json",
    "archiveArtifacts.*integration-status.json",
    "performance-dashboard.html"
)

foreach ($pattern in $artifactPatterns) {
    $matchResults = Select-String -InputObject $jenkinsfile -Pattern $pattern -AllMatches
    if ($matchResults) {
        Write-Host "✅ Found $($matchResults.Matches.Count) references to '$pattern'" -ForegroundColor Green
    } else {
        Write-Host "⚠️ No references found for '$pattern'" -ForegroundColor Yellow
    }
}

# Detect active integration issues
Write-Host "`nIntegration Assessment:" -ForegroundColor Magenta
$issues = @()

# Check for missing credentials
if (!($jenkinsfile -match "withCredentials")) {
    $issues += "No credential handling found, which may affect GitHub/Jira API authentication"
}

# Check for actual API calls vs simulation
if ($jenkinsfile -match "Simulate") {
    $issues += "Pipeline appears to be simulating API calls rather than making real ones"
}

# Check for error handling
if (!($jenkinsfile -match "try\s*\{.*\}\s*catch")) {
    $issues += "Limited error handling for integration calls"
}

# Report issues
if ($issues.Count -gt 0) {
    Write-Host "Found $($issues.Count) potential integration issues:" -ForegroundColor Yellow
    foreach ($issue in $issues) {
        Write-Host "⚠️ $issue" -ForegroundColor Yellow
    }
} else {
    Write-Host "✅ No obvious integration issues detected" -ForegroundColor Green
}

# Determine if the pipeline is ready for testing
Write-Host "`nReadiness Assessment:" -ForegroundColor Magenta
$readyToTest = $true

if ($jenkinsfile -match "Simulate" -and !($jenkinsfile -match "withCredentials")) {
    Write-Host "⚠️ Pipeline is in SIMULATION mode - will not make real API calls" -ForegroundColor Yellow
    $readyToTest = $false
} else {
    Write-Host "✅ Pipeline appears to be configured for real integration" -ForegroundColor Green
}

# Summary and next steps
Write-Host "`nSummary:" -ForegroundColor Cyan
if ($readyToTest) {
    Write-Host "The Jenkins pipeline appears to be properly configured for Jira and GitHub integration." -ForegroundColor Green
    Write-Host "To test the integration, follow these steps:" -ForegroundColor White
    Write-Host "1. Commit with a Jira issue ID (e.g., [SCRUM-11] Test commit)" -ForegroundColor White
    Write-Host "2. Push to GitHub" -ForegroundColor White
    Write-Host "3. Trigger a Jenkins build" -ForegroundColor White
    Write-Host "4. Check the Jenkins console for integration messages" -ForegroundColor White
    Write-Host "5. Verify integration-status.json in the artifacts" -ForegroundColor White
} else {
    Write-Host "The Jenkins pipeline needs configuration changes before real integration testing:" -ForegroundColor Yellow
    Write-Host "1. Add proper authentication for Jira and GitHub APIs" -ForegroundColor White
    Write-Host "2. Replace simulation code with real API calls" -ForegroundColor White
    Write-Host "3. Add proper error handling" -ForegroundColor White
}

Write-Host "`nAnalysis completed!" -ForegroundColor Cyan
