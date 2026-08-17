Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Run verification from the repository root.
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
# Confirm the workflow or docs mention Trivy scanning.
if (-not (Select-String -Path ".github\workflows\*.yml","docs\security-best-practices.md" -Pattern "trivy" -Quiet -CaseSensitive:$false)) { throw "Trivy reference missing" }
# Confirm the workflow or docs mention SBOM generation.
if (-not (Select-String -Path ".github\workflows\*.yml","docs\security-best-practices.md" -Pattern "SBOM" -Quiet)) { throw "SBOM reference missing" }
Write-Host "[PASS] Lesson 05 supply-chain checks documented"
