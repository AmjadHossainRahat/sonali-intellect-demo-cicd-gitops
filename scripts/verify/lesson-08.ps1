Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
kubectl kustomize kubernetes/overlays/local *> $null
Write-Host "[PASS] Lesson 08 local overlay renders"

