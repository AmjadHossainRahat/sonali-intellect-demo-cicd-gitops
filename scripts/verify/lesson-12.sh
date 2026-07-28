#!/usr/bin/env bash
set -euo pipefail
test -f docs/production-readiness.md
test -f docs/production-comparison.md
printf '[PASS] Lesson 12 production comparison docs exist\n'

