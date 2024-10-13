# Check for administrative rights
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Try to relaunch the script as admin
    $arguments = "& '" + $myInvocation.MyCommand.Definition + "'"
    Start-Process powershell.exe -ArgumentList $arguments -Verb RunAs
    Exit
}

# Get the folder where the script is located
$folderPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Gather all app packages
$extensions = @(".msix", ".appx", ".msixbundle", ".appxbundle")
$packages = @()

foreach ($extension in $extensions) {
    $packages += Get-ChildItem -Path $folderPath -Filter *$extension
}

# Prompt user for bulk installation
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

# Keep the script open after completion
Read-Host "Press Enter to exit..."