Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
if (-not (Test-Path "kind\cluster-config.yaml")) { throw "Kind cluster config missing" }
if (-not (Select-String -LiteralPath "kind\cluster-config.yaml" -Pattern "control-plane" -Quiet)) { throw "Control-plane node missing" }
$workerCount = (Select-String -LiteralPath "kind\cluster-config.yaml" -Pattern "role: worker").Count
if ($workerCount -ne 2) { throw "Expected 2 worker nodes, found $workerCount" }
Write-Host "[PASS] Lesson 07 Kind three-node config verified"

