@echo off
setlocal

:: Change to the specified directory
set "directoryPath=C:\Users\BHANU\Downloads\coderstarrer.github.io-main"

:: Check if the directory exists
if not exist "%directoryPath%" (
    echo Error: The specified directory does not exist: %directoryPath%
    exit /b 1
)

cd /d "%directoryPath%"
echo Current directory set to: %directoryPath%


:: Add all changes to the staging area
git add .
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to add changes to the staging area.
    exit /b 1
)

:: Prompt for commit message
set /p commitMessage="Enter commit message (leave blank for default 'Update'): "
if "%commitMessage%"=="" (
    set "commitMessage=Update"
)

:: Attempt to commit changes
git commit -m "%commitMessage%"
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to commit changes.
    exit /b 1
)

:: Attempt to push changes to the remote repository
git push origin main
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to push changes to the remote repository.
    exit /b 1
)

:: Notify the user of successful completion
echo Changes have been successfully committed and pushed!
endlocal
