Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
if (-not (Select-String -Path ".github\workflows\*.yml","docs\security-best-practices.md" -Pattern "trivy" -Quiet -CaseSensitive:$false)) { throw "Trivy reference missing" }
if (-not (Select-String -Path ".github\workflows\*.yml","docs\security-best-practices.md" -Pattern "SBOM" -Quiet)) { throw "SBOM reference missing" }
Write-Host "[PASS] Lesson 05 supply-chain checks documented"

