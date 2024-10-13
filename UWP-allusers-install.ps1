# Check if the script is running with admin rights
function Test-Admin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# If not running as admin, try to restart as admin
if (-not (Test-Admin)) {
    try {
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        exit
    } catch {
        Write-Error "Failed to run as administrator. Please run this script with elevated privileges."
        exit
    }
}

# Get the directory of the script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Find all MSIX, APPX, MSIXBUNDLE, and APPXBUNDLE files
$packages = Get-ChildItem -Path $scriptDir -Include *.msix, *.appx, *.msixbundle, *.appxbundle -Recurse

# Check if any packages were found
if ($packages.Count -eq 0) {
    Write-Host "No package files found in the directory." -ForegroundColor Yellow
    exit
}

# Prompt user for confirmation before installation
$confirmation = Read-Host "Found $($packages.Count) package(s). Do you want to install them? (Y/N)"
if ($confirmation -ne 'Y' -and $confirmation -ne 'y') {
    Write-Host "Installation canceled by the user." -ForegroundColor Yellow
    exit
}

# Install each package
foreach ($package in $packages) {
    try {
        Add-AppxProvisionedPackage -PackagePath $package.FullName -Online -SkipLicense
        Write-Host "Successfully installed: $($package.Name)" -ForegroundColor Green
    } catch {
        Write-Host "Failed to install: $($package.Name). Error: $_" -ForegroundColor Red
    }
}

# Keep the script open after completion
Read-Host "Press Enter to exit..."