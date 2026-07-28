Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\lib.ps1"

Require-Tool "kubectl"

if (-not $env:HARBOR_REGISTRY) {
    Write-Fail "Set HARBOR_REGISTRY, for example demo.goharbor.io"
}
if (-not $env:HARBOR_USERNAME) {
    Write-Fail "Set HARBOR_USERNAME to the Harbor pull robot account"
}
if (-not $env:HARBOR_PASSWORD) {
    Write-Fail "Set HARBOR_PASSWORD to the Harbor pull robot token"
}

kubectl create namespace si-demo-local --dry-run=client -o yaml | kubectl apply -f -
kubectl -n si-demo-local create secret docker-registry harbor-pull-secret `
    --docker-server="$env:HARBOR_REGISTRY" `
    --docker-username="$env:HARBOR_USERNAME" `
    --docker-password="$env:HARBOR_PASSWORD" `
    --dry-run=client -o yaml | kubectl apply -f -

Write-Pass "harbor-pull-secret exists in namespace si-demo-local"

