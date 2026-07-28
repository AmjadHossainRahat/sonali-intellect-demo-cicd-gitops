Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
if (-not (Select-String -LiteralPath "kubernetes\overlays\local\kustomization.yaml" -Pattern "digest:" -Quiet)) { throw "Local overlay digest missing" }
if (-not (Test-Path ".github\workflows\03-promote-local.yml")) { throw "Promotion workflow missing" }
Write-Host "[PASS] Lesson 10 GitOps promotion assets verified"

