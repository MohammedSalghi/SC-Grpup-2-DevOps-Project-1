# Quick Build Test (Fast Docker Build)
Write-Host "=== TESTING FAST BUILD ===" -ForegroundColor Cyan

# Test fast Docker build
Write-Host "Building with optimized Dockerfile..." -ForegroundColor Green
docker build -f Dockerfile.fast -t mohammedsalghi24/sc-grpup-2-devops-project-1:fast .

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Fast build completed!" -ForegroundColor Green
    
    # Test the fast image
    docker stop test-fast 2>$null | Out-Null
    docker rm test-fast 2>$null | Out-Null
    docker run -d -p 8087:80 --name test-fast mohammedsalghi24/sc-grpup-2-devops-project-1:fast
    
    Write-Host "✓ Fast container running on http://localhost:8087" -ForegroundColor Green
    Start-Process "http://localhost:8087"
} else {
    Write-Host "✗ Fast build failed" -ForegroundColor Red
}

Write-Host ""
Write-Host "SPEED COMPARISON:" -ForegroundColor Yellow
Write-Host "Original build: 30+ seconds" -ForegroundColor Red
Write-Host "Fast build: Should be 5-10 seconds" -ForegroundColor Green
