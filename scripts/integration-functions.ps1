# Quick Comment Function
# Usage: comment "PROJECT-123" "Your comment here"

function global:comment {
    param(
        [Parameter(Mandatory=$true)]
        [string]$IssueId,
        
        [Parameter(Mandatory=$true)]
        [string]$CommentText,
        
        [string]$BuildNumber = (Get-Date -Format "yyyyMMdd-HHmmss")
    )
    
    # Call the main integration script
    & "$PSScriptRoot\jira-jenkins-integration.ps1" -IssueId $IssueId -Comment $CommentText -BuildNumber $BuildNumber
}

# Quick status update function
function global:update-status {
    param(
        [Parameter(Mandatory=$true)]
        [string]$IssueId,
        
        [Parameter(Mandatory=$true)]
        [ValidateSet("start", "stop", "done", "review")]
        [string]$Action,
        
        [string]$Comment = ""
    )
    
    Write-Host "🔄 Updating issue status: $IssueId -> $Action" -ForegroundColor Cyan
    
    # Execute Jira status change
    switch ($Action) {
        "start" { 
            jira start $IssueId 
            if ($Comment) { comment $IssueId "Started working: $Comment" }
        }
        "stop" { 
            jira stop $IssueId 
            if ($Comment) { comment $IssueId "Stopped working: $Comment" }
        }
        "done" { 
            jira done $IssueId 
            if ($Comment) { comment $IssueId "Completed: $Comment" }
        }
        "review" { 
            jira review $IssueId 
            if ($Comment) { comment $IssueId "Ready for review: $Comment" }
        }
    }
    
    Write-Host "✅ Status updated successfully!" -ForegroundColor Green
}

# Function to log work time
function global:log-work {
    param(
        [Parameter(Mandatory=$true)]
        [string]$IssueId,
        
        [Parameter(Mandatory=$true)]
        [string]$TimeSpent,
        
        [string]$WorkDescription = "Development work"
    )
    
    Write-Host "⏱️  Logging work time: $TimeSpent for $IssueId" -ForegroundColor Blue
    
    # Log to Jira
    jira worklogadd $IssueId $TimeSpent $WorkDescription
    
    # Add comment with work details
    comment $IssueId "Logged $TimeSpent of work: $WorkDescription"
    
    Write-Host "✅ Work logged successfully!" -ForegroundColor Green
}

Write-Host "🔧 Jira-Jenkins integration functions loaded!" -ForegroundColor Green
Write-Host "Available commands:" -ForegroundColor Cyan
Write-Host "  comment 'ISSUE-123' 'Your comment'" -ForegroundColor Yellow
Write-Host "  update-status 'ISSUE-123' 'start' 'Optional comment'" -ForegroundColor Yellow
Write-Host "  log-work 'ISSUE-123' '2h' 'Work description'" -ForegroundColor Yellow
