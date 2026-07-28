#!/usr/bin/env bash
set -euo pipefail
grep -R "trivy" -i .github/workflows docs/security-best-practices.md >/dev/null
grep -R "SBOM" .github/workflows docs/security-best-practices.md >/dev/null
printf '[PASS] Lesson 05 supply-chain checks documented\n'

