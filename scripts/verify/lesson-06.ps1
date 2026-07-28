Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
kubectl kustomize kubernetes/base *> $null
Write-Host "[PASS] Lesson 06 Kubernetes base manifests render"

