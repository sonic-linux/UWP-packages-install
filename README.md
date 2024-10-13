use powershell script to install UWP app whether as bulk or single package run them in the directory containing your UWP packages

1. Script "UWP-Current-user-install-prompts.ps1"

This script installs UWP packages for the current user using Add-AppxPackage. It prompts the user for confirmation before installing each package.

2. Script "UWP-Current-user-install.ps1"

This script installs UWP packages for the current user using Add-AppxPackage, but prompts the user only once to install all found packages.

3. Script "UWP-allusers-install-prompts.ps1"

This script installs UWP packages for all users using Add-AppxProvisionedPackage, prompting the user for each package.

4. Script "UWP-allusers-install.ps1"

This script installs UWP packages for all users using Add-AppxProvisionedPackage, but prompts the user only once to install all found packages.

