Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\lib.ps1"

# Confirm kubectl is available before installing Argo CD.
Require-Tool "kubectl"

# Create the argocd namespace declaratively so reruns are safe.
Invoke-CheckedCommand "Argo CD namespace creation failed" { kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f - }
# Install Argo CD from the official argoproj/argo-cd release manifest.
Invoke-CheckedCommand "Argo CD manifest installation failed" { kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.12.6/manifests/install.yaml }
# Wait until the Argo CD API server deployment is ready.
Invoke-CheckedCommand "Argo CD server rollout did not complete" { kubectl -n argocd rollout status deploy/argocd-server --timeout=180s }
Write-Pass "Argo CD server is available"
