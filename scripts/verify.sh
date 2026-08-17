#!/usr/bin/env bash
set -euo pipefail
# Resolve this script's directory so verification can run from anywhere.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Resolve the repository root before running build and manifest checks.
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
# Load shared logging and prerequisite helper functions.
source "$SCRIPT_DIR/lib.sh"

# Run all verification commands from the repository root.
cd "$REPO_ROOT"
# Confirm Java is available before running Maven.
require_tool java
# Confirm Maven is available before building the application.
require_tool mvn
# Run unit tests and application context tests.
mvn -B clean test
pass "Maven tests pass"
# Build the Spring Boot executable jar without rerunning tests.
mvn -B -DskipTests package
pass "Application package builds"

# Check Docker CLI and daemon availability before attempting an image build.
if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  # Build the training container image locally.
  docker build -t sonali-intellect-demo-cicd-gitops:verify .
  pass "Docker image builds"
else
  info "Docker is unavailable; skipping Docker build"
fi

if command -v kubectl >/dev/null 2>&1; then
  # Render the shared Kubernetes base with Kustomize.
  kubectl kustomize kubernetes/base >/tmp/si-demo-base.yaml
  pass "Kubernetes base renders"
  # Render the local overlay that Argo CD will sync.
  kubectl kustomize kubernetes/overlays/local >/tmp/si-demo-local.yaml
  pass "Kubernetes local overlay renders"
else
  info "kubectl is unavailable; skipping Kustomize render checks"
fi

for script in scripts/*.sh scripts/verify/*.sh scripts/failures/*.sh scripts/recovery/*.sh; do
  # Parse each shell script without executing it.
  bash -n "$script"
done
pass "Shell scripts parse"
