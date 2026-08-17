Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Load shared logging and native-command helpers.
. "$PSScriptRoot\..\lib.ps1"
# Run verification from the repository root.
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
# Render the local Kubernetes overlay with Kustomize.
Invoke-CheckedCommand "Lesson 08 local overlay render failed" { kubectl kustomize kubernetes/overlays/local *> $null }
Write-Host "[PASS] Lesson 08 local overlay renders"
