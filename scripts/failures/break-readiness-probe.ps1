Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\..\lib.ps1"

Require-Tool "kubectl"

kubectl -n si-demo-local patch deployment sonali-intellect-demo --type=json `
    -p='[{"op":"replace","path":"/spec/template/spec/containers/0/readinessProbe/httpGet/path","value":"/broken-readiness"}]'
Write-Pass "Readiness probe failure injected. Observe pods not Ready."

