# Installer script for RDP Wrapper Updater

# Ensure running as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script needs to be run as Administrator. Attempting to elevate..." -ForegroundColor Yellow
    
    # Try to restart with elevation
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"& {Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/dewdad/rdpwrapper-update/main/install.ps1' | Invoke-Expression}`"" -Verb RunAs
    exit
}

# Create destination directory
$scriptDir = "C:\my\scripts"
if (-not (Test-Path -Path $scriptDir)) {
    New-Item -Path $scriptDir -ItemType Directory -Force | Out-Null
    Write-Host "Created directory: $scriptDir" -ForegroundColor Green
}

# Download the Update-RDPWrapper.ps1 script
$scriptPath = Join-Path -Path $scriptDir -ChildPath "Update-RDPWrapper.ps1"
Write-Host "Downloading Update-RDPWrapper.ps1 script..." -ForegroundColor Yellow
try {
    Invoke-RestMethod -Uri "https://raw.githubusercontent.com/dewdad/rdpwrapper-update/main/Update-RDPWrapper.ps1" -OutFile $scriptPath
    Write-Host "Script downloaded successfully to: $scriptPath" -ForegroundColor Green
} catch {
    Write-Error "Failed to download the script: $_"
    exit
}

# Optional: Create a shortcut
Write-Host "Creating desktop shortcut..." -ForegroundColor Yellow
$desktopPath = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path -Path $desktopPath -ChildPath "Update RDP Wrapper.lnk"

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$scriptPath`""
$Shortcut.Description = "Update RDP Wrapper Configuration"
$Shortcut.IconLocation = "powershell.exe,0"
$Shortcut.WorkingDirectory = $scriptDir
$Shortcut.Save()

Write-Host "Shortcut created at: $shortcutPath" -ForegroundColor Green

# Run the script immediately
Write-Host "Running the Update-RDPWrapper script now..." -ForegroundColor Yellow
try {
    & $scriptPath
} catch {
    Write-Error "Error running the script: $_"
    exit
}

Write-Host "`nInstallation complete! You can run the updater again by:" -ForegroundColor Green
Write-Host "1. Using the desktop shortcut" -ForegroundColor Cyan
Write-Host "2. Running the script directly: $scriptPath" -ForegroundColor Cyan
Write-Host "3. Using the one-liner: irm `"https://raw.githubusercontent.com/dewdad/rdpwrapper-update/main/install.ps1`" | iex" -ForegroundColor Cyan