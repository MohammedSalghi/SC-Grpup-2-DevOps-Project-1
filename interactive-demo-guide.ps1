# 🚀 INTERACTIVE DEVOPS PIPELINE DEMO GUIDE
# This script provides an interactive guide to demonstrate all aspects of your CI/CD pipeline
# Features colorful progress bars, detailed explanations, and automatic browser navigation

function Show-Header {
    param (
        [string]$title
    )
    
    $width = $host.UI.RawUI.WindowSize.Width - 4
    $padding = [math]::Max(0, ($width - $title.Length) / 2)
    $stars = "*" * $width
    
    Write-Host "`n$stars" -ForegroundColor Cyan
    Write-Host ("*" + " " * $width + "*") -ForegroundColor Cyan
    Write-Host ("*" + " " * [math]::Floor($padding) + $title + " " * [math]::Ceiling($padding) + "*") -ForegroundColor Cyan
    Write-Host ("*" + " " * $width + "*") -ForegroundColor Cyan
    Write-Host "$stars`n" -ForegroundColor Cyan
}

function Show-ProgressBar {
    param (
        [int]$percent,
        [string]$status,
        [string]$color = "Green"
    )
    
    $width = $host.UI.RawUI.WindowSize.Width - 20
    $completed = [math]::Floor($width * $percent / 100)
    $remaining = $width - $completed
    
    Write-Host "[$percent%] " -NoNewline
    
    if ($color -eq "Green") {
        Write-Host ("■" * $completed) -NoNewline -ForegroundColor Green
    } elseif ($color -eq "Yellow") {
        Write-Host ("■" * $completed) -NoNewline -ForegroundColor Yellow
    } elseif ($color -eq "Red") {
        Write-Host ("■" * $completed) -NoNewline -ForegroundColor Red
    } elseif ($color -eq "Cyan") {
        Write-Host ("■" * $completed) -NoNewline -ForegroundColor Cyan
    } elseif ($color -eq "Magenta") {
        Write-Host ("■" * $completed) -NoNewline -ForegroundColor Magenta
    }
    
    Write-Host ("□" * $remaining) -NoNewline -ForegroundColor DarkGray
    Write-Host " $status"
}

function Wait-WithSpinner {
    param (
        [int]$seconds,
        [string]$message
    )
    
    $spinner = "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"
    $spinnerPos = 0
    
    for ($i = 0; $i -lt $seconds; $i++) {
        $spinnerChar = $spinner[$spinnerPos]
        Write-Host "`r$spinnerChar $message ($($seconds - $i)s remaining)" -NoNewline
        Start-Sleep -Milliseconds 100
        $spinnerPos = ($spinnerPos + 1) % $spinner.Length
    }
    Write-Host "`r✓ $message (Complete)       " -ForegroundColor Green
}

# Show initial header
Show-Header "INTERACTIVE DEVOPS PIPELINE DEMO"

# Introduction
Write-Host "This interactive guide will walk you through a complete demonstration of"
Write-Host "your DevOps pipeline integrating GitHub, Jenkins, Docker, JMeter, and Jira."
Write-Host "Follow each step to showcase the full CI/CD workflow.`n" -ForegroundColor Yellow

Write-Host "Press Enter to begin the demo..." -ForegroundColor Cyan
Read-Host | Out-Null

# Step 1: System Check
Show-Header "STEP 1: SYSTEM CHECK"

# Check Docker status
Write-Host "🔍 Checking Docker status..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    $dockerRunning = $true
    Show-ProgressBar -percent 100 -status "Docker is running: $dockerVersion" -color "Green"
} catch {
    $dockerRunning = $false
    Show-ProgressBar -percent 30 -status "Docker is not running or not installed" -color "Red"
}

# Check Jenkins access
Write-Host "`n🔍 Checking Jenkins access..." -ForegroundColor Yellow
try {
    $jenkinsResponse = Invoke-WebRequest -Uri "http://localhost:8081" -UseBasicParsing -TimeoutSec 5
    $jenkinsRunning = $true
    Show-ProgressBar -percent 100 -status "Jenkins is accessible at http://localhost:8081" -color "Green"
} catch {
    $jenkinsRunning = $false
    Show-ProgressBar -percent 30 -status "Jenkins is not accessible" -color "Red"
}

# Check Web App access
Write-Host "`n🔍 Checking Web App access..." -ForegroundColor Yellow
try {
    $webAppResponse = Invoke-WebRequest -Uri "http://localhost:8082" -UseBasicParsing -TimeoutSec 5
    $webAppRunning = $true
    Show-ProgressBar -percent 100 -status "Web App is accessible at http://localhost:8082" -color "Green"
} catch {
    $webAppRunning = $false
    Show-ProgressBar -percent 30 -status "Web App is not accessible" -color "Red"
}

# Check Git repository
Write-Host "`n🔍 Checking Git repository..." -ForegroundColor Yellow
try {
    $gitStatus = git status
    $gitConfigured = $true
    Show-ProgressBar -percent 100 -status "Git repository is configured" -color "Green"
} catch {
    $gitConfigured = $false
    Show-ProgressBar -percent 30 -status "Git repository is not properly configured" -color "Red"
}

# Check JMeter test plan
Write-Host "`n🔍 Checking JMeter test plan..." -ForegroundColor Yellow
if (Test-Path "devops-web-app-load-test.jmx") {
    $jmeterConfigured = $true
    Show-ProgressBar -percent 100 -status "JMeter test plan found: devops-web-app-load-test.jmx" -color "Green"
} else {
    $jmeterConfigured = $false
    Show-ProgressBar -percent 30 -status "JMeter test plan not found" -color "Red"
}

# System Check Summary
Write-Host "`n📊 System Check Summary:" -ForegroundColor Cyan
Write-Host "Docker:     $(if ($dockerRunning) {"✅ Running"} else {"❌ Not Running"})"
Write-Host "Jenkins:    $(if ($jenkinsRunning) {"✅ Accessible"} else {"❌ Not Accessible"})"
Write-Host "Web App:    $(if ($webAppRunning) {"✅ Accessible"} else {"❌ Not Accessible"})"
Write-Host "Git Repo:   $(if ($gitConfigured) {"✅ Configured"} else {"❌ Not Configured"})"
Write-Host "JMeter:     $(if ($jmeterConfigured) {"✅ Configured"} else {"❌ Not Configured"})"

if (!$dockerRunning -or !$jenkinsRunning -or !$gitConfigured) {
    Write-Host "`n⚠️ Critical components are missing. Fix these issues before proceeding." -ForegroundColor Red
    exit
}

Write-Host "`nPress Enter to continue to Step 2..." -ForegroundColor Cyan
Read-Host | Out-Null

# Step 2: Open Key Applications
Show-Header "STEP 2: OPENING KEY APPLICATIONS"

Write-Host "🌐 Opening all pipeline components in your browser...`n" -ForegroundColor Yellow

# Open applications with progress visualization
if ($jenkinsRunning) {
    Write-Host "Opening Jenkins..." -NoNewline
    Start-Process "http://localhost:8081"
    Wait-WithSpinner -seconds 2 -message "Opening Jenkins"
}

if ($webAppRunning) {
    Write-Host "Opening Web Application..." -NoNewline
    Start-Process "http://localhost:8082"
    Wait-WithSpinner -seconds 2 -message "Opening Web Application"
}

Write-Host "Opening GitHub Repository..." -NoNewline
Start-Process "https://github.com/MohammedSalghi/SC-Grpup-2-DevOps-Project-1"
Wait-WithSpinner -seconds 2 -message "Opening GitHub Repository"

Write-Host "Opening Docker Hub Repository..." -NoNewline
Start-Process "https://hub.docker.com/r/mohammedsalghi24/sc-grpup-2-devops-project-1"
Wait-WithSpinner -seconds 2 -message "Opening Docker Hub Repository"

Write-Host "Opening Jira Dashboard..." -NoNewline
Start-Process "https://mohammedsalghi24.atlassian.net/browse/SCRUM-11"
Wait-WithSpinner -seconds 2 -message "Opening Jira Dashboard"

Write-Host "`n✅ All applications opened successfully!" -ForegroundColor Green
Write-Host "📝 Note: Arrange these windows for easy viewing during the demonstration.`n" -ForegroundColor Yellow

Write-Host "Press Enter to continue to Step 3..." -ForegroundColor Cyan
Read-Host | Out-Null

# Step 3: Pipeline Explanation
Show-Header "STEP 3: PIPELINE EXPLANATION"

Write-Host "📋 Your CI/CD Pipeline Components:" -ForegroundColor Yellow

Write-Host "`n1️⃣ GitHub (Code Repository)" -ForegroundColor Cyan
Write-Host "   ├─ Stores application source code"
Write-Host "   ├─ Detects changes via commits/pushes"
Write-Host "   ├─ Webhooks trigger Jenkins builds"
Write-Host "   └─ Parses Jira ticket numbers from commit messages"

Write-Host "`n2️⃣ Jenkins (Automation Server)" -ForegroundColor Cyan
Write-Host "   ├─ Builds code automatically when changes detected"
Write-Host "   ├─ Executes Jenkinsfile pipeline stages:"
Write-Host "   │  ├─ Quick Build - Initial code validation"
Write-Host "   │  ├─ Fast Docker - Creates container image"
Write-Host "   │  └─ JMeter Performance Test - Load testing"
Write-Host "   ├─ Archives test results and artifacts"
Write-Host "   └─ Links builds to Jira tickets"

Write-Host "`n3️⃣ Docker (Containerization)" -ForegroundColor Cyan
Write-Host "   ├─ Builds application container from Dockerfile"
Write-Host "   ├─ Tags images with build number and 'latest'"
Write-Host "   ├─ Pushes images to Docker Hub registry"
Write-Host "   └─ Makes application instantly deployable"

Write-Host "`n4️⃣ JMeter (Performance Testing)" -ForegroundColor Cyan
Write-Host "   ├─ Executes load tests against web application"
Write-Host "   ├─ Simulates multiple concurrent users"
Write-Host "   ├─ Measures response times and throughput"
Write-Host "   └─ Generates HTML reports with graphs and metrics"

Write-Host "`n5️⃣ Jira (Issue Tracking)" -ForegroundColor Cyan
Write-Host "   ├─ Tracks feature development and issues"
Write-Host "   ├─ Detects ticket IDs in commit messages"
Write-Host "   ├─ Links code changes to tickets automatically"
Write-Host "   └─ Provides full traceability of changes"

Write-Host "`nPress Enter to continue to Step 4..." -ForegroundColor Cyan
Read-Host | Out-Null

# Step 4: Create and Push Test Commit
Show-Header "STEP 4: TRIGGER THE PIPELINE"

Write-Host "🚀 Now we'll create a commit that will trigger the entire pipeline"
Write-Host "This will demonstrate all integrations in real-time.`n" -ForegroundColor Yellow

# Create timestamp and file
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$filename = "interactive-demo-test-$timestamp.txt"

# Generate content with Jira references
$fileContent = @"
# INTERACTIVE PIPELINE DEMO - $timestamp

## DevOps Pipeline Components Demonstrated:
1. ✅ GitHub webhook integration
2. ✅ Jenkins automated pipeline
3. ✅ Docker image building and publishing
4. ✅ JMeter performance testing
5. ✅ Jira ticket integration and traceability

## Jira References:
- SCRUM-11: Main DevOps pipeline integration
- DEV-123: Feature implementation
- TEST-456: Performance testing integration

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@

# Create file and add to git
Write-Host "📝 Creating demo file: $filename" -ForegroundColor Yellow
$fileContent | Out-File -FilePath $filename -Encoding UTF8

Write-Host "`n🔄 Adding file to git..." -ForegroundColor Yellow
git add $filename

Write-Host "`n🔄 Committing with Jira references..." -ForegroundColor Yellow
git commit -m "SCRUM-11: Interactive pipeline demo with DEV-123 and TEST-456 references"

# Confirm before push
Write-Host "`n⚠️ Ready to push and trigger the pipeline" -ForegroundColor Magenta
Write-Host "This will start a real build in Jenkins that will:" -ForegroundColor Yellow
Write-Host "  1. Build your application" -ForegroundColor Yellow
Write-Host "  2. Create a Docker image" -ForegroundColor Yellow
Write-Host "  3. Push to Docker Hub" -ForegroundColor Yellow
Write-Host "  4. Run JMeter performance tests" -ForegroundColor Yellow
Write-Host "  5. Update Jira tickets" -ForegroundColor Yellow

Write-Host "`nPress Enter to push changes and trigger the pipeline, or Ctrl+C to cancel..." -ForegroundColor Cyan
Read-Host | Out-Null

# Push changes
Write-Host "`n🚀 Pushing changes to trigger pipeline..." -ForegroundColor Green
git push

Write-Host "`n✅ PIPELINE TRIGGERED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "The build should start momentarily in Jenkins." -ForegroundColor Yellow

# Open Jenkins build
if ($jenkinsRunning) {
    Write-Host "`n🔗 Opening Jenkins build console..." -ForegroundColor Cyan
    Start-Process "http://localhost:8081/job/SC-Group-2-DevOps-Project-1/lastBuild/console"
}

Write-Host "`nPress Enter to continue to Step 5..." -ForegroundColor Cyan
Read-Host | Out-Null

# Step 5: Monitor Pipeline Progress
Show-Header "STEP 5: MONITOR PIPELINE PROGRESS"

Write-Host "📊 Your pipeline is now running. Let's monitor the progress:" -ForegroundColor Yellow

Write-Host "`n🔍 What to Look For in Each Component:" -ForegroundColor Cyan

Write-Host "`n1️⃣ In Jenkins:" -ForegroundColor Green
Write-Host "   ├─ Pipeline stages executing sequentially"
Write-Host "   ├─ Console output showing 'Found Jira issue: SCRUM-11'"
Write-Host "   ├─ Docker build and push commands"
Write-Host "   └─ JMeter performance test execution"

Write-Host "`n2️⃣ In Docker Hub:" -ForegroundColor Green
Write-Host "   ├─ New image being pushed"
Write-Host "   ├─ Latest build tag"
Write-Host "   └─ Updated timestamp"

Write-Host "`n3️⃣ In Jira:" -ForegroundColor Green
Write-Host "   ├─ SCRUM-11 ticket should show the linked build"
Write-Host "   ├─ Comment with build information"
Write-Host "   └─ Traceability from ticket to code"

Write-Host "`n4️⃣ After Build Completion:" -ForegroundColor Green
Write-Host "   ├─ JMeter test results as artifacts"
Write-Host "   ├─ Performance reports in HTML format"
Write-Host "   └─ Build status in all systems"

# Estimated wait time
Write-Host "`n⏱️ Estimated build time: 1-2 minutes" -ForegroundColor Magenta
Write-Host "While waiting, you can explain each component of the pipeline to your audience." -ForegroundColor Yellow

Write-Host "`nPress Enter when the build completes to continue to Step 6..." -ForegroundColor Cyan
Read-Host | Out-Null

# Step 6: Verify Results
Show-Header "STEP 6: VERIFY RESULTS"

Write-Host "🔍 Let's verify the results of the pipeline:" -ForegroundColor Yellow

# Open Jenkins artifacts
if ($jenkinsRunning) {
    Write-Host "`n📦 Opening Jenkins build artifacts..." -ForegroundColor Cyan
    Start-Process "http://localhost:8081/job/SC-Group-2-DevOps-Project-1/lastBuild/artifact/"
}

Write-Host "`n📋 Results Verification Checklist:" -ForegroundColor Cyan

Write-Host "`n1️⃣ Jenkins Build:" -ForegroundColor Green
Write-Host "   □ All stages completed successfully"
Write-Host "   □ Build console shows Jira ticket detection"
Write-Host "   □ JMeter performance test results available as artifacts"

Write-Host "`n2️⃣ Docker Hub:" -ForegroundColor Green
Write-Host "   □ New image available with latest tag"
Write-Host "   □ Build number tag matches Jenkins build"

Write-Host "`n3️⃣ Jira Integration:" -ForegroundColor Green
Write-Host "   □ SCRUM-11 ticket shows build information"
Write-Host "   □ Links between code, build, and ticket are visible"

Write-Host "`n4️⃣ Performance Testing:" -ForegroundColor Green
Write-Host "   □ JMeter results show response times"
Write-Host "   □ Performance metrics are within acceptable ranges"
Write-Host "   □ HTML reports contain charts and graphs"

Write-Host "`nMark each checkbox mentally as you verify the results with your audience." -ForegroundColor Yellow

Write-Host "`nPress Enter to continue to Step 7..." -ForegroundColor Cyan
Read-Host | Out-Null

# Step 7: Conclusion and Key Takeaways
Show-Header "STEP 7: CONCLUSION & KEY TAKEAWAYS"

Write-Host "🏆 Congratulations! You've successfully demonstrated a complete CI/CD pipeline" -ForegroundColor Green
Write-Host "integrating GitHub, Jenkins, Docker, JMeter, and Jira." -ForegroundColor Green

Write-Host "`n📝 Key Takeaways to Emphasize:" -ForegroundColor Yellow

Write-Host "`n1️⃣ Automation Benefits:" -ForegroundColor Cyan
Write-Host "   ├─ Fully automated workflow from code to deployment"
Write-Host "   ├─ No manual intervention required"
Write-Host "   ├─ Consistent and repeatable process"
Write-Host "   └─ Reduced human error"

Write-Host "`n2️⃣ Integration Benefits:" -ForegroundColor Cyan
Write-Host "   ├─ All tools working together seamlessly"
Write-Host "   ├─ Full traceability from requirement to deployment"
Write-Host "   ├─ Visibility across the entire pipeline"
Write-Host "   └─ Centralized monitoring and reporting"

Write-Host "`n3️⃣ Quality Benefits:" -ForegroundColor Cyan
Write-Host "   ├─ Automated testing ensures quality"
Write-Host "   ├─ Performance metrics tracked over time"
Write-Host "   ├─ Early detection of issues"
Write-Host "   └─ Faster feedback cycles"

Write-Host "`n4️⃣ Business Benefits:" -ForegroundColor Cyan
Write-Host "   ├─ Faster time to market"
Write-Host "   ├─ Reduced development costs"
Write-Host "   ├─ Improved collaboration between teams"
Write-Host "   └─ Higher customer satisfaction"

Write-Host "`n🏁 DEMO COMPLETED SUCCESSFULLY! 🎉" -ForegroundColor Green

Write-Host "`nThis interactive demo has showcased the entire DevOps pipeline"
Write-Host "featuring GitHub, Jenkins, Docker, JMeter, and Jira integration."
Write-Host "You can run this demo script again whenever you need to demonstrate the pipeline."

# Show contact information
Write-Host "`n📞 Questions about this demo? Contact:" -ForegroundColor Yellow
Write-Host "   ├─ GitHub: github.com/MohammedSalghi"
Write-Host "   └─ Project: SC-Group-2-DevOps-Project-1"
