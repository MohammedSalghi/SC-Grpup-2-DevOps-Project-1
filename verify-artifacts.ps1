Write-Host "🔍 Verifying Jenkins Artifact Configuration..." -ForegroundColor Cyan

$jenkinsfile = Get-Content -Path .\Jenkinsfile -Raw
$archiveLines = Select-String -Path .\Jenkinsfile -Pattern "archiveArtifacts" -AllMatches

Write-Host "Found $($archiveLines.Matches.Count) artifact archiving statements in Jenkinsfile" -ForegroundColor Green

# Check for fingerprinting
$fingerprintCount = Select-String -Path .\Jenkinsfile -Pattern "fingerprint:\s*true" -AllMatches
Write-Host "Found $($fingerprintCount.Matches.Count) fingerprinting configurations" -ForegroundColor Green

# Check for artifact index.html
$hasArtifactIndex = $jenkinsfile -match "artifact-index.html"
if ($hasArtifactIndex) {
    Write-Host "✅ artifact-index.html is being created and archived" -ForegroundColor Green
} else {
    Write-Host "❌ Missing artifact-index.html configuration" -ForegroundColor Red
}

# Check for test-results.md
$hasTestResults = $jenkinsfile -match "test-results.md"
if ($hasTestResults) {
    Write-Host "✅ test-results.md is being created and archived" -ForegroundColor Green
} else {
    Write-Host "❌ Missing test-results.md configuration" -ForegroundColor Red
}

# Jenkins artifact configuration suggestions
Write-Host "`n📋 Jenkins Artifact Visibility Checklist:" -ForegroundColor Yellow
Write-Host "1. Ensure 'Fingerprint all archived artifacts' is enabled in Jenkins job configuration" -ForegroundColor Yellow
Write-Host "2. Check that the 'Discard old builds' setting is not preventing artifact retention" -ForegroundColor Yellow
Write-Host "3. Verify that 'Archive Artifacts' plugin is correctly installed and configured" -ForegroundColor Yellow
Write-Host "4. Check that Jenkins has proper permissions to create and read artifact files" -ForegroundColor Yellow

Write-Host "`n📝 How to Access Artifacts in Jenkins:" -ForegroundColor Magenta
Write-Host "1. Open build #${env:BUILD_NUMBER} in Jenkins" -ForegroundColor White
Write-Host "2. Click on 'Build Artifacts' link in the left sidebar" -ForegroundColor White
Write-Host "3. Click on 'artifact-index.html' to see a summary of all artifacts" -ForegroundColor White
Write-Host "4. Individual artifacts can be accessed directly from the artifacts list" -ForegroundColor White

Write-Host "`n🚀 Ready to run Jenkins build and verify artifacts are visible!" -ForegroundColor Green
