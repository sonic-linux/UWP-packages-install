# Check if the script is running with admin privileges
function Test-Admin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Restart the script with admin privileges if not already running as admin
if (-not (Test-Admin)) {
    try {
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        exit
    } catch {
        Write-Host "Failed to obtain administrative privileges. Exiting script." -ForegroundColor Red
        exit 1
    }
}

# Get the directory of the script
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path

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
        Add-AppxProvisionedPackage -PackagePath $package.FullName -Online
        Write-Host "Successfully installed: $($package.Name)" -ForegroundColor Green
    } catch {
        Write-Host "Failed to install: $($package.Name). Error: $_" -ForegroundColor Red
    }
}
