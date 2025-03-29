# RDP Wrapper Updater

This repository contains a PowerShell script that automatically updates the RDP Wrapper configuration file (rdpwrap.ini) with the latest version from [sebaxakerhtc/rdpwrap.ini](https://github.com/sebaxakerhtc/rdpwrap.ini).

## What is RDP Wrapper?

RDP Wrapper is a tool that allows multiple concurrent Remote Desktop Protocol (RDP) sessions on Windows editions that don't normally support this feature. This script helps you keep the RDP Wrapper configuration up-to-date with the latest Windows updates.

## One-Line Installation

Run the following command in PowerShell to download and run the script:

```powershell
irm "https://raw.githubusercontent.com/dewdad/rdpwrapper-update/main/install.ps1" | iex
```

This one-liner:
1. Downloads the installer script
2. Creates a directory for the script (C:\my\scripts)
3. Downloads the Update-RDPWrapper.ps1 script
4. Creates a desktop shortcut
5. Runs the update script immediately
6. Will request administrator privileges if needed

## Manual Installation

1. Download the script: [Update-RDPWrapper.ps1](https://raw.githubusercontent.com/dewdad/rdpwrapper-update/main/Update-RDPWrapper.ps1)
2. Run the script with administrator privileges

## Running the Script

The script requires administrator privileges to run. Here are several ways to run it:

### If you have the script saved locally:

```powershell
# Option 1: Run from PowerShell with Admin privileges
C:\path\to\Update-RDPWrapper.ps1

# Option 2: Run from any terminal and prompt for admin privileges
powershell -ExecutionPolicy Bypass -File C:\path\to\Update-RDPWrapper.ps1

# Option 3: Run from anywhere and prompt for admin privileges
Start-Process PowerShell -ArgumentList "-ExecutionPolicy Bypass -File C:\path\to\Update-RDPWrapper.ps1" -Verb RunAs
```

## What the Script Does

1. Checks for administrator privileges
2. Creates the RDP Wrapper directory if it doesn't exist
3. Backs up any existing rdpwrap.ini file
4. Stops the Terminal Services service
5. Downloads the latest rdpwrap.ini file
6. Restarts the Terminal Services service

## Warning

This script will temporarily stop and restart the Terminal Services service, which will disconnect any active Remote Desktop sessions. Make sure to save your work before running this script.

## Troubleshooting

If you encounter any issues:
1. Check that you're running with administrator privileges
2. Ensure your system is connected to the internet
3. Verify that the RDP Wrapper is properly installed

## Requirements

- Windows 7/8/10/11 with RDP Wrapper installed
- PowerShell 3.0 or later
- Internet connection
- Administrator privileges