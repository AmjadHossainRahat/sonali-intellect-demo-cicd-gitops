Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
if (-not (Test-Path ".github\workflows\02-release-image.yml")) { throw "Release image workflow missing" }
if (-not (Select-String -LiteralPath ".github\workflows\02-release-image.yml" -Pattern "HARBOR_REGISTRY" -Quiet)) { throw "Harbor registry reference missing" }
Write-Host "[PASS] Lesson 04 Harbor workflow references external credentials"

