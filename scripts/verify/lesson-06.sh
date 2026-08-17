#!/usr/bin/env bash
set -euo pipefail
# Render the shared Kubernetes base with Kustomize.
kubectl kustomize kubernetes/base >/dev/null
# Validate the shared Kubernetes base with kubectl client-side dry run.
kubectl apply --dry-run=client -k kubernetes/base >/dev/null
printf '[PASS] Lesson 06 Kubernetes base manifests render\n'
