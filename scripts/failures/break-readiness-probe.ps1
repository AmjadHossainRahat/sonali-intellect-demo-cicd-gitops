Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
# Load shared logging and prerequisite helper functions.
. "$PSScriptRoot\..\lib.ps1"

# Confirm kubectl is available before modifying the deployment.
Require-Tool "kubectl"

# Patch the readiness probe path to an endpoint that does not exist.
Invoke-CheckedCommand "Readiness probe failure injection failed" {
    kubectl -n si-demo-local patch deployment sonali-intellect-demo --type=json `
        -p='[{"op":"replace","path":"/spec/template/spec/containers/0/readinessProbe/httpGet/path","value":"/broken-readiness"}]'
}
Write-Pass "Readiness probe failure injected. Observe pods not Ready."
