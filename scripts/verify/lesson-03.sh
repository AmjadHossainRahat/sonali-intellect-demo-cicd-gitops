#!/usr/bin/env bash
set -euo pipefail
test -f .github/workflows/01-pr-validation.yml
mvn -B clean test
kubectl kustomize kubernetes/overlays/local >/dev/null
printf '[PASS] Lesson 03 PR validation assets verified\n'

