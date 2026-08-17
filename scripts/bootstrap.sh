#!/usr/bin/env bash
set -euo pipefail
# Resolve this script's directory so child scripts can be called from anywhere.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Load shared logging and prerequisite helper functions.
source "$SCRIPT_DIR/lib.sh"

info "Checking prerequisites"
# Run the prerequisite checker before creating cluster resources.
"$SCRIPT_DIR/prerequisites.sh"
info "Creating Kind cluster"
# Create or reuse the local three-node Kind cluster.
"$SCRIPT_DIR/create-cluster.sh"
info "Installing Argo CD"
# Install Argo CD into the local Kind cluster.
"$SCRIPT_DIR/install-argocd.sh"
info "Bootstrap complete. Create the Harbor pull secret before syncing the application."
