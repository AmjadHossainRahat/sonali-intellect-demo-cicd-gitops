Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\..\use-java21.ps1"
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
if (-not (Test-Path ".github\workflows\01-pr-validation.yml")) { throw "PR validation workflow missing" }
mvn -B clean test
kubectl kustomize kubernetes/overlays/local *> $null
Write-Host "[PASS] Lesson 03 PR validation assets verified"
