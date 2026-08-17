Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\lib.ps1"

# Confirm kubectl is available before writing the Kubernetes secret.
Require-Tool "kubectl"

# Require the Harbor registry hostname from the current PowerShell session.
if (-not $env:HARBOR_REGISTRY) {
    Write-Fail "Set HARBOR_REGISTRY, for example demo.goharbor.io"
}
# Require the Harbor pull robot account username from the current session.
if (-not $env:HARBOR_USERNAME) {
    Write-Fail "Set HARBOR_USERNAME to the Harbor pull robot account"
}
# Require the Harbor pull robot account token/password from the current session.
if (-not $env:HARBOR_PASSWORD) {
    Write-Fail "Set HARBOR_PASSWORD to the Harbor pull robot token"
}

# Create the application namespace declaratively so the secret has a target.
Invoke-CheckedCommand "Application namespace creation failed" { kubectl create namespace si-demo-local --dry-run=client -o yaml | kubectl apply -f - }
# Create or update the image pull secret without printing the secret value.
Invoke-CheckedCommand "Harbor pull secret creation failed" {
    kubectl -n si-demo-local create secret docker-registry harbor-pull-secret `
        --docker-server="$env:HARBOR_REGISTRY" `
        --docker-username="$env:HARBOR_USERNAME" `
        --docker-password="$env:HARBOR_PASSWORD" `
        --dry-run=client -o yaml | kubectl apply -f -
}

Write-Pass "harbor-pull-secret exists in namespace si-demo-local"
