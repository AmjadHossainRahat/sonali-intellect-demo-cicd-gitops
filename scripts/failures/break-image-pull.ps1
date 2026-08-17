Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Load shared logging and prerequisite helper functions.
. "$PSScriptRoot\..\lib.ps1"

# Confirm kubectl is available before modifying the deployment.
Require-Tool "kubectl"

# Patch the deployment to use an intentionally missing image digest.
Invoke-CheckedCommand "Image pull failure injection failed" {
    kubectl -n si-demo-local patch deployment sonali-intellect-demo --type=json `
        -p='[{"op":"replace","path":"/spec/template/spec/containers/0/image","value":"demo.goharbor.io/si_demo_harbor/missing-image@sha256:0000000000000000000000000000000000000000000000000000000000000000"}]'
}
Write-Pass "Image pull failure injected. Observe ImagePullBackOff in Lens or kubectl."
