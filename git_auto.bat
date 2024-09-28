@echo off
cd /d "C:/Users/BHANU/Downloads/coderstarrer.github.io-main"

REM Check GIT Status
git status

REM Check for untracked files
echo Checking for untracked files...
git ls-files --others --exclude-standard

REM Pull latest changes
git pull origin main || exit /b

REM Add all changes
git add . || exit /b

REM Commit changes with a message
git commit -m "Git Commit Change Automation with Git AUTO Bot" || (
    echo No changes to commit.
    exit /b
)

REM Push changes to remote
git push origin main || exit /b

REM Show the latest log of commits
echo Showing the latest commits...
git log --oneline -5

REM Optionally, create a new branch (uncomment the next two lines if needed)
REM echo Enter the new branch name:
REM set /p branchName="Branch Name: "
REM git checkout -b "%branchName%" || exit /b

echo Git automation script completed successfully!
pause
