Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\..\lib.ps1"

Require-Tool "kubectl"

kubectl -n si-demo-local patch deployment sonali-intellect-demo --type=json `
    -p='[{"op":"replace","path":"/spec/template/spec/containers/0/image","value":"demo.goharbor.io/si_demo_harbor/missing-image@sha256:0000000000000000000000000000000000000000000000000000000000000000"}]'
Write-Pass "Image pull failure injected. Observe ImagePullBackOff in Lens or kubectl."

