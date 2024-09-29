# Change to the specified directory
$directoryPath = "C:\Users\BHANU\Downloads\coderstarrer.github.io-main"

# Check if the directory exists
if (-Not (Test-Path $directoryPath)) {
    Write-Host "Error: The specified directory does not exist: $directoryPath" -ForegroundColor Red
    exit 1
}

Set-Location $directoryPath
Write-Host "Current directory set to: $directoryPath" -ForegroundColor Green

# Prompt for the file or folder to delete
$itemToDelete = Read-Host "Enter the name of the file or folder to delete (leave blank to skip)"
Write-Host "User entered for deletion: '$itemToDelete'"

# Check if the user provided a filename or folder for deletion
if (-Not [string]::IsNullOrEmpty($itemToDelete)) {
    # Use the full path for deletion
    $fullPathToDelete = Join-Path -Path $directoryPath -ChildPath $itemToDelete
    Write-Host "Full path to delete: '$fullPathToDelete'"

    if (Test-Path $fullPathToDelete) {
        Remove-Item $fullPathToDelete -Recurse -Force
        Write-Host "Deleted: $fullPathToDelete" -ForegroundColor Green
    } else {
        Write-Host "Error: Item '$fullPathToDelete' does not exist." -ForegroundColor Red
    }
}

# Prompt for the new file name or folder to create
$newItemName = Read-Host "Enter the name of the new file or folder to create (with extension or '/' for folders, leave blank to skip)"
Write-Host "User entered for creation: '$newItemName'"

# Check if the user provided a filename or folder for creation
if (-Not [string]::IsNullOrEmpty($newItemName)) {
    $fullPathToCreate = Join-Path -Path $directoryPath -ChildPath $newItemName
    Write-Host "Full path to create: '$fullPathToCreate'"

    if ($newItemName.EndsWith("/")) {
        # Create a new folder
        New-Item -ItemType Directory -Path $fullPathToCreate -Force
        Write-Host "Successfully created the folder: $fullPathToCreate" -ForegroundColor Green
    } else {
        # Check if the file already exists
        if (-Not (Test-Path $fullPathToCreate)) {
            # Open a loop to allow the user to enter multiple lines of content
            Write-Host "Creating the file: $fullPathToCreate"
            Write-Host "Enter content for the file (type 'END' on a new line to finish):"
            
            $fileContent = @()
            while ($true) {
                $lineContent = Read-Host "> "
                
                # Check for the termination condition
                if ($lineContent -eq "END") {
                    break
                }

                # Append the line to the file content
                $fileContent += $lineContent
            }

            # Save the file content to the specified file
            $fileContent | Out-File -FilePath $fullPathToCreate -Encoding UTF8
            Write-Host "Successfully created and saved the file: $fullPathToCreate" -ForegroundColor Green

            # Simple editing simulation
            $edit = $true
            while ($edit) {
                Write-Host "Contents of the file:"
                $currentContent = Get-Content $fullPathToCreate
                $currentContent | ForEach-Object { Write-Host "$($_)" }
                
                $userCommand = Read-Host "Enter 'edit' to modify a line, 'exit' to finish editing"
                
                if ($userCommand -eq "edit") {
                    # Show available lines for editing
                    $lineNumbers = 1..$currentContent.Count
                    Write-Host "Available lines to edit: $($lineNumbers -join ', ')"
                    $lineToEdit = Read-Host "Enter the line number to edit (1 to $($currentContent.Count))"

                    # Validate line number input
                    if ($lineToEdit -as [int] -and $lineToEdit -gt 0 -and $lineToEdit -le $currentContent.Count) {
                        $newLineContent = Read-Host "Enter new content for line $lineToEdit"
                        $currentContent[$lineToEdit - 1] = $newLineContent  # Update the specific line
                        $currentContent | Set-Content -Path $fullPathToCreate
                    } else {
                        Write-Host "Invalid line number. Please enter a number between 1 and $($currentContent.Count)." -ForegroundColor Red
                    }
                } elseif ($userCommand -eq "exit") {
                    $edit = $false
                }
            }
        } else {
            Write-Host "Error: File '$fullPathToCreate' already exists." -ForegroundColor Red
        }
    }
}

# Add all changes to the staging area
git add .
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to add changes to the staging area." -ForegroundColor Red
    exit 1
}

# Prompt for commit message and provide a default option
$commitMessage = Read-Host "Commit message (leave blank for default 'Update')"
if ([string]::IsNullOrEmpty($commitMessage)) {
    $commitMessage = "Update"  # Use "Update" as the default commit message
}

# Attempt to commit changes
git commit -m $commitMessage
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to commit changes." -ForegroundColor Red
    exit 1
}

# Attempt to push changes to the remote repository
git push origin main
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to push changes to the remote repository." -ForegroundColor Red
    exit 1
}

# Notify the user of successful completion
Write-Host "Changes have been successfully committed and pushed!" -ForegroundColor Green
