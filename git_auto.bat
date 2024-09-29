@echo off
cd /d "C:/Users/BHANU/Downloads/coderstarrer.github.io-main"

REM Add all changes
git add .

REM Prompt for commit message
set /p commitMessage="Commit message: "



REM Commit changes with the user-provided message
git commit -m "%commitMessage%"

REM Push changes to remote
git push origin main

echo "Completed successfully!"
