Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\lib.ps1"
# Put the repo-managed Java 21 first on PATH when available.
. "$PSScriptRoot\use-java21.ps1"

# Run all verification commands from the repository root.
$repoRoot = Get-RepoRoot
Set-Location $repoRoot

# Confirm Java is available before checking its version.
Require-Tool "java"
# Confirm Maven is available before building the application.
Require-Tool "mvn"

# Enforce Java 21 for the official verification path.
$javaMajor = Get-JavaMajorVersion
if ($javaMajor -lt 21) {
    Write-Fail "Java 21 or newer is required for the official verification path. Current Java major version is $javaMajor."
}

# Run unit tests and application context tests.
Invoke-CheckedCommand "Maven tests failed" { mvn -B clean test }
Write-Pass "Maven tests pass"

# Build the Spring Boot executable jar without rerunning tests.
Invoke-CheckedCommand "Application package build failed" { mvn -B -DskipTests package }
Write-Pass "Application package builds"

if ((Get-Command docker -ErrorAction SilentlyContinue)) {
    # Check Docker daemon availability before attempting an image build.
    docker info *> $null
    if ($LASTEXITCODE -eq 0) {
        # Build the training container image locally.
        Invoke-CheckedCommand "Docker image build failed" { docker build -t sonali-intellect-demo-cicd-gitops:verify . }
        Write-Pass "Docker image builds"
    }
    else {
        Write-Info "Docker is unavailable; skipping Docker build"
    }
}
else {
    Write-Info "Docker is unavailable; skipping Docker build"
}

if ((Get-Command kubectl -ErrorAction SilentlyContinue)) {
    # Render the shared Kubernetes base with Kustomize.
    Invoke-CheckedCommand "Kubernetes base render failed" { kubectl kustomize kubernetes/base *> $null }
    Write-Pass "Kubernetes base renders"
    # Render the local overlay that Argo CD will sync.
    Invoke-CheckedCommand "Kubernetes local overlay render failed" { kubectl kustomize kubernetes/overlays/local *> $null }
    Write-Pass "Kubernetes local overlay renders"
}
else {
    Write-Info "kubectl is unavailable; skipping Kustomize render checks"
}

$parseErrors = @()
# Parse every PowerShell script to catch syntax errors.
Get-ChildItem -Path scripts -Recurse -Filter "*.ps1" | ForEach-Object {
    $tokens = $null
    $errors = $null
    # Parse without executing so validation stays safe.
    [System.Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$tokens, [ref]$errors) | Out-Null
    if ($errors.Count -gt 0) {
        $parseErrors += "$($_.FullName): $($errors[0].Message)"
    }
}

if ($parseErrors.Count -gt 0) {
    # Print parse errors before failing the overall verification.
    $parseErrors | ForEach-Object { Write-Host $_ }
    Write-Fail "PowerShell script syntax validation failed"
}

Write-Pass "PowerShell scripts parse"
