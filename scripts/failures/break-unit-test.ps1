Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\..\lib.ps1"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$testFile = Join-Path $repoRoot "src\test\java\com\sonaliintellect\training\api\InfoControllerTest.java"

Write-Info "This demo intentionally creates a failing test assertion."
$content = Get-Content -LiteralPath $testFile -Raw
$content = $content.Replace("sonali-intellect-demo-cicd-gitops", "intentional-failure-for-training")
Set-Content -LiteralPath $testFile -Value $content -NoNewline
Write-Pass "Unit test failure injected. Run mvn test, then restore with scripts\recovery\restore-unit-test.ps1"

