#!/usr/bin/env bash
set -euo pipefail
test -f .github/workflows/02-release-image.yml
grep -q HARBOR_REGISTRY .github/workflows/02-release-image.yml
printf '[PASS] Lesson 04 Harbor workflow references external credentials\n'

