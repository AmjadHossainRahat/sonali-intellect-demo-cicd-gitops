Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Run verification from the repository root.
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
# Confirm the Harbor release workflow exists.
if (-not (Test-Path ".github\workflows\02-release-image.yml")) { throw "Release image workflow missing" }
# Confirm the workflow reads Harbor credentials from configured secrets or variables.
if (-not (Select-String -LiteralPath ".github\workflows\02-release-image.yml" -Pattern "HARBOR_REGISTRY" -Quiet)) { throw "Harbor registry reference missing" }
Write-Host "[PASS] Lesson 04 Harbor workflow references external credentials"
