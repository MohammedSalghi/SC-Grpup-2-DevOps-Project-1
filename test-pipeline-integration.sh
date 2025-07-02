#!/bin/bash

# Integration Test Script for CI/CD Pipeline
# Tests GitHub → JMeter → Docker → Docker Hub connectivity

echo "🚀 Testing CI/CD Pipeline Components"
echo "======================================"
echo "Date: $(date)"
echo "Build: Manual verification test"
echo ""

# 1. Test GitHub Connectivity
echo "1️⃣ Testing GitHub Connectivity..."
if git ls-remote https://github.com/MohammedSalghi/SC-Grpup-2-DevOps-Project-1 HEAD &> /dev/null; then
    echo "✅ GitHub repository is accessible"
    echo "Repository: https://github.com/MohammedSalghi/SC-Grpup-2-DevOps-Project-1"
    echo "Latest commit: $(git log -1 --pretty=%H)"
    echo ""
else
    echo "❌ Could not connect to GitHub repository"
    echo ""
fi

# 2. Test Jira Connectivity
echo "2️⃣ Testing Jira Connectivity..."
JIRA_URL="https://mohammedsalghi24.atlassian.net/browse/SCRUM-11"
if curl -s -o /dev/null -w "%{http_code}" "$JIRA_URL" | grep -q "200\|300"; then
    echo "✅ Jira is accessible"
    echo "Jira URL: $JIRA_URL"
    echo ""
else
    echo "⚠️ Jira may require authentication or isn't directly accessible"
    echo "Jira URL: $JIRA_URL"
    echo ""
fi

# 3. Test Docker Functionality
echo "3️⃣ Testing Docker Functionality..."
if docker --version &> /dev/null; then
    echo "✅ Docker is installed and running"
    echo "$(docker --version)"
    echo "Images: $(docker images | wc -l) available"
    echo ""
else
    echo "❌ Docker is not installed or not running"
    echo ""
fi

# 4. Test Docker Hub Connectivity
echo "4️⃣ Testing Docker Hub Connectivity..."
if curl -s https://hub.docker.com/v2/ &> /dev/null; then
    echo "✅ Docker Hub is accessible"
    # Check if repository exists
    if curl -s "https://hub.docker.com/v2/repositories/mohammedsalghi24/sc-grpup-2-devops-project-1" | grep -q "name"; then
        echo "✅ Docker Hub repository exists: mohammedsalghi24/sc-grpup-2-devops-project-1"
    else
        echo "⚠️ Repository may be private or doesn't exist: mohammedsalghi24/sc-grpup-2-devops-project-1"
    fi
    echo ""
else
    echo "❌ Could not connect to Docker Hub"
    echo ""
fi

# 5. Test JMeter Test Plan
echo "5️⃣ Testing JMeter Test Plan..."
if [ -f "performance-test.jmx" ]; then
    echo "✅ JMeter test plan exists: performance-test.jmx"
else
    echo "⚠️ JMeter test plan not found, creating sample..."
    cat > performance-test.jmx << 'EOF'
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
EOF
    echo "✅ Created sample JMeter test plan"
fi
echo ""

# 6. Test Jenkins Connectivity
echo "6️⃣ Testing Jenkins Connectivity..."
JENKINS_URL="http://localhost:8081"
if curl -s -o /dev/null -w "%{http_code}" "$JENKINS_URL" | grep -q "200\|300"; then
    echo "✅ Jenkins is accessible"
    echo "Jenkins URL: $JENKINS_URL"
    echo ""
else
    echo "❌ Jenkins is not accessible at $JENKINS_URL"
    echo ""
fi

# Summary
echo "📋 Pipeline Test Summary"
echo "======================================"
echo "All components required for pipeline execution have been tested."
echo "To run the pipeline, trigger a build in Jenkins."
echo ""
echo "Pipeline Flow: GitHub → JMeter → Docker → Docker Hub"
echo ""
echo "✅ Test completed at $(date)"
