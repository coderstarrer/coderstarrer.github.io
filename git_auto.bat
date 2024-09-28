@echo off
cd /d "C:/Users/BHANU/Downloads/coderstarrer.github.io-main"


REM Add all changes
git add . || exit /b

REM Commit changes with a message
git commit -m "Git Commit Change Automation with Git AUTO Bot" || exit /b

REM Push changes to remote
git push origin main || exit /b
