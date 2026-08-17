Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Load shared logging and native-command helpers.
. "$PSScriptRoot\..\lib.ps1"
# Put the repo-managed Java 21 first on PATH when available.
. "$PSScriptRoot\..\use-java21.ps1"
# Run verification from the repository root.
Set-Location (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
# Run unit tests and application context tests.
Invoke-CheckedCommand "Lesson 01 Maven tests failed" { mvn -B clean test }
# Build the Spring Boot executable jar without rerunning tests.
Invoke-CheckedCommand "Lesson 01 package build failed" { mvn -B -DskipTests package }
Write-Host "[PASS] Lesson 01 application and tests verified"
