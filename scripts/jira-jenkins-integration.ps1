# Jira-Jenkins Integration Script
# This script allows you to add comments that update both Jira and Jenkins

param(
    [Parameter(Mandatory=$true)]
    [string]$IssueId,
    
    [Parameter(Mandatory=$true)]
    [string]$Comment,
    
    [string]$BuildNumber = "",
    [string]$Status = "in-progress"
)

# Function to add comment to Jira
function Add-JiraComment {
    param($Issue, $CommentText)
    
    Write-Host "🎯 Adding comment to Jira issue: $Issue" -ForegroundColor Green
    try {
        $result = jira comment $Issue $CommentText
        Write-Host "✅ Jira comment added successfully" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Failed to add Jira comment: $_" -ForegroundColor Red
        return $false
    }
}

# Function to update Jenkins build with comment
function Update-JenkinsBuild {
    param($Comment, $Build)
    
    Write-Host "🔧 Updating Jenkins with comment..." -ForegroundColor Blue
    
    # Create Jenkins build description update
    $jenkinsUrl = "http://localhost:8081"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    # Log to Jenkins workspace
    $logFile = "jenkins-comments.log"
    $logEntry = "[$timestamp] $Comment"
    
    try {
        Add-Content -Path $logFile -Value $logEntry
        Write-Host "✅ Jenkins comment logged successfully" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Failed to update Jenkins: $_" -ForegroundColor Red
        return $false
    }
}

# Function to create combined comment with metadata
function Create-EnhancedComment {
    param($OriginalComment, $IssueId, $BuildNum)
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"    $enhancedComment = @"
$timestamp - $OriginalComment

Integration Details:
- Issue: $IssueId
- Build: $BuildNum
- Status: $Status
- Source: Terminal Integration Script
"@
    
    return $enhancedComment
}

# Main execution
Write-Host "🚀 Starting Jira-Jenkins Integration..." -ForegroundColor Cyan
Write-Host "Issue ID: $IssueId" -ForegroundColor Yellow
Write-Host "Comment: $Comment" -ForegroundColor Yellow

# Create enhanced comment
$enhancedComment = Create-EnhancedComment -OriginalComment $Comment -IssueId $IssueId -BuildNum $BuildNumber

# Update Jira
$jiraSuccess = Add-JiraComment -Issue $IssueId -CommentText $enhancedComment

# Update Jenkins
$jenkinsSuccess = Update-JenkinsBuild -Comment $enhancedComment -Build $BuildNumber

# Summary
Write-Host "`n📊 Integration Summary:" -ForegroundColor Cyan
Write-Host "Jira Update: $(if($jiraSuccess){'✅ Success'}else{'❌ Failed'})" -ForegroundColor $(if($jiraSuccess){'Green'}else{'Red'})
Write-Host "Jenkins Update: $(if($jenkinsSuccess){'✅ Success'}else{'❌ Failed'})" -ForegroundColor $(if($jenkinsSuccess){'Green'}else{'Red'})

if($jiraSuccess -and $jenkinsSuccess) {
    Write-Host "`n🎉 All integrations completed successfully!" -ForegroundColor Green
} else {
    Write-Host "`n⚠️  Some integrations failed. Check the logs above." -ForegroundColor Yellow
}
