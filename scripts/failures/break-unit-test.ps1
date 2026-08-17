Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Load shared logging and prerequisite helper functions.
. "$PSScriptRoot\..\lib.ps1"

# Resolve the repository root so the test path works from any location.
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
# Point to the test file that will be changed for the failure demo.
$testFile = Join-Path $repoRoot "src\test\java\com\sonaliintellect\training\api\InfoControllerTest.java"

Write-Info "This demo intentionally creates a failing test assertion."
# Read the existing test file as one string so replacement is precise.
$content = Get-Content -LiteralPath $testFile -Raw
# Replace the expected application name with an intentionally wrong value.
$content = $content.Replace("sonali-intellect-demo-cicd-gitops", "intentional-failure-for-training")
# Save the changed test file without adding an extra newline.
Set-Content -LiteralPath $testFile -Value $content -NoNewline
Write-Pass "Unit test failure injected. Run mvn test, then restore with scripts\recovery\restore-unit-test.ps1"
