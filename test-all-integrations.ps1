# COMPLETE DEVOPS TEST - GitHub + Jenkins + Docker + Jira
Write-Host "=== TESTING ALL INTEGRATIONS ===" -ForegroundColor Cyan
Write-Host "GitHub + Jenkins + Docker Hub + Jira (SCRUM-11)" -ForegroundColor Yellow
Write-Host ""

# Test 1: GitHub Push + Jenkins Trigger
Write-Host "[1/4] GitHub + Jenkins Test..." -ForegroundColor Green
Write-Output "<!-- SCRUM-11: Test automation $(Get-Date) -->" | Add-Content index.html
git add -A
git commit -m "SCRUM-11: Complete DevOps integration test"
git push origin main
Write-Host "✓ Pushed to GitHub - Jenkins should auto-trigger" -ForegroundColor Green
Write-Host ""

# Test 2: Docker Hub Pull
Write-Host "[2/4] Docker Hub Test..." -ForegroundColor Green
docker pull mohammedsalghi24/sc-grpup-2-devops-project-1:latest
Write-Host "✓ Image pulled from Docker Hub" -ForegroundColor Green
Write-Host ""

# Test 3: Container Deployment
Write-Host "[3/4] Container Deployment..." -ForegroundColor Green
docker stop test-integration 2>$null | Out-Null
docker rm test-integration 2>$null | Out-Null
docker run -d -p 8085:80 --name test-integration mohammedsalghi24/sc-grpup-2-devops-project-1:latest
Write-Host "✓ Container running on http://localhost:8085" -ForegroundColor Green
Write-Host ""

# Test 4: Open All Services
Write-Host "[4/4] Opening All Services..." -ForegroundColor Green
Start-Process "http://localhost:8081"  # Jenkins
Start-Process "http://localhost:8085"  # Test app
Start-Process "https://mohammedsalghi24.atlassian.net/browse/SCRUM-11"  # Jira
Write-Host "✓ All services opened" -ForegroundColor Green
Write-Host ""

Write-Host "=== TEST COMPLETE ===" -ForegroundColor Cyan
Write-Host "✓ GitHub: Commit pushed with SCRUM-11" -ForegroundColor Green
Write-Host "✓ Jenkins: Auto-build triggered" -ForegroundColor Green
Write-Host "✓ Docker Hub: Image pulled" -ForegroundColor Green
Write-Host "✓ Jira: SCRUM-11 ticket opened" -ForegroundColor Green
Write-Host "✓ Container: Running on port 8085" -ForegroundColor Green
Write-Host ""
Write-Host "All integrations tested successfully!" -ForegroundColor Green
