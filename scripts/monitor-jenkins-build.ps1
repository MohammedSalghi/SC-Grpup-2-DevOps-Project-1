# Monitor Jenkins Build Status
Write-Host "=== MONITORING JENKINS BUILD ===" -ForegroundColor Cyan
Write-Host "Checking for new builds after Git push..." -ForegroundColor Yellow
Write-Host ""

$maxChecks = 6
$checkInterval = 10

for ($i = 1; $i -le $maxChecks; $i++) {
    Write-Host "Check $i/$maxChecks - $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Green
    
    try {
        # Check if Jenkins job exists and get last build info
        $apiUrl = "http://localhost:8081/job/devops-pipeline/api/json"
        $jobInfo = Invoke-RestMethod -Uri $apiUrl -TimeoutSec 5
        
        if ($jobInfo.lastBuild) {
            $buildNumber = $jobInfo.lastBuild.number
            $buildUrl = $jobInfo.lastBuild.url
            
            # Get build details
            $buildInfo = Invoke-RestMethod -Uri "$buildUrl/api/json" -TimeoutSec 5
            $buildResult = $buildInfo.result
            $isBuilding = $buildInfo.building
            
            Write-Host "  Latest build: #$buildNumber" -ForegroundColor White
            if ($isBuilding) {
                Write-Host "  Status: Building..." -ForegroundColor Yellow
            } elseif ($buildResult -eq "SUCCESS") {
                Write-Host "  Status: SUCCESS" -ForegroundColor Green
            } elseif ($buildResult -eq "FAILURE") {
                Write-Host "  Status: FAILED" -ForegroundColor Red
            } else {
                Write-Host "  Status: $buildResult" -ForegroundColor Yellow
            }
            
            # Check if build finished
            if (-not $isBuilding -and $buildResult) {
                Write-Host ""
                Write-Host "✓ Build completed with result: $buildResult" -ForegroundColor Green
                Write-Host "  Build URL: $buildUrl" -ForegroundColor White
                break
            }
        } else {
            Write-Host "  No builds found yet" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  Could not connect to Jenkins API" -ForegroundColor Red
    }
    
    if ($i -lt $maxChecks) {
        Write-Host "  Waiting $checkInterval seconds..." -ForegroundColor Gray
        Start-Sleep $checkInterval
    }
}

Write-Host ""
Write-Host "=== BUILD MONITORING COMPLETE ===" -ForegroundColor Cyan
Write-Host "Check Jenkins dashboard: http://localhost:8081" -ForegroundColor Yellow
Write-Host "Check Docker Hub: https://hub.docker.com/u/mohammedsalghi24" -ForegroundColor Yellow
