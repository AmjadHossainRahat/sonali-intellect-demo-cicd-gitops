#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
kubectl apply -k "$REPO_ROOT/kubernetes/overlays/local"
kubectl -n si-demo-local rollout status deployment/sonali-intellect-demo --timeout=180s
printf '[PASS] Readiness probe demo recovered from the GitOps overlay.\n'
