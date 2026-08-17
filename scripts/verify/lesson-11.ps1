Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Run verification from the repository root.
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
# List the failure scripts expected for the troubleshooting lesson.
$files = @(
    "scripts\failures\break-unit-test.ps1",
    "scripts\failures\break-image-pull.ps1",
    "scripts\failures\break-readiness-probe.ps1",
    "scripts\failures\create-argocd-drift.ps1"
)
foreach ($file in $files) {
    # Confirm each required failure script exists.
    if (-not (Test-Path $file)) { throw "$file missing" }
}
Write-Host "[PASS] Lesson 11 selected failure scripts exist"
