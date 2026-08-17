Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\lib.ps1"

Write-Info "Checking prerequisites"
# Run the prerequisite checker before creating cluster resources.
& "$PSScriptRoot\prerequisites.ps1"

Write-Info "Creating Kind cluster"
# Create or reuse the local three-node Kind cluster.
& "$PSScriptRoot\create-cluster.ps1"

Write-Info "Installing Argo CD"
# Install Argo CD into the local Kind cluster.
& "$PSScriptRoot\install-argocd.ps1"

Write-Info "Bootstrap complete. Create the Harbor pull secret before syncing the application."
