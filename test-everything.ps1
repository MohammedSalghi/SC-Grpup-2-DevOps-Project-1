# Test All DevOps Integrations
Write-Host "Testing GitHub + Jenkins + Docker + Jira..." -ForegroundColor Cyan

# 1. GitHub Test
Write-Host "1. Testing GitHub..." -ForegroundColor Green
Write-Output "Test $(Get-Date)" | Add-Content index.html
git add -A
git commit -m "SCRUM-11: Test all integrations"
git push origin main
Write-Host "GitHub: DONE" -ForegroundColor Green

# 2. Docker Hub Test  
Write-Host "2. Testing Docker Hub..." -ForegroundColor Green
docker pull mohammedsalghi24/sc-grpup-2-devops-project-1:latest
docker run -d -p 8086:80 --name test-all mohammedsalghi24/sc-grpup-2-devops-project-1:latest
Write-Host "Docker Hub: DONE" -ForegroundColor Green

# 3. Open Services
Write-Host "3. Opening services..." -ForegroundColor Green
Start-Process "http://localhost:8081"
Start-Process "https://mohammedsalghi24.atlassian.net/browse/SCRUM-11"
Write-Host "Services: OPENED" -ForegroundColor Green

Write-Host "ALL TESTS COMPLETE!" -ForegroundColor Green
