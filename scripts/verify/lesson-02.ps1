Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Load shared logging and native-command helpers.
. "$PSScriptRoot\..\lib.ps1"
# Run verification from the repository root.
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
# Build the local training container image.
Invoke-CheckedCommand "Lesson 02 container image build failed" { docker build -t sonali-intellect-demo-cicd-gitops:local . }
Write-Host "[PASS] Lesson 02 container image builds"
