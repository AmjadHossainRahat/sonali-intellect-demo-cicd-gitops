Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Load shared logging and prerequisite helper functions.
. "$PSScriptRoot\..\lib.ps1"

# Resolve the repository root so the overlay path works from any location.
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
# Confirm kubectl is available before applying the overlay.
Require-Tool "kubectl"

# Reapply the local GitOps overlay to restore the desired replica count.
Invoke-CheckedCommand "Drift recovery apply failed" { kubectl apply -k "$repoRoot\kubernetes\overlays\local" }
# Wait until the deployment has successfully rolled out again.
Invoke-CheckedCommand "Drift recovery rollout failed" { kubectl -n si-demo-local rollout status deployment/sonali-intellect-demo --timeout=180s }
Write-Pass "Drift recovered from the GitOps overlay."
