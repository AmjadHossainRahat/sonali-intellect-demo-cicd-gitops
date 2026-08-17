Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Load shared logging and prerequisite helper functions.
. "$PSScriptRoot\..\lib.ps1"

# Confirm kubectl is available before modifying the deployment.
Require-Tool "kubectl"

# Scale the live deployment away from the Git desired state to create drift.
Invoke-CheckedCommand "Argo CD drift injection failed" { kubectl -n si-demo-local scale deployment sonali-intellect-demo --replicas=1 }
Write-Pass "Manual drift created. Argo CD should mark OutOfSync and self-heal if enabled."
