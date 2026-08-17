Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Load shared logging and native-command helpers.
. "$PSScriptRoot\..\lib.ps1"
# Run verification from the repository root.
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
# Render the shared Kubernetes base with Kustomize.
Invoke-CheckedCommand "Lesson 06 Kubernetes base render failed" { kubectl kustomize kubernetes/base *> $null }
Write-Host "[PASS] Lesson 06 Kubernetes base manifests render"
