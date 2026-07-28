#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

info "Checking prerequisites"
"$SCRIPT_DIR/prerequisites.sh"
info "Creating Kind cluster"
"$SCRIPT_DIR/create-cluster.sh"
info "Installing Argo CD"
"$SCRIPT_DIR/install-argocd.sh"
info "Bootstrap complete. Create the Harbor pull secret before syncing the application."

