#!/usr/bin/env bash
set -euo pipefail
# Confirm the Harbor release workflow exists.
test -f .github/workflows/02-release-image.yml
# Confirm the workflow reads Harbor credentials from configured secrets or variables.
grep -q HARBOR_REGISTRY .github/workflows/02-release-image.yml
printf '[PASS] Lesson 04 Harbor workflow references external credentials\n'
