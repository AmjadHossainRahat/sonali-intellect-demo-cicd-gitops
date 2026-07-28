#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

: "${HARBOR_REGISTRY:?Set HARBOR_REGISTRY, for example demo.goharbor.io}"
: "${HARBOR_USERNAME:?Set HARBOR_USERNAME to the Harbor pull robot account}"
: "${HARBOR_PASSWORD:?Set HARBOR_PASSWORD to the Harbor pull robot token}"

kubectl create namespace si-demo-local --dry-run=client -o yaml | kubectl apply -f -
kubectl -n si-demo-local create secret docker-registry harbor-pull-secret \
  --docker-server="$HARBOR_REGISTRY" \
  --docker-username="$HARBOR_USERNAME" \
  --docker-password="$HARBOR_PASSWORD" \
  --dry-run=client -o yaml | kubectl apply -f -
pass "harbor-pull-secret exists in namespace si-demo-local"

