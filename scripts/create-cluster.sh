#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/lib.sh"

require_tool kind
require_tool kubectl

if kind get clusters | grep -qx "cicd-gitops-demo"; then
  pass "Kind cluster cicd-gitops-demo already exists"
else
  kind create cluster --config "$REPO_ROOT/kind/cluster-config.yaml" --name cicd-gitops-demo
  pass "Kind cluster cicd-gitops-demo created"
fi

kubectl cluster-info --context kind-cicd-gitops-demo
kubectl get nodes -o wide

