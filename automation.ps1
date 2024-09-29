# Change to the specified directory
$directoryPath = "C:\Users\BHANU\Downloads\coderstarrer.github.io-main"

# Check if the directory exists
if (-Not (Test-Path $directoryPath)) {
    Write-Host "Error: The specified directory does not exist: $directoryPath" -ForegroundColor Red
    exit 1
}

Set-Location $directoryPath

# Prompt for the file to delete
$fileToDelete = Read-Host "Enter the name of the file to delete (leave blank to skip)"

# Check if the user provided a filename for deletion
if (-Not [string]::IsNullOrEmpty($fileToDelete)) {
    if (Test-Path $fileToDelete) {
        Remove-Item $fileToDelete -Force
        Write-Host "Deleted file: $fileToDelete" -ForegroundColor Green
    } else {
        Write-Host "Error: File '$fileToDelete' does not exist." -ForegroundColor Red
    }
}

# Prompt for the new file name to create
$newFileName = Read-Host "Enter the name of the new file to create (with extension, leave blank to skip)"

# Check if the user provided a filename for creation
if (-Not [string]::IsNullOrEmpty($newFileName)) {
    Write-Host "Successfully created the file: $newFileName"

    # Open a loop to allow the user to enter multiple lines of content
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
    $fileContent | Out-File -FilePath $newFileName -Encoding UTF8
    Write-Host "Successfully created and saved the file: $newFileName" -ForegroundColor Green
}

# Add all changes to the staging area
git add .
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to add changes to the staging area." -ForegroundColor Red
    exit 1
}

# Prompt for commit message and provide a default option
$commitMessage = Read-Host "Commit message (default: 'Update')"
if (-Not [string]::IsNullOrEmpty($commitMessage)) {
    $commitMessage = "Update"
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
