Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Run verification from the repository root.
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
# Confirm the Argo CD project manifest exists.
if (-not (Test-Path "argocd\project.yaml")) { throw "Argo CD project missing" }
# Confirm the Argo CD local application manifest exists.
if (-not (Test-Path "argocd\application-local.yaml")) { throw "Argo CD local application missing" }
# Confirm the Argo CD application points to the local Kubernetes overlay.
if (-not (Select-String -LiteralPath "argocd\application-local.yaml" -Pattern "kubernetes/overlays/local" -Quiet)) { throw "Argo CD app does not point to local overlay" }
Write-Host "[PASS] Lesson 09 Argo CD resources verified"
