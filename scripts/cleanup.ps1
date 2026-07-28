param(
    [switch]$RemoveLocalImages,
    [switch]$RemoveDownloadedTools,
    [switch]$RemoveGeneratedLogs,
    [switch]$All
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\lib.ps1"

$RemoveLocalImages = $RemoveLocalImages -or $All
$RemoveDownloadedTools = $RemoveDownloadedTools -or $All
$RemoveGeneratedLogs = $RemoveGeneratedLogs -or $All
$repoRoot = Get-RepoRoot

Require-Tool "kind"

$clustersOutput = cmd /c "kind get clusters 2>nul"
if ($LASTEXITCODE -ne 0) {
    Write-Info "Could not list Kind clusters. Start Docker Desktop or check Docker permissions, then rerun cleanup if the cluster still exists."
}
elseif ($clustersOutput -contains "cicd-gitops-demo") {
    & kind delete cluster --name cicd-gitops-demo
    if ($LASTEXITCODE -ne 0) {
        Write-Fail "Kind cluster cicd-gitops-demo could not be deleted."
    }
    Write-Pass "Kind cluster cicd-gitops-demo deleted"
}
else {
    Write-Pass "Kind cluster cicd-gitops-demo was already absent"
}

if ($RemoveLocalImages) {
    if (Get-Command docker -ErrorAction SilentlyContinue) {
        try {
            docker info *> $null
            $images = docker images --format "{{.Repository}}:{{.Tag}}" |
                Where-Object { $_ -match "^sonali-intellect-demo-cicd-gitops:" }

            if ($images) {
                foreach ($image in $images) {
                    docker rmi $image
                }
                Write-Pass "Local sonali-intellect-demo-cicd-gitops Docker images removed"
            }
            else {
                Write-Pass "No local sonali-intellect-demo-cicd-gitops Docker images found"
            }
        }
        catch {
            Write-Info "Docker daemon is not reachable; skipping local image cleanup"
        }
    }
    else {
        Write-Info "docker is not available; skipping local image cleanup"
    }
}

if ($RemoveGeneratedLogs) {
    $logFiles = @(
        (Join-Path $repoRoot "target\runtime-smoke.out.log"),
        (Join-Path $repoRoot "target\runtime-smoke.err.log"),
        (Join-Path $repoRoot "target\runtime-smoke.log"),
        (Join-Path $repoRoot "argocd-admin-password.txt")
    )

    foreach ($file in $logFiles) {
        if (Test-Path -LiteralPath $file) {
            Remove-Item -LiteralPath $file -Force
        }
    }
    Write-Pass "Generated local logs and temporary files removed"
}

if ($RemoveDownloadedTools) {
    $toolsRoot = if ($env:SI_TOOLS_HOME) { $env:SI_TOOLS_HOME } else { Join-Path $env:USERPROFILE ".sonali-intellect-tools" }
    if (Test-Path -LiteralPath $toolsRoot) {
        Remove-Item -LiteralPath $toolsRoot -Recurse -Force
        Write-Pass "Downloaded training tools removed from $toolsRoot"
    }
    else {
        Write-Pass "Downloaded training tools directory was already absent"
    }
}
