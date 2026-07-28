#!/usr/bin/env bash
set -euo pipefail
test -f kind/cluster-config.yaml
grep -q "control-plane" kind/cluster-config.yaml
test "$(grep -c "role: worker" kind/cluster-config.yaml)" -eq 2
printf '[PASS] Lesson 07 Kind three-node config verified\n'

