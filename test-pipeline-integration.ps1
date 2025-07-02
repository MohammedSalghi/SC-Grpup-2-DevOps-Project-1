# Integration Test Script for CI/CD Pipeline
# Tests GitHub → JMeter → Docker → Docker Hub connectivity

Write-Host "🚀 Testing CI/CD Pipeline Components" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Date: $(Get-Date)"
Write-Host "Build: Manual verification test"
Write-Host ""

# 1. Test GitHub Connectivity
Write-Host "1️⃣ Testing GitHub Connectivity..." -ForegroundColor Green
try {
    $gitOutput = git ls-remote https://github.com/MohammedSalghi/SC-Grpup-2-DevOps-Project-1 HEAD 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ GitHub repository is accessible" -ForegroundColor Green
        Write-Host "Repository: https://github.com/MohammedSalghi/SC-Grpup-2-DevOps-Project-1"
        $latestCommit = git log -1 --pretty=%H
        Write-Host "Latest commit: $latestCommit"
        Write-Host ""
    } else {
        Write-Host "❌ Could not connect to GitHub repository" -ForegroundColor Red
        Write-Host ""
    }
} catch {
    Write-Host "❌ Error connecting to GitHub: $_" -ForegroundColor Red
    Write-Host ""
}

# 2. Test Jira Connectivity
Write-Host "2️⃣ Testing Jira Connectivity..." -ForegroundColor Green
$JIRA_URL = "https://mohammedsalghi24.atlassian.net/browse/SCRUM-11"
try {
    $jiraResponse = Invoke-WebRequest -Uri $JIRA_URL -UseBasicParsing -ErrorAction SilentlyContinue
    if ($jiraResponse.StatusCode -ge 200 -and $jiraResponse.StatusCode -lt 400) {
        Write-Host "✅ Jira is accessible" -ForegroundColor Green
        Write-Host "Jira URL: $JIRA_URL"
        Write-Host ""
    } else {
        Write-Host "⚠️ Jira returned status code: $($jiraResponse.StatusCode)" -ForegroundColor Yellow
        Write-Host "Jira URL: $JIRA_URL"
        Write-Host ""
    }
} catch {
    Write-Host "⚠️ Jira may require authentication or isn't directly accessible" -ForegroundColor Yellow
    Write-Host "Jira URL: $JIRA_URL"
    Write-Host ""
}

# 3. Test Docker Functionality
Write-Host "3️⃣ Testing Docker Functionality..." -ForegroundColor Green
try {
    $dockerVersion = docker --version
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Docker is installed and running" -ForegroundColor Green
        Write-Host "$dockerVersion"
        $imageCount = (docker images | Measure-Object -Line).Lines - 1
        Write-Host "Images: $imageCount available"
        Write-Host ""
    } else {
        Write-Host "❌ Docker is not installed or not running" -ForegroundColor Red
        Write-Host ""
    }
} catch {
    Write-Host "❌ Error checking Docker: $_" -ForegroundColor Red
    Write-Host ""
}

# 4. Test Docker Hub Connectivity
Write-Host "4️⃣ Testing Docker Hub Connectivity..." -ForegroundColor Green
try {
    $response = Invoke-WebRequest -Uri "https://hub.docker.com/v2/" -UseBasicParsing -ErrorAction SilentlyContinue
    Write-Host "✅ Docker Hub is accessible" -ForegroundColor Green
    
    # Check if repository exists
    try {
        $repoResponse = Invoke-WebRequest -Uri "https://hub.docker.com/v2/repositories/mohammedsalghi24/sc-grpup-2-devops-project-1" -UseBasicParsing -ErrorAction SilentlyContinue
        Write-Host "✅ Docker Hub repository exists: mohammedsalghi24/sc-grpup-2-devops-project-1" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Repository may be private or doesn't exist: mohammedsalghi24/sc-grpup-2-devops-project-1" -ForegroundColor Yellow
    }
    Write-Host ""
} catch {
    Write-Host "❌ Could not connect to Docker Hub" -ForegroundColor Red
    Write-Host ""
}

# 5. Test JMeter Test Plan
Write-Host "5️⃣ Testing JMeter Test Plan..." -ForegroundColor Green
if (Test-Path "performance-test.jmx") {
    Write-Host "✅ JMeter test plan exists: performance-test.jmx" -ForegroundColor Green
} else {
    Write-Host "⚠️ JMeter test plan not found, creating sample..." -ForegroundColor Yellow
    @'
<?xml version="1.0" encoding="UTF-8"?>
<jmeterTestPlan version="1.2" properties="5.0" jmeter="5.4.1">
  <hashTree>
    <TestPlan guiclass="TestPlanGui" testclass="TestPlan" testname="Quick Performance Test" enabled="true">
      <stringProp name="TestPlan.comments">Fast performance test</stringProp>
      <boolProp name="TestPlan.functional_mode">false</boolProp>
      <boolProp name="TestPlan.serialize_threadgroups">false</boolProp>
    </TestPlan>
    <hashTree>
      <ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="Thread Group" enabled="true">
        <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
        <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="Loop Controller" enabled="true">
          <boolProp name="LoopController.continue_forever">false</boolProp>
          <stringProp name="LoopController.loops">3</stringProp>
        </elementProp>
        <stringProp name="ThreadGroup.num_threads">2</stringProp>
        <stringProp name="ThreadGroup.ramp_time">1</stringProp>
      </ThreadGroup>
      <hashTree>
        <HTTPSamplerProxy guiclass="HttpTestSampleGui" testclass="HTTPSamplerProxy" testname="HTTP Request" enabled="true">
          <elementProp name="HTTPsampler.Arguments" elementType="Arguments" guiclass="HTTPArgumentsPanel" testclass="Arguments" testname="User Defined Variables" enabled="true">
            <collectionProp name="Arguments.arguments"/>
          </elementProp>
          <stringProp name="HTTPSampler.domain">httpbin.org</stringProp>
          <stringProp name="HTTPSampler.port"></stringProp>
          <stringProp name="HTTPSampler.path">/get</stringProp>
          <stringProp name="HTTPSampler.method">GET</stringProp>
        </HTTPSamplerProxy>
      </hashTree>
    </hashTree>
  </hashTree>
</jmeterTestPlan>
'@ | Out-File -FilePath "performance-test.jmx" -Encoding UTF8
    Write-Host "✅ Created sample JMeter test plan" -ForegroundColor Green
}
Write-Host ""

# 6. Test Jenkins Connectivity
Write-Host "6️⃣ Testing Jenkins Connectivity..." -ForegroundColor Green
$JENKINS_URL = "http://localhost:8081"
try {
    $jenkinsResponse = Invoke-WebRequest -Uri $JENKINS_URL -UseBasicParsing -ErrorAction SilentlyContinue
    if ($jenkinsResponse.StatusCode -ge 200 -and $jenkinsResponse.StatusCode -lt 400) {
        Write-Host "✅ Jenkins is accessible" -ForegroundColor Green
        Write-Host "Jenkins URL: $JENKINS_URL"
        Write-Host ""
    } else {
        Write-Host "❌ Jenkins returned status code: $($jenkinsResponse.StatusCode)" -ForegroundColor Red
        Write-Host "Jenkins URL: $JENKINS_URL"
        Write-Host ""
    }
} catch {
    Write-Host "❌ Jenkins is not accessible at $JENKINS_URL" -ForegroundColor Red
    Write-Host ""
}

# Summary
Write-Host "📋 Pipeline Test Summary" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "All components required for pipeline execution have been tested."
Write-Host "To run the pipeline, trigger a build in Jenkins."
Write-Host ""
Write-Host "Pipeline Flow: GitHub → JMeter → Docker → Docker Hub"
Write-Host ""
Write-Host "✅ Test completed at $(Get-Date)" -ForegroundColor Green
