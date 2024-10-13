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

# Install each package with user confirmation
foreach ($package in $packages) {
    $userResponse = Read-Host "Do you want to install $($package.Name)? (Y/N)"
    if ($userResponse -eq 'Y' -or $userResponse -eq 'y') {
        try {
            Add-AppxProvisionedPackage -PackagePath $package.FullName -Online -SkipLicense
            Write-Host "$($package.Name) installed successfully."
        } catch {
            Write-Error "Failed to install $($package.Name): $_"
        }
    } else {
        Write-Host "Skipping installation of $($package.Name)."
    }
}
