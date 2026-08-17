Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Load shared logging and prerequisite helper functions.
. "$PSScriptRoot\..\lib.ps1"

# Resolve the repository root so the test path works from any location.
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
# Point to the test file that was changed by the failure demo.
$testFile = Join-Path $repoRoot "src\test\java\com\sonaliintellect\training\api\InfoControllerTest.java"

# Read the existing test file as one string so replacement is precise.
$content = Get-Content -LiteralPath $testFile -Raw
# Restore the expected application name used by the passing assertion.
$content = $content.Replace("intentional-failure-for-training", "sonali-intellect-demo-cicd-gitops")
# Save the restored test file without adding an extra newline.
Set-Content -LiteralPath $testFile -Value $content -NoNewline
Write-Pass "Unit test restored."
