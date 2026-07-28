#!/usr/bin/env bash
set -euo pipefail
kubectl kustomize kubernetes/overlays/local >/dev/null
kubectl apply --dry-run=client -k kubernetes/overlays/local >/dev/null
printf '[PASS] Lesson 08 local overlay renders\n'

