param(
    [switch]$RemoveLocalImages,
    [switch]$RemoveDownloadedTools,
    [switch]$RemoveGeneratedLogs,
    [switch]$All
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\lib.ps1"

# Expand -All into the three optional cleanup switches.
$RemoveLocalImages = $RemoveLocalImages -or $All
$RemoveDownloadedTools = $RemoveDownloadedTools -or $All
$RemoveGeneratedLogs = $RemoveGeneratedLogs -or $All
$repoRoot = Get-RepoRoot

# Confirm Kind is available before checking for the local training cluster.
Require-Tool "kind"

# Ask Kind which clusters exist; stderr is suppressed for friendlier failures.
$clustersOutput = cmd /c "kind get clusters 2>nul"
if ($LASTEXITCODE -ne 0) {
    Write-Info "Could not list Kind clusters. Start Docker Desktop or check Docker permissions, then rerun cleanup if the cluster still exists."
}
elseif ($clustersOutput -contains "cicd-gitops-demo") {
    # Delete the local training cluster when it exists.
    Invoke-CheckedCommand "Kind cluster cicd-gitops-demo could not be deleted" { kind delete cluster --name cicd-gitops-demo }
    Write-Pass "Kind cluster cicd-gitops-demo deleted"
}
else {
    Write-Pass "Kind cluster cicd-gitops-demo was already absent"
}

if ($RemoveLocalImages) {
    # Remove only images created by this training repository.
    if (Get-Command docker -ErrorAction SilentlyContinue) {
        try {
            # Check Docker daemon availability before listing images.
            docker info *> $null
            if ($LASTEXITCODE -ne 0) {
                throw "Docker daemon is not reachable"
            }
            # Find local images with the training repository name.
            $images = docker images --format "{{.Repository}}:{{.Tag}}" |
                Where-Object { $_ -match "^sonali-intellect-demo-cicd-gitops:" }
            if ($LASTEXITCODE -ne 0) {
                throw "Docker image listing failed"
            }

            if ($images) {
                foreach ($image in $images) {
                    # Remove each matching local image tag.
                    Invoke-CheckedCommand "Docker image removal failed for $image" { docker rmi $image }
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
    # List generated local files that are safe to remove.
    $logFiles = @(
        (Join-Path $repoRoot "target\runtime-smoke.out.log"),
        (Join-Path $repoRoot "target\runtime-smoke.err.log"),
        (Join-Path $repoRoot "target\runtime-smoke.log"),
        (Join-Path $repoRoot "argocd-admin-password.txt")
    )

    foreach ($file in $logFiles) {
        # Delete the file only when it exists.
        if (Test-Path -LiteralPath $file) {
            Remove-Item -LiteralPath $file -Force
        }
    }
    Write-Pass "Generated local logs and temporary files removed"
}

if ($RemoveDownloadedTools) {
    # Remove the user-local tools directory managed by the prerequisite script.
    $toolsRoot = if ($env:SI_TOOLS_HOME) { $env:SI_TOOLS_HOME } else { Join-Path $env:USERPROFILE ".sonali-intellect-tools" }
    if (Test-Path -LiteralPath $toolsRoot) {
        Remove-Item -LiteralPath $toolsRoot -Recurse -Force
        Write-Pass "Downloaded training tools removed from $toolsRoot"
    }
    else {
        Write-Pass "Downloaded training tools directory was already absent"
    }
}
