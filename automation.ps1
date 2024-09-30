# Advanced PowerShell Script for File Management and Git Operations

# Function to handle errors gracefully
function Handle-Error {
    param ($message)
    Write-Host "Error: $message" -ForegroundColor Red
    exit 1
}

# Change to the specified directory
$directoryPath = "C:\Users\BHANU\Downloads\coderstarrer.github.io-main"

# Validate directory existence
if (-Not (Test-Path $directoryPath)) {
    Handle-Error "The specified directory does not exist: $directoryPath"
}

Set-Location $directoryPath
Write-Host "Current directory set to: $directoryPath" -ForegroundColor Green

# Prompt for the file or folder to delete
$itemToDelete = Read-Host "Enter the name of the file or folder to delete (leave blank to skip)"
if (-Not [string]::IsNullOrEmpty($itemToDelete)) {
    $fullPathToDelete = Join-Path -Path $directoryPath -ChildPath $itemToDelete
    if (Test-Path $fullPathToDelete) {
        Remove-Item $fullPathToDelete -Recurse -Force -ErrorAction Stop
        Write-Host "Deleted: $fullPathToDelete" -ForegroundColor Green
    } else {
        Handle-Error "Item '$fullPathToDelete' does not exist."
    }
}

# Prompt for the new file or folder creation
$newItemName = Read-Host "Enter the name of the new file or folder to create (with extension or '/' for folders, leave blank to skip)"
if (-Not [string]::IsNullOrEmpty($newItemName)) {
    $fullPathToCreate = Join-Path -Path $directoryPath -ChildPath $newItemName

    # Create folder or file based on user input
    if ($newItemName.EndsWith("/")) {
        New-Item -ItemType Directory -Path $fullPathToCreate -Force -ErrorAction Stop
        Write-Host "Successfully created the folder: $fullPathToCreate" -ForegroundColor Green
    } else {
        if (-Not (Test-Path $fullPathToCreate)) {
            # Backup file if it already exists
            if (Test-Path $fullPathToCreate) {
                Copy-Item -Path $fullPathToCreate -Destination "$fullPathToCreate.bak" -Force
                Write-Host "Backup created: $fullPathToCreate.bak" -ForegroundColor Yellow
            }

            # Editor choice for file creation
            $editorChoice = Read-Host "Do you want to use the terminal editor or Notepad? (Enter 'terminal' or 'notepad')"
            if ($editorChoice -eq "notepad") {
                New-Item -Path $fullPathToCreate -ItemType File -Force
                Start-Process notepad.exe $fullPathToCreate
                Write-Host "File opened in Notepad: $fullPathToCreate"
            } else {
                # Interactive terminal editor with improved UX
                Write-Host "Enter content for the file (type 'END' on a new line to finish):"
                $fileContent = @()
                while ($true) {
                    $lineContent = Read-Host "> "
                    if ($lineContent -eq "END") { break }
                    $fileContent += $lineContent
                }
                $fileContent | Out-File -FilePath $fullPathToCreate -Encoding UTF8
                Write-Host "Successfully created and saved the file: $fullPathToCreate" -ForegroundColor Green

                # File editing loop
                $edit = $true
                while ($edit) {
                    Write-Host "File content:"
                    $currentContent = @(Get-Content -Path $fullPathToCreate)
                    $currentContent | ForEach-Object { Write-Host "$($_)" }
                    $userCommand = Read-Host "Enter 'edit' to modify a line, 'add' to append, 'delete' to remove a line, 'exit' to finish editing"

                    switch ($userCommand) {
                        'edit' {
                            $lineToEdit = Read-Host "Enter the line number to edit (1 to $($currentContent.Count))"
                            if ($lineToEdit -as [int] -and $lineToEdit -gt 0 -and $lineToEdit -le $currentContent.Count) {
                                $newLineContent = Read-Host "Enter new content for line $lineToEdit"
                                $currentContent[$lineToEdit - 1] = $newLineContent
                                $currentContent | Set-Content -Path $fullPathToCreate
                                Write-Host "Line $lineToEdit updated." -ForegroundColor Green
                            } else {
                                Write-Host "Invalid line number." -ForegroundColor Red
                            }
                        }
                        'add' {
                            $newLineContent = Read-Host "Enter new content to add"
                            Add-Content -Path $fullPathToCreate -Value $newLineContent
                            Write-Host "Line added." -ForegroundColor Green
                        }
                        'delete' {
                            $lineToDelete = Read-Host "Enter the line number to delete (1 to $($currentContent.Count))"
                            if ($lineToDelete -as [int] -and $lineToDelete -gt 0 -and $lineToDelete -le $currentContent.Count) {
                                $currentContent = $currentContent | Where-Object { $_ -ne $currentContent[$lineToDelete - 1] }
                                $currentContent | Set-Content -Path $fullPathToCreate
                                Write-Host "Line $lineToDelete deleted." -ForegroundColor Green
                            } else {
                                Write-Host "Invalid line number." -ForegroundColor Red
                            }
                        }
                        'exit' {
                            $edit = $false
                        }
                        default {
                            Write-Host "Unknown command." -ForegroundColor Red
                        }
                    }
                }
            }
        } else {
            Handle-Error "File '$fullPathToCreate' already exists."
        }
    }
}

# Stage all changes in the repository
git add .
if ($LASTEXITCODE -ne 0) {
    Handle-Error "Failed to add changes to the staging area."
}

# Prompt for commit message with a default option
$commitMessage = Read-Host "Commit message (leave blank for default 'Update')"
if ([string]::IsNullOrEmpty($commitMessage)) {
    $commitMessage = "Update"
}

# Commit changes
git commit -m $commitMessage
if ($LASTEXITCODE -ne 0) {
    Handle-Error "Failed to commit changes."
}

# Push changes to the remote repository
git push origin main
if ($LASTEXITCODE -ne 0) {
    Handle-Error "Failed to push changes to the remote repository."
}

# Final success message
Write-Host "Changes successfully committed and pushed!" -ForegroundColor Green
