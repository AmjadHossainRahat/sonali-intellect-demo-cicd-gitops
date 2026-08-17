#!/usr/bin/env bash
set -euo pipefail
# Confirm the production readiness checklist exists.
test -f docs/production-readiness.md
# Confirm the local-vs-production comparison doc exists.
test -f docs/production-comparison.md
printf '[PASS] Lesson 12 production comparison docs exist\n'
