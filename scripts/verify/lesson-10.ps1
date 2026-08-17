Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Run verification from the repository root.
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
# Confirm the local overlay pins an image digest.
if (-not (Select-String -LiteralPath "kubernetes\overlays\local\kustomization.yaml" -Pattern "digest:" -Quiet)) { throw "Local overlay digest missing" }
# Confirm the promotion workflow exists.
if (-not (Test-Path ".github\workflows\03-promote-local.yml")) { throw "Promotion workflow missing" }
Write-Host "[PASS] Lesson 10 GitOps promotion assets verified"
