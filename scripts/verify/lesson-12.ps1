Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
if (-not (Test-Path "docs\production-readiness.md")) { throw "Production readiness doc missing" }
if (-not (Test-Path "docs\production-comparison.md")) { throw "Production comparison doc missing" }
Write-Host "[PASS] Lesson 12 production comparison docs exist"

