# Check if running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "This script requires Administrator privileges. Please run as Administrator."
    exit
}

# Set the destination directory and file
$rdpWrapperDir = "C:\Program Files\RDP Wrapper"
$rdpWrapIniFile = Join-Path -Path $rdpWrapperDir -ChildPath "rdpwrap.ini"

# Ensure the destination directory exists
if (-not (Test-Path -Path $rdpWrapperDir)) {
    try {
        New-Item -Path $rdpWrapperDir -ItemType Directory -Force | Out-Null
        Write-Host "Created directory: $rdpWrapperDir" -ForegroundColor Green
    } catch {
        Write-Error "Failed to create directory: $rdpWrapperDir. Error: $_"
        exit
    }
}

# Backup existing rdpwrap.ini if it exists
if (Test-Path -Path $rdpWrapIniFile) {
    $backupFile = "$rdpWrapIniFile.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    try {
        Copy-Item -Path $rdpWrapIniFile -Destination $backupFile -Force
        Write-Host "Backed up existing rdpwrap.ini to $backupFile" -ForegroundColor Green
    } catch {
        Write-Warning "Failed to backup existing rdpwrap.ini: $_"
    }
}

# Stop Terminal Services
try {
    Write-Host "Stopping Terminal Services..." -ForegroundColor Yellow
    Stop-Service termservice -Force
    Write-Host "Terminal Services stopped successfully." -ForegroundColor Green
} catch {
    Write-Error "Failed to stop Terminal Services: $_"
    exit
}

# Download updated rdpwrap.ini file
try {
    Write-Host "Downloading rdpwrap.ini from GitHub..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/sebaxakerhtc/rdpwrap.ini/master/rdpwrap.ini" -OutFile $rdpWrapIniFile -UseBasicParsing
    Write-Host "rdpwrap.ini downloaded successfully." -ForegroundColor Green
} catch {
    Write-Error "Failed to download rdpwrap.ini: $_"
    # Try to restart Terminal Services even if download failed
    Start-Service termservice
    exit
}

# Start Terminal Services
try {
    Write-Host "Starting Terminal Services..." -ForegroundColor Yellow
    Start-Service termservice
    Write-Host "Terminal Services started successfully." -ForegroundColor Green
} catch {
    Write-Error "Failed to start Terminal Services: $_"
    exit
}

Write-Host "RDP Wrapper configuration has been updated successfully." -ForegroundColor Green