#!/usr/bin/env bash
set -euo pipefail
# Confirm the PR validation workflow exists.
test -f .github/workflows/01-pr-validation.yml
# Run the same Maven test path used by PR validation.
mvn -B clean test
# Render the local Kubernetes overlay to catch manifest errors.
kubectl kustomize kubernetes/overlays/local >/dev/null
printf '[PASS] Lesson 03 PR validation assets verified\n'
