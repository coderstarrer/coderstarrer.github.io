@echo off
setlocal EnableDelayedExpansion

REM Change to the specified directory
set "directoryPath=C:\Users\BHANU\Downloads\coderstarrer.github.io-main"

cd /d "%directoryPath%" || (
    echo Error: Failed to change directory to %directoryPath%.
    exit /b 1
)

REM Prompt for the file to delete
set /p fileToDelete="Enter the name of the file to delete (leave blank to skip): "

REM Check if the user provided a filename for deletion
if not "!fileToDelete!"=="" (
    if exist "!fileToDelete!" (
        del "!fileToDelete!"
        echo Deleted file: !fileToDelete!
    ) else (
        echo Error: File "!fileToDelete!" does not exist.
    )
)

REM Prompt for the new file name to create
set /p newFileName="Enter the name of the new file to create (leave blank to skip): "

REM Check if the user provided a filename for creation
if not "!newFileName!"=="" (
    echo. > "!newFileName!"
    echo Created new file: !newFileName!
)

REM Add all changes to the staging area
git add .
if errorlevel 1 (
    echo Error: Failed to add changes to the staging area.
    exit /b 1
)

REM Prompt for commit message and provide a default option
set /p commitMessage="Commit message (default: 'Update'): "
if "!commitMessage!"=="" (
    set "commitMessage=Update"
)

REM Attempt to commit changes
git commit -m "!commitMessage!"
if errorlevel 1 (
    echo Error: Failed to commit changes.
    exit /b 1
)

REM Attempt to push changes to the remote repository
git push origin main
if errorlevel 1 (
    echo Error: Failed to push changes to the remote repository.
    exit /b 1
)

REM Notify the user of successful completion
echo Changes have been successfully committed and pushed!

endlocal
