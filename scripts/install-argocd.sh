#!/usr/bin/env bash
set -euo pipefail
# Resolve this script's directory so the shared library can be loaded reliably.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Load shared logging and prerequisite helper functions.
source "$SCRIPT_DIR/lib.sh"

# Confirm kubectl is available before installing Argo CD.
require_tool kubectl

# Create the argocd namespace declaratively so reruns are safe.
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
# Install Argo CD from the official argoproj/argo-cd release manifest.
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.12.6/manifests/install.yaml
# Wait until the Argo CD API server deployment is ready.
kubectl -n argocd rollout status deploy/argocd-server --timeout=180s
pass "Argo CD server is available"
