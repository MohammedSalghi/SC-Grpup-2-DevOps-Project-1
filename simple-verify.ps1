# Simple Jenkinsfile Verification Script

Write-Host "🔍 Verifying Jenkinsfile.fast Pipeline" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

# Check if Jenkinsfile.fast exists
if (Test-Path "Jenkinsfile.fast") {
    Write-Host "✅ Jenkinsfile.fast exists" -ForegroundColor Green
    $jenkinsFileContent = Get-Content "Jenkinsfile.fast" -Raw
    Write-Host "File size: $((Get-Item Jenkinsfile.fast).Length) bytes"
} else {
    Write-Host "❌ Jenkinsfile.fast not found" -ForegroundColor Red
    exit 1
}

# Check integrations
$integrations = @{
    "GitHub" = "github|GitHub|git|commit"
    "Jira" = "jira|Jira|JIRA|SCRUM-11"
    "Docker" = "docker|Docker|DOCKER_IMAGE"
    "Docker Hub" = "docker hub|dockerhub|mohammedsalghi24"
    "JMeter" = "jmeter|JMeter|performance-test.jmx"
}

foreach ($key in $integrations.Keys) {
    $pattern = $integrations[$key]
    if ($jenkinsFileContent -match $pattern) {
        Write-Host "✅ $key integration found" -ForegroundColor Green
    } else {
        Write-Host "⚠️ $key integration may be missing" -ForegroundColor Yellow
    }
}

Write-Host "`nPipeline verification complete!" -ForegroundColor Cyan
Write-Host "The pipeline is ready to be triggered in Jenkins."
