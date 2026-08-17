#!/usr/bin/env bash
set -euo pipefail
# Check that every failure script used by the troubleshooting lesson exists.
for file in scripts/failures/break-unit-test.sh scripts/failures/break-image-pull.sh scripts/failures/break-readiness-probe.sh scripts/failures/create-argocd-drift.sh; do
  # Confirm the current expected failure script exists.
  test -f "$file"
done
printf '[PASS] Lesson 11 selected failure scripts exist\n'
