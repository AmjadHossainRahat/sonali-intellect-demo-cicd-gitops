#!/usr/bin/env bash
set -euo pipefail
# Patch the readiness probe path to an endpoint that does not exist.
kubectl -n si-demo-local patch deployment sonali-intellect-demo --type=json \
  -p='[{"op":"replace","path":"/spec/template/spec/containers/0/readinessProbe/httpGet/path","value":"/broken-readiness"}]'
printf '[PASS] Readiness probe failure injected. Observe pods not Ready.\n'
