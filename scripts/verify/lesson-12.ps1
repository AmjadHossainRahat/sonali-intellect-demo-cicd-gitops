Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Run verification from the repository root.
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
# Confirm the production readiness checklist exists.
if (-not (Test-Path "docs\production-readiness.md")) { throw "Production readiness doc missing" }
# Confirm the local-vs-production comparison doc exists.
if (-not (Test-Path "docs\production-comparison.md")) { throw "Production comparison doc missing" }
Write-Host "[PASS] Lesson 12 production comparison docs exist"
