# Change to the specified directory
Set-Location "C:\Users\BHANU\Downloads\coderstarrer.github.io-main"

# Add all changes to the staging area
git add .

# Prompt for commit message and store it directly
$commitMessage = Read-Host "Enter commit message (default: 'Update')"

# Use a default commit message if none provided
if (-not $commitMessage) { $commitMessage = "Update" }

# Commit changes with the user-provided or default message
git commit -m $commitMessage

# Push changes to the remote repository
git push origin main

# Notify the user of completion
Write-Host "Changes have been committed and pushed successfully!"
