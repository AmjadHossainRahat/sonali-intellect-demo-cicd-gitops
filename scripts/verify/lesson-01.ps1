Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\..\use-java21.ps1"
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
mvn -B clean test
mvn -B -DskipTests package
Write-Host "[PASS] Lesson 01 application and tests verified"
