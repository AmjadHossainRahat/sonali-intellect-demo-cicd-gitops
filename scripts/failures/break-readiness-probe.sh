#!/usr/bin/env bash
set -euo pipefail
kubectl -n si-demo-local patch deployment sonali-intellect-demo --type=json \
  -p='[{"op":"replace","path":"/spec/template/spec/containers/0/readinessProbe/httpGet/path","value":"/broken-readiness"}]'
printf '[PASS] Readiness probe failure injected. Observe pods not Ready.\n'

