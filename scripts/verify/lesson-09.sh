#!/usr/bin/env bash
set -euo pipefail
# Confirm the Argo CD project manifest exists.
test -f argocd/project.yaml
# Confirm the Argo CD local application manifest exists.
test -f argocd/application-local.yaml
# Confirm the Argo CD application points to the local Kubernetes overlay.
grep -q "kubernetes/overlays/local" argocd/application-local.yaml
printf '[PASS] Lesson 09 Argo CD resources verified\n'
