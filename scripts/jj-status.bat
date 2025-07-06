@echo off
REM Quick status update for Jira issues
REM Usage: jj-status.bat "ISSUE-123" "start|stop|done|review" "Optional comment"

if "%~1"=="" (
    echo Usage: jj-status "ISSUE-ID" "ACTION" "Optional comment"
    echo Actions: start, stop, done, review
    echo Example: jj-status "PROJECT-123" "start" "Beginning work on this feature"
    exit /b 1
)

if "%~2"=="" (
    echo Please provide an action: start, stop, done, or review
    exit /b 1
)

set ISSUE_ID=%~1
set ACTION=%~2
set COMMENT_TEXT=%~3
set BUILD_NUMBER=%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%%time:~6,2%

echo 🔄 Updating issue %ISSUE_ID% status to %ACTION%...
echo.

REM Execute Jira status change
if /i "%ACTION%"=="start" (
    echo 🚀 Starting work on issue...
    jira start %ISSUE_ID%
    if not "%COMMENT_TEXT%"=="" (
        jira comment %ISSUE_ID% "Started working: %COMMENT_TEXT%"
    )
)

if /i "%ACTION%"=="stop" (
    echo ⏸️ Stopping work on issue...
    jira stop %ISSUE_ID%
    if not "%COMMENT_TEXT%"=="" (
        jira comment %ISSUE_ID% "Stopped working: %COMMENT_TEXT%"
    )
)

if /i "%ACTION%"=="done" (
    echo ✅ Marking issue as done...
    jira done %ISSUE_ID%
    if not "%COMMENT_TEXT%"=="" (
        jira comment %ISSUE_ID% "Completed: %COMMENT_TEXT%"
    )
)

if /i "%ACTION%"=="review" (
    echo 👀 Marking issue for review...
    jira review %ISSUE_ID%
    if not "%COMMENT_TEXT%"=="" (
        jira comment %ISSUE_ID% "Ready for review: %COMMENT_TEXT%"
    )
)

REM Log to Jenkins
echo [%date% %time%] Issue: %ISSUE_ID% - Status changed to %ACTION% - %COMMENT_TEXT% >> jenkins-comments.log

echo.
echo 🎉 Status update completed!
echo 📋 Issue: %ISSUE_ID%
echo 🔄 Action: %ACTION%
if not "%COMMENT_TEXT%"=="" (
    echo 💬 Comment: %COMMENT_TEXT%
)
