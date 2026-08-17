#!/usr/bin/env bash
set -euo pipefail
# Resolve this script's directory so the shared library can be loaded reliably.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Load shared logging and prerequisite helper functions.
source "$SCRIPT_DIR/lib.sh"

# Require the Harbor registry hostname from the current shell session.
: "${HARBOR_REGISTRY:?Set HARBOR_REGISTRY, for example demo.goharbor.io}"
# Require the Harbor pull robot account username from the current shell session.
: "${HARBOR_USERNAME:?Set HARBOR_USERNAME to the Harbor pull robot account}"
# Require the Harbor pull robot account token/password from the current shell session.
: "${HARBOR_PASSWORD:?Set HARBOR_PASSWORD to the Harbor pull robot token}"

# Create the application namespace declaratively so reruns are safe.
kubectl create namespace si-demo-local --dry-run=client -o yaml | kubectl apply -f -
# Create or update the image pull secret without printing the secret value.
kubectl -n si-demo-local create secret docker-registry harbor-pull-secret \
  --docker-server="$HARBOR_REGISTRY" \
  --docker-username="$HARBOR_USERNAME" \
  --docker-password="$HARBOR_PASSWORD" \
  --dry-run=client -o yaml | kubectl apply -f -
pass "harbor-pull-secret exists in namespace si-demo-local"
