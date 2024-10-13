# UWP-packages-install
install uwp using powershell scripts

use powershell to install UWP app whther as bulk or single package

1. Install for Current User with Prompts for Each Package
This script installs UWP packages for the current user using Add-AppxPackage. It prompts the user for confirmation before installing each package.

powershell

# Script to run as admin and install each package with user confirmation
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $myInvocation.MyCommand.Definition + "'"
    Start-Process powershell.exe -ArgumentList $arguments -Verb RunAs
    Exit
}

$folderPath = Split-Path -Parent $MyInvocation.MyCommand.Path

function Install-AppPackages {
    param ([string]$extension)

    Get-ChildItem -Path $folderPath -Filter *$extension | ForEach-Object {
        $response = Read-Host "Do you want to install package: $($_.Name)? (Y/N)"
        if ($response -eq 'Y' -or $response -eq 'y') {
            Write-Output "Installing package: $($_.Name)"
            Add-AppxPackage -Path $_.FullName
        } else {
            Write-Output "Skipping package: $($_.Name)"
        }
    }
}

$extensions = @(".msix", ".appx", ".msixbundle", ".appxbundle")
foreach ($extension in $extensions) {
    Install-AppPackages -extension $extension
}

Write-Output "All packages processed."
2. Install for Current User with Single Bulk Prompt
This script installs UWP packages for the current user using Add-AppxPackage, but prompts the user only once to install all found packages.

powershell

If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $myInvocation.MyCommand.Definition + "'"
    Start-Process powershell.exe -ArgumentList $arguments -Verb RunAs
    Exit
}

$folderPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$extensions = @(".msix", ".appx", ".msixbundle", ".appxbundle")
$packages = @()

foreach ($extension in $extensions) {
    $packages += Get-ChildItem -Path $folderPath -Filter *$extension
}

$response = Read-Host "Found $($packages.Count) packages. Do you want to install all of them? (Y/N)"
if ($response -eq 'Y' -or $response -eq 'y') {
    foreach ($package in $packages) {
        Write-Output "Installing package: $package"
        Add-AppxPackage -Path $package.FullName
    }
    Write-Output "All packages installed."
} else {
    Write-Output "Installation canceled."
}
3. Install for All Users with Prompts for Each Package
This script installs UWP packages for all users using Add-AppxProvisionedPackage, prompting the user for each package.

powershell

If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $myInvocation.MyCommand.Definition + "'"
    Start-Process powershell.exe -ArgumentList $arguments -Verb RunAs
    Exit
}

$folderPath = Split-Path -Parent $MyInvocation.MyCommand.Path

function Install-ProvisionedPackages {
    param ([string]$extension)

    Get-ChildItem -Path $folderPath -Filter *$extension | ForEach-Object {
        $response = Read-Host "Do you want to install package: $($_.Name)? (Y/N)"
        if ($response -eq 'Y' -or $response -eq 'y') {
            Write-Output "Installing package: $($_.Name)"
            Add-AppxProvisionedPackage -Online -PackagePath $_.FullName -SkipLicense
        } else {
            Write-Output "Skipping package: $($_.Name)"
        }
    }
}

$extensions = @(".msix", ".appx", ".msixbundle", ".appxbundle")
foreach ($extension in $extensions) {
    Install-ProvisionedPackages -extension $extension
}

Write-Output "All packages processed."
4. Install for All Users with Single Bulk Prompt
This script installs UWP packages for all users using Add-AppxProvisionedPackage, but prompts the user only once to install all found packages.

powershell

If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $myInvocation.MyCommand.Definition + "'"
    Start-Process powershell.exe -ArgumentList $arguments -Verb RunAs
    Exit
}

$folderPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$extensions = @(".msix", ".appx", ".msixbundle", ".appxbundle")
$packages = @()

foreach ($extension in $extensions) {
    $packages += Get-ChildItem -Path $folderPath -Filter *$extension
}

$response = Read-Host "Found $($packages.Count) packages. Do you want to install all of them for all users? (Y/N)"
if ($response -eq 'Y' -or $response -eq 'y') {
    foreach ($package in $packages) {
        Write-Output "Installing package: $package"
        Add-AppxProvisionedPackage -Online -PackagePath $package.FullName -SkipLicense
    }
    Write-Output "All packages installed for all users."
} else {
    Write-Output "Installation canceled."
}


the individual scripts may be changed for other reasons but the scripts still work the same way
