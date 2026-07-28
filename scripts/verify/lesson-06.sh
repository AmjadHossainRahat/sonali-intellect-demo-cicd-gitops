#!/usr/bin/env bash
set -euo pipefail
kubectl kustomize kubernetes/base >/dev/null
kubectl apply --dry-run=client -k kubernetes/base >/dev/null
printf '[PASS] Lesson 06 Kubernetes base manifests render\n'

