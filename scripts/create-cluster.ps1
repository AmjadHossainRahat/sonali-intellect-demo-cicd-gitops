Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\lib.ps1"

# Resolve the repository root so the Kind config path works from any location.
$repoRoot = Get-RepoRoot
# Confirm the Kind CLI is available before cluster creation.
Require-Tool "kind"
# Confirm kubectl is available before selecting context and listing nodes.
Require-Tool "kubectl"
# Confirm Docker CLI is available because Kind creates Docker containers.
Require-Tool "docker"

# Verify Docker Desktop's daemon is running before asking Kind to use it.
docker info *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Fail "Docker daemon is not reachable. Start Docker Desktop and retry."
}

# List existing Kind clusters to keep cluster creation idempotent.
$clusters = kind get clusters
if ($LASTEXITCODE -ne 0) {
    Write-Fail "Could not list Kind clusters. Start Docker Desktop and retry."
}
if ($clusters -contains "cicd-gitops-demo") {
    Write-Pass "Kind cluster cicd-gitops-demo already exists"
}
else {
    # Create the training cluster from the checked-in three-node Kind config.
    Invoke-CheckedCommand "Kind cluster creation failed" { kind create cluster --config "$repoRoot\kind\cluster-config.yaml" --name cicd-gitops-demo }
    Write-Pass "Kind cluster cicd-gitops-demo created"
}

# Make kubectl point to the training cluster for later commands.
Invoke-CheckedCommand "kubectl context selection failed" { kubectl config use-context kind-cicd-gitops-demo }
# Show the cluster API endpoint so the instructor can confirm connectivity.
Invoke-CheckedCommand "kubectl cluster-info failed" { kubectl cluster-info --context kind-cicd-gitops-demo }
# Display all Kind nodes and their roles for the classroom observation step.
Invoke-CheckedCommand "kubectl node listing failed" { kubectl get nodes -o wide }
