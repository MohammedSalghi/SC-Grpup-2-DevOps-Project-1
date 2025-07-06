# Fresh Jenkins Setup Guide - SCRUM-11 Pipeline

## 🚀 **Initial Setup Steps**

### 1. Jenkins Initial Configuration
- **URL**: http://localhost:8081
- **Jira Issue**: https://mohammedsalghi24.atlassian.net/browse/SCRUM-11
- **Docker Hub**: https://hub.docker.com/repository/docker/mohammedsalghi24/sc-grpup-2-devops-project-1

### 2. Required Jenkins Plugins
Install these plugins during setup:
- ✅ Git plugin
- ✅ GitHub plugin  
- ✅ Docker Pipeline plugin
- ✅ JMeter plugin (Performance)
- ✅ HTML Publisher plugin
- ✅ Jira plugin (optional)

### 3. Configure Credentials
Go to Jenkins → Manage Jenkins → Credentials → Global → Add Credentials:

#### Docker Hub Credentials:
- **Kind**: Username with password
- **ID**: `docker-hub-credentials`
- **Username**: `mohammedsalghi24`
- **Password**: `[Your Docker Hub Token/Password]`

#### GitHub Credentials (if needed):
- **Kind**: Username with password  
- **ID**: `github-credentials`
- **Username**: `MohammedSalghi`
- **Password**: `[Your GitHub Token]`

### 4. Create New Pipeline Job
1. Click "New Item"
2. Enter name: `SC-DevOps-Pipeline-Fresh`
3. Select "Pipeline"
4. Click "OK"

### 5. Pipeline Configuration
In the pipeline configuration:
- **Definition**: Pipeline script from SCM
- **SCM**: Git
- **Repository URL**: `https://github.com/MohammedSalghi/SC-Grpup-2-DevOps-Project-1.git`
- **Branch**: `*/main`
- **Script Path**: `Jenkinsfile`

### 6. GitHub Webhook (Optional)
For automatic triggering:
1. Go to your GitHub repo → Settings → Webhooks
2. Add webhook: `http://[YOUR_IP]:8081/github-webhook/`
3. Content type: `application/json`
4. Events: Just push events

## 🔧 **Pipeline Features**

### What This Pipeline Does:
1. ✅ **Checkout**: Gets latest code from GitHub
2. ✅ **Jira Integration**: Extracts issue keys from commit messages
3. ✅ **Build**: Compiles/prepares the application
4. ✅ **Performance Test**: Runs JMeter tests (simulated)
5. ✅ **Docker Build**: Creates Docker image with build number
6. ✅ **Docker Push**: Pushes to Docker Hub (if credentials configured)
7. ✅ **Results**: Archives test reports and provides summary

### Docker Images Created:
- `mohammedsalghi24/sc-grpup-2-devops-project-1:BUILD_NUMBER`
- `mohammedsalghi24/sc-grpup-2-devops-project-1:latest`

## 🧪 **Testing the Pipeline**

### Manual Trigger:
1. Go to Jenkins → Your Pipeline → Build Now

### Automatic Trigger:
1. Make a commit with Jira issue (e.g., "SCRUM-20: New feature")
2. Push to GitHub
3. Pipeline should trigger automatically (if webhook configured)

## 🐳 **Docker Hub Integration**

Your images will be pushed to:
**https://hub.docker.com/repository/docker/mohammedsalghi24/sc-grpup-2-devops-project-1**

To pull and run your image:
```bash
docker pull mohammedsalghi24/sc-grpup-2-devops-project-1:latest
docker run -p 8080:80 mohammedsalghi24/sc-grpup-2-devops-project-1:latest
```

## 📋 **Jira Integration (Optional)**

If you want Jira integration:
1. Install Jira plugin in Jenkins
2. Configure Jira site in Jenkins global configuration
3. Add Jira API token credentials
4. Include Jira issue keys in commit messages (SCRUM-XX format)

## 🔍 **Troubleshooting**

### Common Issues:
- **Docker Push Fails**: Check Docker Hub credentials
- **No Jira Updates**: Check Jira plugin configuration
- **Pipeline Fails**: Check Jenkins logs for specific errors
- **GitHub Webhook**: Ensure Jenkins is accessible from internet

### Success Indicators:
- ✅ Pipeline completes with green status
- ✅ Docker images appear on Docker Hub
- ✅ JMeter reports are archived
- ✅ All stages pass without errors

## 📞 **Support**

If you encounter issues:
1. Check Jenkins build logs
2. Verify credentials are configured correctly
3. Ensure all required plugins are installed
4. Test Docker Hub access manually

---
**Created**: 2024-01-24  
**Jenkins Version**: LTS  
**Pipeline**: Declarative
