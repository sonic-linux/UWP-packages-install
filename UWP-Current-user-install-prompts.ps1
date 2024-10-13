# Check for administrative rights
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Try to relaunch the script as admin
    $arguments = "& '" + $myInvocation.MyCommand.Definition + "'"
    Start-Process powershell.exe -ArgumentList $arguments -Verb RunAs
    Exit
}

# Get the folder where the script is located
$folderPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Function to install app packages with user confirmation
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

# Install all package types with prompt
$extensions = @(".msix", ".appx", ".msixbundle", ".appxbundle")
foreach ($extension in $extensions) {
    Install-AppPackages -extension $extension
}

Write-Output "All packages processed."
