#!/usr/bin/env bash
set -euo pipefail
kubectl -n si-demo-local scale deployment sonali-intellect-demo --replicas=1
printf '[PASS] Manual drift created. Argo CD should mark OutOfSync and self-heal if enabled.\n'

