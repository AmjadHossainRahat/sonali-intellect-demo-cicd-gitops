#!/usr/bin/env bash
set -euo pipefail

# Print a successful check result in a consistent format.
pass() { printf '[PASS] %s\n' "$1"; }
# Print a failure result and stop the current script.
fail() { printf '[FAIL] %s\n' "$1"; exit 1; }
# Print an informational progress message in a consistent format.
info() { printf '[INFO] %s\n' "$1"; }

require_tool() {
  local tool="$1"
  # Check whether the requested command is available on PATH.
  command -v "$tool" >/dev/null 2>&1 || fail "$tool is required but was not found"
  pass "$tool is available"
}
