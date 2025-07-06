Write-Host "🔍 Jenkins Artifact Visibility Diagnostic Tool" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

Write-Host "`n📋 Step 1: Verify Jenkins Pipeline Configuration" -ForegroundColor Yellow
Write-Host "Checking Jenkinsfile archiving configurations..." -ForegroundColor White
$archiveCount = (Select-String -Path .\Jenkinsfile -Pattern "archiveArtifacts" -AllMatches).Matches.Count
$fingerprintCount = (Select-String -Path .\Jenkinsfile -Pattern "fingerprint:\s*true" -AllMatches).Matches.Count
Write-Host "✅ Found $archiveCount artifact archiving statements" -ForegroundColor Green
Write-Host "✅ Found $fingerprintCount fingerprinting configurations" -ForegroundColor Green

Write-Host "`n📋 Step 2: Check Artifact Files Existence" -ForegroundColor Yellow
$artifactFiles = @(
    "artifact-index.html",
    "test-results.md",
    "performance-dashboard.html",
    "performance-summary.txt",
    "performance-results.jtl",
    "jmeter-report.html",
    "integration-status.json"
)

foreach ($file in $artifactFiles) {
    if (Test-Path $file) {
        Write-Host "✅ File exists: $file" -ForegroundColor Green
    } else {
        Write-Host "❌ File missing: $file" -ForegroundColor Red
    }
}

Write-Host "`n📋 Step 3: Jenkins Artifact Visibility Troubleshooting" -ForegroundColor Yellow
Write-Host "Common reasons artifacts might not be visible in Jenkins:" -ForegroundColor White
Write-Host "1. The Archive Artifacts option might not be enabled in your pipeline job configuration" -ForegroundColor White
Write-Host "2. Jenkins permissions issue - check that Jenkins can read/write to the workspace" -ForegroundColor White
Write-Host "3. Artifact files may not have been created before archiving" -ForegroundColor White
Write-Host "4. Fingerprinting might not be enabled in Jenkins global configuration" -ForegroundColor White
Write-Host "5. The build may be running on a different node than expected" -ForegroundColor White

Write-Host "`n📋 Step 4: How to Access Artifacts in Jenkins" -ForegroundColor Yellow
Write-Host "1. Navigate to your Jenkins job" -ForegroundColor White
Write-Host "2. Select the build number (e.g., 29)" -ForegroundColor Whitehite
Write-Host "3. Click on Build Artifacts in the left navigation panel" -ForegroundColor White
Write-Host "   - If this link is missing, artifacts were not archived successfully" -ForegroundColor White
Write-Host "4. Direct URL should be: http://localhost:8081/job/SC-devops-pipeline/29/artifact/" -ForegroundColor White

Write-Host "`n📋 Step 5: Verify Jenkins Configuration" -ForegroundColor Yellow
Write-Host "1. Check Jenkins Manage > Configure System > Artifacts" -ForegroundColor White
Write-Host "2. Ensure Discard Old Builds is not removing your artifacts" -ForegroundColor White
Write-Host "3. Verify that the Archive Artifacts plugin is installed and enabled" -ForegroundColor White

Write-Host "`n🚀 Recommendation for Next Build:" -ForegroundColor Magenta
Write-Host "Run the following command in Jenkins Script Console to verify artifact storage:" -ForegroundColor White
Write-Host "println Jenkins.instance.getItemByFullName('SC-devops-pipeline').getBuildByNumber(29).artifacts" -ForegroundColor Gray

Write-Host "`nConsider adding explicit artifact handling in post block:" -ForegroundColor White
Write-Host "post {" -ForegroundColor Gray
Write-Host "    success {" -ForegroundColor Gray
Write-Host "        archiveArtifacts artifacts: '**/artifact-index.html, **/test-results.md'," -ForegroundColor Gray
Write-Host "                     fingerprint: true," -ForegroundColor Gray
Write-Host "                     allowEmptyArchive: false" -ForegroundColor Gray
Write-Host "    }" -ForegroundColor Gray
Write-Host "}" -ForegroundColor Gray

Write-Host "`n✅ Diagnostic completed!" -ForegroundColor Green
