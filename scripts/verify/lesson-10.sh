#!/usr/bin/env bash
set -euo pipefail
# Confirm the local overlay pins an image digest.
grep -q "digest:" kubernetes/overlays/local/kustomization.yaml
# Confirm the promotion workflow exists.
test -f .github/workflows/03-promote-local.yml
printf '[PASS] Lesson 10 GitOps promotion assets verified\n'
