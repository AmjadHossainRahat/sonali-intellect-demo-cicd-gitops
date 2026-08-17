#!/usr/bin/env bash
set -euo pipefail
# Resolve this script's directory so the overlay path works from any location.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Resolve the repository root for the GitOps overlay path.
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
# Reapply the local GitOps overlay to restore the desired replica count.
kubectl apply -k "$REPO_ROOT/kubernetes/overlays/local"
# Wait until the deployment has successfully rolled out again.
kubectl -n si-demo-local rollout status deployment/sonali-intellect-demo --timeout=180s
printf '[PASS] Drift recovered from the GitOps overlay.\n'
