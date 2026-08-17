Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Load shared logging and native-command helpers.
. "$PSScriptRoot\..\lib.ps1"
# Put the repo-managed Java 21 first on PATH when available.
. "$PSScriptRoot\..\use-java21.ps1"
# Run verification from the repository root.
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
# Confirm the PR validation workflow exists.
if (-not (Test-Path ".github\workflows\01-pr-validation.yml")) { throw "PR validation workflow missing" }
# Run the same Maven test path used by PR validation.
Invoke-CheckedCommand "Lesson 03 Maven tests failed" { mvn -B clean test }
# Render the local Kubernetes overlay to catch manifest errors.
Invoke-CheckedCommand "Lesson 03 local overlay render failed" { kubectl kustomize kubernetes/overlays/local *> $null }
Write-Host "[PASS] Lesson 03 PR validation assets verified"
