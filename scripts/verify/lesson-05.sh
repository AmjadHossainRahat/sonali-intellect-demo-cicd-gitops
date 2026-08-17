#!/usr/bin/env bash
set -euo pipefail
# Confirm the workflow or docs mention Trivy scanning.
grep -R "trivy" -i .github/workflows docs/security-best-practices.md >/dev/null
# Confirm the workflow or docs mention SBOM generation.
grep -R "SBOM" .github/workflows docs/security-best-practices.md >/dev/null
printf '[PASS] Lesson 05 supply-chain checks documented\n'
