#!/usr/bin/env bash
set -euo pipefail
# Resolve this script's directory so the shared library can be loaded reliably.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Load shared logging and prerequisite helper functions.
source "$SCRIPT_DIR/lib.sh"

for tool in java mvn docker kubectl kind; do
  # Check whether each required local tool is available.
  require_tool "$tool"
done

# Verify Docker Desktop's daemon is running and reachable.
if docker info >/dev/null 2>&1; then
  pass "Docker daemon is reachable"
else
  fail "Docker daemon is not reachable. Start Docker Desktop and retry."
fi
