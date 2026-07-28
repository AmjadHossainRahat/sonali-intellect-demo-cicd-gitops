Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
if (-not (Test-Path "argocd\project.yaml")) { throw "Argo CD project missing" }
if (-not (Test-Path "argocd\application-local.yaml")) { throw "Argo CD local application missing" }
if (-not (Select-String -LiteralPath "argocd\application-local.yaml" -Pattern "kubernetes/overlays/local" -Quiet)) { throw "Argo CD app does not point to local overlay" }
Write-Host "[PASS] Lesson 09 Argo CD resources verified"

