#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/lib.sh"

cd "$REPO_ROOT"
require_tool java
require_tool mvn
mvn -B clean test
pass "Maven tests pass"
mvn -B -DskipTests package
pass "Application package builds"

if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  docker build -t sonali-intellect-demo-cicd-gitops:verify .
  pass "Docker image builds"
else
  info "Docker is unavailable; skipping Docker build"
fi

if command -v kubectl >/dev/null 2>&1; then
  kubectl kustomize kubernetes/base >/tmp/si-demo-base.yaml
  pass "Kubernetes base renders"
  kubectl kustomize kubernetes/overlays/local >/tmp/si-demo-local.yaml
  pass "Kubernetes local overlay renders"
else
  info "kubectl is unavailable; skipping Kustomize render checks"
fi

for script in scripts/*.sh scripts/verify/*.sh scripts/failures/*.sh scripts/recovery/*.sh; do
  bash -n "$script"
done
pass "Shell scripts parse"

