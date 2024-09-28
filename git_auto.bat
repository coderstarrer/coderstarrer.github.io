@echo off
cd /d "C:/Users/BHANU/Downloads/coderstarrer.github.io-main"



REM Pull latest changes
git pull origin main

REM Add all changes
git add .

REM Commit changes with a message
git commit -m "Commited with Git Automation Bot!"

REM Push changes to remote
git push origin main

