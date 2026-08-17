#!/usr/bin/env bash
set -euo pipefail
# Render the local Kubernetes overlay with Kustomize.
kubectl kustomize kubernetes/overlays/local >/dev/null
# Validate the local overlay with kubectl client-side dry run.
kubectl apply --dry-run=client -k kubernetes/overlays/local >/dev/null
printf '[PASS] Lesson 08 local overlay renders\n'
