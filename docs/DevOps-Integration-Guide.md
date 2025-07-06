# DevOps Project Integration Guide
# Doctor Appointment Booking System - Complete CI/CD Pipeline

## 1. JIRA PROJECT SETUP

### Step 1: Create Jira Cloud Account
1. Go to https://id.atlassian.com/signup
2. Create account with your team email
3. Choose "Jira Software" (free for up to 10 users)
4. Project Name: "Doctor-Appointment-System"
5. Project Key: "DAS" or "DOCS"

### Step 2: Invite Team Members
- Go to Project Settings → People
- Add team members and instructor emails
- Set roles: Admin for you, Developer for team members

### Step 3: Create Initial Issues
```
Epic: DAS-1 - Doctor Appointment System Development
Story: DAS-2 - User Authentication Module
Story: DAS-3 - Appointment Booking Feature
Story: DAS-4 - Doctor Dashboard
Story: DAS-5 - Patient Management
Bug: DAS-6 - Login Page Styling Issues
Task: DAS-7 - Database Schema Setup
```

## 2. GITHUB REPOSITORY SETUP

### Step 1: Create Repository
```bash
# Already have the repo, but configure it properly
git remote -v
git config user.name "Your Name"
git config user.email "your.email@domain.com"
```

### Step 2: Invite Collaborators
- Go to GitHub repo → Settings → Manage access
- Click "Invite a collaborator"
- Add team members and instructor GitHub usernames

### Step 3: Branch Protection Rules
- Settings → Branches → Add rule
- Branch name: main
- Require pull request reviews
- Require status checks to pass

## 3. JENKINS PLUGINS INSTALLATION

### Required Plugins:
1. Jira Integration Plugin
2. GitHub Integration Plugin
3. Performance Plugin (for JMeter)
4. Docker Pipeline Plugin
5. Blue Ocean Plugin
6. Credentials Binding Plugin

### Installation Commands:
```groovy
// Install via Jenkins CLI or UI
jenkins-plugin-cli --plugins jira:latest
jenkins-plugin-cli --plugins github:latest
jenkins-plugin-cli --plugins performance:latest
jenkins-plugin-cli --plugins docker-workflow:latest
```

## 4. JIRA-JENKINS INTEGRATION CONFIGURATION

### Jira Connection in Jenkins:
1. Go to Jenkins → Manage Jenkins → Configure System
2. Find "Jira" section
3. Add Jira site:
   - Name: "Project Jira"
   - URL: https://yourteam.atlassian.net
   - Credentials: Add Jira API token

### API Token Creation:
1. Jira → Profile → Personal settings → Security → API tokens
2. Create token, copy it
3. Jenkins → Credentials → Add → Username/Password
   - Username: your-jira-email@domain.com
   - Password: paste-api-token-here

## 5. COMPLETE PIPELINE CONFIGURATION

### Environment Variables in Jenkins:
```
JIRA_SITE = your-project-jira
JIRA_PROJECT_KEY = DAS
DOCKER_HUB_REPO = your-dockerhub-username/doctor-appointment-system
GITHUB_REPO = your-github-username/SC-Grpup-2-DevOps-Project-1
```

## 6. DOCKER HUB SETUP

### Steps:
1. Create Docker Hub account
2. Create repository: doctor-appointment-system
3. Generate access token
4. Add to Jenkins credentials

## 7. JMETER INTEGRATION

### JMeter Test Configuration:
- Performance test file: performance-test.jmx (already in project)
- Jenkins will run tests and generate reports
- Results published to Jenkins dashboard

## 8. AUTOMATED WORKFLOW

### Workflow Triggers:
1. Code commit → GitHub webhook → Jenkins build
2. Jenkins build → Jira issue update
3. Tests pass → Docker image build
4. Docker image → Push to Docker Hub
5. JMeter tests → Performance report

### Team Collaboration:
- Developers work on feature branches
- Pull requests trigger Jenkins builds
- Jira issues automatically updated
- Performance reports shared with team
