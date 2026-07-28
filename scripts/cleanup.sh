#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

REMOVE_LOCAL_IMAGES=false
REMOVE_DOWNLOADED_TOOLS=false
REMOVE_GENERATED_LOGS=false

for arg in "$@"; do
  case "$arg" in
    --remove-local-images)
      REMOVE_LOCAL_IMAGES=true
      ;;
    --remove-downloaded-tools)
      REMOVE_DOWNLOADED_TOOLS=true
      ;;
    --remove-generated-logs)
      REMOVE_GENERATED_LOGS=true
      ;;
    --all)
      REMOVE_LOCAL_IMAGES=true
      REMOVE_DOWNLOADED_TOOLS=true
      REMOVE_GENERATED_LOGS=true
      ;;
    *)
      fail "Unknown cleanup option: $arg"
      ;;
  esac
done

require_tool kind
if kind get clusters | grep -qx "cicd-gitops-demo"; then
  kind delete cluster --name cicd-gitops-demo
  pass "Kind cluster cicd-gitops-demo deleted"
else
  pass "Kind cluster cicd-gitops-demo was already absent"
fi

if [ "$REMOVE_LOCAL_IMAGES" = true ]; then
  if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    mapfile -t images < <(docker images --format '{{.Repository}}:{{.Tag}}' | grep '^sonali-intellect-demo-cicd-gitops:' || true)
    if [ "${#images[@]}" -gt 0 ]; then
      docker rmi "${images[@]}"
      pass "Local sonali-intellect-demo-cicd-gitops Docker images removed"
    else
      pass "No local sonali-intellect-demo-cicd-gitops Docker images found"
    fi
  else
    info "Docker daemon is not reachable; skipping local image cleanup"
  fi
fi

if [ "$REMOVE_GENERATED_LOGS" = true ]; then
  rm -f "$REPO_ROOT/target/runtime-smoke.out.log" \
        "$REPO_ROOT/target/runtime-smoke.err.log" \
        "$REPO_ROOT/target/runtime-smoke.log" \
        "$REPO_ROOT/argocd-admin-password.txt"
  pass "Generated local logs and temporary files removed"
fi

if [ "$REMOVE_DOWNLOADED_TOOLS" = true ]; then
  TOOLS_ROOT="${SI_TOOLS_HOME:-$HOME/.sonali-intellect-tools}"
  if [ -d "$TOOLS_ROOT" ]; then
    rm -rf "$TOOLS_ROOT"
    pass "Downloaded training tools removed from $TOOLS_ROOT"
  else
    pass "Downloaded training tools directory was already absent"
  fi
fi
