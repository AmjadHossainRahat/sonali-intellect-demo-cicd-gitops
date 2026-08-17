Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Run verification from the repository root.
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
# Confirm the Kind cluster config file exists.
if (-not (Test-Path "kind\cluster-config.yaml")) { throw "Kind cluster config missing" }
# Confirm the config includes one control-plane node.
if (-not (Select-String -LiteralPath "kind\cluster-config.yaml" -Pattern "control-plane" -Quiet)) { throw "Control-plane node missing" }
# Count worker nodes defined in the Kind config.
$workerCount = (Select-String -LiteralPath "kind\cluster-config.yaml" -Pattern "role: worker").Count
# Require exactly two workers for the three-node classroom cluster.
if ($workerCount -ne 2) { throw "Expected 2 worker nodes, found $workerCount" }
Write-Host "[PASS] Lesson 07 Kind three-node config verified"
