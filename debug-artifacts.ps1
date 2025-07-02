Write-Host "=== JENKINS ARTIFACT TROUBLESHOOTING ===" -ForegroundColor Cyan
Write-Host ""

# Check if Jenkins is running
Write-Host "1. Checking Jenkins status..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8081" -TimeoutSec 10 -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ Jenkins is running on localhost:8081" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Jenkins is not accessible on localhost:8081" -ForegroundColor Red
    Write-Host "   Make sure Jenkins is running: docker ps" -ForegroundColor Yellow
}

# Check artifact files
Write-Host ""
Write-Host "2. Checking artifact files in workspace..." -ForegroundColor Yellow
$artifactFiles = @(
    "artifact-index.html",
    "test-results.md", 
    "performance-dashboard.html",
    "performance-summary.txt",
    "jmeter-report.html",
    "performance-results.jtl",
    "integration-status.json"
)

$existingFiles = @()
foreach ($file in $artifactFiles) {
    if (Test-Path $file) {
        $size = (Get-Item $file).Length
        Write-Host "✅ $file ($size bytes)" -ForegroundColor Green
        $existingFiles += $file
    } else {
        Write-Host "❌ $file (missing)" -ForegroundColor Red
    }
}

# Check Jenkinsfile archiving
Write-Host ""
Write-Host "3. Checking Jenkinsfile archiving configuration..." -ForegroundColor Yellow
if (Test-Path "Jenkinsfile") {
    $content = Get-Content "Jenkinsfile" -Raw
    $archiveCount = ([regex]::Matches($content, "archiveArtifacts")).Count
    $fingerprintCount = ([regex]::Matches($content, "fingerprint.*true")).Count
    
    Write-Host "✅ Found $archiveCount archiveArtifacts statements" -ForegroundColor Green
    Write-Host "✅ Found $fingerprintCount fingerprint configurations" -ForegroundColor Green
    
    if ($content -match "post\s*\{") {
        Write-Host "✅ Post block found in Jenkinsfile" -ForegroundColor Green
    } else {
        Write-Host "⚠️ No post block found in Jenkinsfile" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Jenkinsfile not found" -ForegroundColor Red
}

# Generate direct URLs for testing
Write-Host ""
Write-Host "4. Testing direct artifact URLs..." -ForegroundColor Yellow
$buildNumber = 29
$baseUrl = "http://localhost:8081/job/SC-devops-pipeline/$buildNumber/artifact/"

Write-Host "Try these direct URLs in your browser:" -ForegroundColor Cyan
Write-Host "   Build artifacts: $baseUrl" -ForegroundColor White
Write-Host "   Artifact index: ${baseUrl}artifact-index.html" -ForegroundColor White
Write-Host "   Test results: ${baseUrl}test-results.md" -ForegroundColor White

# Test if we can reach the artifact directory
try {
    $artifactUrl = $baseUrl
    Write-Host ""
    Write-Host "Testing artifact directory access..." -ForegroundColor Yellow
    $response = Invoke-WebRequest -Uri $artifactUrl -TimeoutSec 5 -UseBasicParsing
    Write-Host "✅ Artifact directory is accessible" -ForegroundColor Green
} catch {
    Write-Host "❌ Cannot access artifact directory" -ForegroundColor Red
    Write-Host "   This means artifacts were not archived in build #$buildNumber" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== SOLUTIONS ===" -ForegroundColor Magenta
Write-Host "If artifacts are still not visible:" -ForegroundColor White
Write-Host "1. Trigger a NEW Jenkins build (build #30)" -ForegroundColor White
Write-Host "2. Check the Console Output for archiving errors" -ForegroundColor White  
Write-Host "3. Look for 'Archiving artifacts' messages in the log" -ForegroundColor White
Write-Host "4. Verify the 'Build Artifacts' link appears in the left sidebar" -ForegroundColor White
Write-Host ""
Write-Host "Manual verification steps:" -ForegroundColor Yellow
Write-Host "1. Go to: http://localhost:8081/job/SC-devops-pipeline/" -ForegroundColor White
Write-Host "2. Click on the latest build number" -ForegroundColor White
Write-Host "3. Look for 'Build Artifacts' in the left menu" -ForegroundColor White
Write-Host "4. If missing, check Console Output for errors" -ForegroundColor White
