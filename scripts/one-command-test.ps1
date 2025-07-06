# Simple demo command to test all integrations
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$filename = "one-command-test-$timestamp.txt"

# Step 1: Check services
Write-Host "Checking services..."
docker ps

# Step 2: Open monitoring URLs
Write-Host "Opening monitoring pages..."
Start-Process "http://localhost:8081/job/SC-Group-2-DevOps-Project-1/"
Start-Process "http://localhost:8082"
Start-Process "https://github.com/MohammedSalghi/SC-Grpup-2-DevOps-Project-1"
Start-Process "https://hub.docker.com/r/mohammedsalghi24/sc-grpup-2-devops-project-1"
Start-Process "https://mohammedsalghi24.atlassian.net/browse/SCRUM-11"

# Step 3: Create test file
"Testing full integration at $timestamp" | Out-File -FilePath $filename

# Step 4: Commit and push
git add $filename
git commit -m "SCRUM-11: Testing integration with DEV-123 and TEST-456"
git push

Write-Host "Pipeline triggered! Check Jenkins at http://localhost:8081"
