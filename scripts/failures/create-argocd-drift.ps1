Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\..\lib.ps1"

Require-Tool "kubectl"

kubectl -n si-demo-local scale deployment sonali-intellect-demo --replicas=1
Write-Pass "Manual drift created. Argo CD should mark OutOfSync and self-heal if enabled."

