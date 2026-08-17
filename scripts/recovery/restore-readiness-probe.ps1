Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Load shared logging and prerequisite helper functions.
. "$PSScriptRoot\..\lib.ps1"

# Resolve the repository root so the overlay path works from any location.
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
# Confirm kubectl is available before applying the overlay.
Require-Tool "kubectl"

# Reapply the local GitOps overlay to restore the readiness probe path.
Invoke-CheckedCommand "Readiness probe recovery apply failed" { kubectl apply -k "$repoRoot\kubernetes\overlays\local" }
# Wait until the deployment has successfully rolled out again.
Invoke-CheckedCommand "Readiness probe recovery rollout failed" { kubectl -n si-demo-local rollout status deployment/sonali-intellect-demo --timeout=180s }
Write-Pass "Readiness probe demo recovered from the GitOps overlay."
