#!/usr/bin/env bash
set -euo pipefail
# Confirm the Kind cluster config file exists.
test -f kind/cluster-config.yaml
# Confirm the config includes one control-plane node.
grep -q "control-plane" kind/cluster-config.yaml
# Require exactly two workers for the three-node classroom cluster.
test "$(grep -c "role: worker" kind/cluster-config.yaml)" -eq 2
printf '[PASS] Lesson 07 Kind three-node config verified\n'
