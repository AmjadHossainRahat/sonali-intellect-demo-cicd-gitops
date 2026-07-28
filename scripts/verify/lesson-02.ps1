Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
docker build -t sonali-intellect-demo-cicd-gitops:local .
Write-Host "[PASS] Lesson 02 container image builds"

