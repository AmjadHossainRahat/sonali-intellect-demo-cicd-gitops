Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\..\lib.ps1"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$testFile = Join-Path $repoRoot "src\test\java\com\sonaliintellect\training\api\InfoControllerTest.java"

$content = Get-Content -LiteralPath $testFile -Raw
$content = $content.Replace("intentional-failure-for-training", "sonali-intellect-demo-cicd-gitops")
Set-Content -LiteralPath $testFile -Value $content -NoNewline
Write-Pass "Unit test restored."

