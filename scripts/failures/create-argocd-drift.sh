#!/usr/bin/env bash
set -euo pipefail
# Scale the live deployment away from the Git desired state to create drift.
kubectl -n si-demo-local scale deployment sonali-intellect-demo --replicas=1
printf '[PASS] Manual drift created. Argo CD should mark OutOfSync and self-heal if enabled.\n'
