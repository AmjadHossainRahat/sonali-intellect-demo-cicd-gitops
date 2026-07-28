#!/usr/bin/env bash
set -euo pipefail

pass() { printf '[PASS] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; exit 1; }
info() { printf '[INFO] %s\n' "$1"; }

require_tool() {
  local tool="$1"
  command -v "$tool" >/dev/null 2>&1 || fail "$tool is required but was not found"
  pass "$tool is available"
}

