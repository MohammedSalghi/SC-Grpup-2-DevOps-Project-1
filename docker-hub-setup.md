# 🐳 Setup Docker Hub Integration for Jenkins

## 📋 Prerequisites:
1. Docker Hub account
2. Docker installed on Jenkins server 
3. Jenkins Docker credentials configured

## 🔧 Setup Steps:

### Step 1: Create Docker Hub Credentials in Jenkins
1. Go to Jenkins: http://localhost:8081
2. Navigate: **Manage Jenkins** → **Credentials**
3. Click **"Global credentials (unrestricted)"**
4. Click **"Add Credentials"**
5. Configure:
   - **Kind**: Username with password
   - **Username**: Your Docker Hub username (e.g., `mohammedsalghi24`)
   - **Password**: Your Docker Hub password/token
   - **ID**: `docker-hub-credentials`
   - **Description**: Docker Hub Login

### Step 2: Verify Dockerfile Exists
Make sure you have a `Dockerfile` in your project root.

### Step 3: Test Docker Commands
Your pipeline will now:
1. ✅ Pull code from GitHub
2. ✅ Run JMeter performance tests  
3. ✅ Build Docker image: `mohammedsalghi24/sc-grpup-2-devops-project-1:BUILD_NUMBER`
4. ✅ Push to Docker Hub automatically

## 🎯 Complete Pipeline Flow:
```
GitHub Push → Jenkins Webhook → 
Jira Extraction → JMeter Tests → 
Docker Build → Docker Push → 
Performance Reports
```

## 🚀 Expected Output:
- Docker images available at: https://hub.docker.com/r/mohammedsalghi24/sc-grpup-2-devops-project-1
- Performance reports in Jenkins artifacts
- Full CI/CD automation

## ⚠️ If Docker Commands Fail:
1. Check Jenkins has Docker installed
2. Verify Docker Hub credentials
3. Ensure Dockerfile exists in project root
