#!/usr/bin/env bash
set -euo pipefail
test -f argocd/project.yaml
test -f argocd/application-local.yaml
grep -q "kubernetes/overlays/local" argocd/application-local.yaml
printf '[PASS] Lesson 09 Argo CD resources verified\n'

