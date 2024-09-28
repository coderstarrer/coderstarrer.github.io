@echo off
cd /d "C:/Users/BHANU/Downloads/coderstarrer.github.io-main" || exit /b

echo Checking for updates...
git pull origin main || (
    echo Failed to pull updates. Exiting...
    exit /b
)

echo Adding changes to staging...
git add . || (
    echo Failed to add changes. Exiting...
    exit /b
)

echo Committing changes...
git commit -m "Git Commit Change Automation with Git AUTO Bot" || (
    echo No changes to commit. Exiting...
    exit /b
)

echo Pushing changes to remote...
git push origin main || (
    echo Failed to push changes. Exiting...
    exit /b
)

echo Git automation script completed successfully!

echo Here are the latest commits:
git log --oneline -5

echo.
echo Press any key to exit...
pause >nul
