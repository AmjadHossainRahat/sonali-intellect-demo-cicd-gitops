Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\lib.ps1"
. "$PSScriptRoot\use-java21.ps1"

$repoRoot = Get-RepoRoot
Set-Location $repoRoot

Require-Tool "java"
Require-Tool "mvn"

$javaMajor = Get-JavaMajorVersion
if ($javaMajor -lt 21) {
    Write-Fail "Java 21 or newer is required for the official verification path. Current Java major version is $javaMajor."
}

mvn -B clean test
Write-Pass "Maven tests pass"

mvn -B -DskipTests package
Write-Pass "Application package builds"

if ((Get-Command docker -ErrorAction SilentlyContinue)) {
    try {
        docker info *> $null
        docker build -t sonali-intellect-demo-cicd-gitops:verify .
        Write-Pass "Docker image builds"
    }
    catch {
        Write-Info "Docker is unavailable; skipping Docker build"
    }
}
else {
    Write-Info "Docker is unavailable; skipping Docker build"
}

if ((Get-Command kubectl -ErrorAction SilentlyContinue)) {
    kubectl kustomize kubernetes/base *> $null
    Write-Pass "Kubernetes base renders"
    kubectl kustomize kubernetes/overlays/local *> $null
    Write-Pass "Kubernetes local overlay renders"
}
else {
    Write-Info "kubectl is unavailable; skipping Kustomize render checks"
}

$parseErrors = @()
Get-ChildItem -Path scripts -Recurse -Filter "*.ps1" | ForEach-Object {
    $tokens = $null
    $errors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$tokens, [ref]$errors) | Out-Null
    if ($errors.Count -gt 0) {
        $parseErrors += "$($_.FullName): $($errors[0].Message)"
    }
}

if ($parseErrors.Count -gt 0) {
    $parseErrors | ForEach-Object { Write-Host $_ }
    Write-Fail "PowerShell script syntax validation failed"
}

Write-Pass "PowerShell scripts parse"
