Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\lib.ps1"

$repoRoot = Get-RepoRoot
Require-Tool "kind"
Require-Tool "kubectl"
Require-Tool "docker"

try {
    docker info *> $null
}
catch {
    Write-Fail "Docker daemon is not reachable. Start Docker Desktop and retry."
}

$clusters = kind get clusters
if ($clusters -contains "cicd-gitops-demo") {
    Write-Pass "Kind cluster cicd-gitops-demo already exists"
}
else {
    kind create cluster --config "$repoRoot\kind\cluster-config.yaml" --name cicd-gitops-demo
    Write-Pass "Kind cluster cicd-gitops-demo created"
}

kubectl config use-context kind-cicd-gitops-demo
kubectl cluster-info --context kind-cicd-gitops-demo
kubectl get nodes -o wide

