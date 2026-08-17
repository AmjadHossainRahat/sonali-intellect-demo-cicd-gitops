#!/usr/bin/env bash
set -euo pipefail
# Resolve this script's directory so paths work from any current directory.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Resolve the repository root for the Kind config path.
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
# Load shared logging and prerequisite helper functions.
source "$SCRIPT_DIR/lib.sh"

# Confirm the Kind CLI is available before cluster creation.
require_tool kind
# Confirm kubectl is available before selecting context and listing nodes.
require_tool kubectl

# List existing Kind clusters to keep cluster creation idempotent.
if kind get clusters | grep -qx "cicd-gitops-demo"; then
  pass "Kind cluster cicd-gitops-demo already exists"
else
  # Create the training cluster from the checked-in three-node Kind config.
  kind create cluster --config "$REPO_ROOT/kind/cluster-config.yaml" --name cicd-gitops-demo
  pass "Kind cluster cicd-gitops-demo created"
fi

# Show the cluster API endpoint so the instructor can confirm connectivity.
kubectl cluster-info --context kind-cicd-gitops-demo
# Display all Kind nodes and their roles for the classroom observation step.
kubectl get nodes -o wide
