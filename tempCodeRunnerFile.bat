@echo off
cd /d "C:/Users/BHANU/Downloads/coderstarrer.github.io-main" || exit /b

git pull origin main || exit /b

git add . || exit /b

git commit -m "Git Commit Change Automation with Git AUTO Bot" || exit /b

git push origin main || exit /b
