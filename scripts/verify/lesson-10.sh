#!/usr/bin/env bash
set -euo pipefail
grep -q "digest:" kubernetes/overlays/local/kustomization.yaml
test -f .github/workflows/03-promote-local.yml
printf '[PASS] Lesson 10 GitOps promotion assets verified\n'

