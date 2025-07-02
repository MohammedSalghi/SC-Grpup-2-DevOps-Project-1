Write-Host "Quick Jenkins Docker Fix - Starting..." -ForegroundColor Yellow

# Stop current Jenkins
docker stop jenkins-server
docker rm jenkins-server

# Start Jenkins with Docker access
docker run -d --name jenkins-server -p 8081:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock --user root jenkins/jenkins:lts

Write-Host "Waiting for Jenkins to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Install Docker in Jenkins
docker exec jenkins-server bash -c "apt-get update && apt-get install -y docker.io"

Write-Host "Jenkins with Docker is ready at http://localhost:8081" -ForegroundColor Green
