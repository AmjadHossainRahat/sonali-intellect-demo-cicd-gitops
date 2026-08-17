#!/usr/bin/env bash
set -euo pipefail
# Resolve this script's directory so paths work from any current directory.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Load shared logging and prerequisite helper functions.
source "$SCRIPT_DIR/lib.sh"
# Resolve the repository root for generated-file cleanup.
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

REMOVE_LOCAL_IMAGES=false
REMOVE_DOWNLOADED_TOOLS=false
REMOVE_GENERATED_LOGS=false

for arg in "$@"; do
  # Convert each command-line option into cleanup switches.
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
      # Stop when an unsupported option is provided.
      fail "Unknown cleanup option: $arg"
      ;;
  esac
done

# Confirm Kind is available before checking for the local training cluster.
require_tool kind
# Delete the local training cluster only when Kind reports it exists.
if kind get clusters | grep -qx "cicd-gitops-demo"; then
  kind delete cluster --name cicd-gitops-demo
  pass "Kind cluster cicd-gitops-demo deleted"
else
  pass "Kind cluster cicd-gitops-demo was already absent"
fi

if [ "$REMOVE_LOCAL_IMAGES" = true ]; then
  # Check Docker CLI and daemon availability before image cleanup.
  if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    # Find local images created by this training repository.
    mapfile -t images < <(docker images --format '{{.Repository}}:{{.Tag}}' | grep '^sonali-intellect-demo-cicd-gitops:' || true)
    if [ "${#images[@]}" -gt 0 ]; then
      # Remove all matching local image tags.
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
  # Remove generated local logs and temporary classroom files.
  rm -f "$REPO_ROOT/target/runtime-smoke.out.log" \
        "$REPO_ROOT/target/runtime-smoke.err.log" \
        "$REPO_ROOT/target/runtime-smoke.log" \
        "$REPO_ROOT/argocd-admin-password.txt"
  pass "Generated local logs and temporary files removed"
fi

if [ "$REMOVE_DOWNLOADED_TOOLS" = true ]; then
  # Use the configured tools directory or the default user-local training path.
  TOOLS_ROOT="${SI_TOOLS_HOME:-$HOME/.sonali-intellect-tools}"
  if [ -d "$TOOLS_ROOT" ]; then
    # Remove downloaded tools managed by the prerequisite script.
    rm -rf "$TOOLS_ROOT"
    pass "Downloaded training tools removed from $TOOLS_ROOT"
  else
    pass "Downloaded training tools directory was already absent"
  fi
fi
