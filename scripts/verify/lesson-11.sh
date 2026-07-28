#!/usr/bin/env bash
set -euo pipefail
for file in scripts/failures/break-unit-test.sh scripts/failures/break-image-pull.sh scripts/failures/break-readiness-probe.sh scripts/failures/create-argocd-drift.sh; do
  test -f "$file"
done
printf '[PASS] Lesson 11 selected failure scripts exist\n'

