Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\lib.ps1"

Write-Info "Checking prerequisites"
& "$PSScriptRoot\prerequisites.ps1"

Write-Info "Creating Kind cluster"
& "$PSScriptRoot\create-cluster.ps1"

Write-Info "Installing Argo CD"
& "$PSScriptRoot\install-argocd.ps1"

Write-Info "Bootstrap complete. Create the Harbor pull secret before syncing the application."

