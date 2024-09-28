@echo off
cd /d "C:/Users/BHANU/Downloads/coderstarrer.github.io-main"

REM Pull latest changes
git pull origin main

REM Add all changes
git add .

REM Prompt for commit message
set /p commitMessage="What did you commit? "

REM Commit changes with the user-provided message
git commit -m "%commitMessage%"

REM Push changes to remote
git push origin main
