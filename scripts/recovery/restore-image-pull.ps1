Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\..\lib.ps1"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
Require-Tool "kubectl"

kubectl apply -k "$repoRoot\kubernetes\overlays\local"
kubectl -n si-demo-local rollout status deployment/sonali-intellect-demo --timeout=180s
Write-Pass "Image pull demo recovered from the GitOps overlay."

