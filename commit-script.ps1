# Change to the specified directory
$directoryPath = "C:\Users\BHANU\Downloads\coderstarrer.github.io-main"

# Check if the directory exists
if (-Not (Test-Path $directoryPath)) {
    Write-Host "Error: The specified directory does not exist: $directoryPath" -ForegroundColor Red
    exit 1
}

Set-Location $directoryPath

# Add all changes to the staging area
git add .

# Prompt for commit message and provide a default option
$commitMessage = Read-Host "Enter commit message (default: 'Update')"

# Use a default commit message if none provided
if (-not $commitMessage) { 
    $commitMessage = "Update" 
}

# Attempt to commit changes
try {
    git commit -m $commitMessage
} catch {
    Write-Host "Error: Failed to commit changes. $_" -ForegroundColor Red
    exit 1
}

# Attempt to push changes to the remote repository
try {
    git push origin main
} catch {
    Write-Host "Error: Failed to push changes to the remote repository. $_" -ForegroundColor Red
    exit 1
}

# Notify the user of successful completion
Write-Host "Changes have been successfully committed and pushed!" -ForegroundColor Green
