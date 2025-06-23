@echo off
REM Jira-Jenkins Comment Integration
REM Usage: jj-comment.bat "ISSUE-123" "Your comment here"

if "%~1"=="" (
    echo Usage: jj-comment "ISSUE-ID" "Comment text"
    echo Example: jj-comment "PROJECT-123" "Fixed the login bug"
    exit /b 1
)

if "%~2"=="" (
    echo Please provide a comment text
    echo Usage: jj-comment "ISSUE-ID" "Comment text"
    exit /b 1
)

set ISSUE_ID=%~1
set COMMENT_TEXT=%~2
set BUILD_NUMBER=%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%%time:~6,2%

echo 🚀 Updating Jira issue %ISSUE_ID% and Jenkins...
echo.

REM Add comment to Jira
echo 🎯 Adding comment to Jira...
jira comment %ISSUE_ID% "[%BUILD_NUMBER%] %COMMENT_TEXT%"

if %errorlevel% equ 0 (
    echo ✅ Jira comment added successfully
) else (
    echo ❌ Failed to add Jira comment
)

REM Log to Jenkins workspace
echo 🔧 Logging to Jenkins workspace...
echo [%date% %time%] Issue: %ISSUE_ID% - %COMMENT_TEXT% >> jenkins-comments.log

if %errorlevel% equ 0 (
    echo ✅ Jenkins log updated successfully
) else (
    echo ❌ Failed to update Jenkins log
)

echo.
echo 🎉 Integration completed!
echo 📋 Issue: %ISSUE_ID%
echo 💬 Comment: %COMMENT_TEXT%
echo 🔧 Build: %BUILD_NUMBER%
