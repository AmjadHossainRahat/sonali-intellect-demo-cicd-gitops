#!/usr/bin/env bash
set -euo pipefail
kubectl -n si-demo-local patch deployment sonali-intellect-demo --type=json \
  -p='[{"op":"replace","path":"/spec/template/spec/containers/0/image","value":"demo.goharbor.io/si_demo_harbor/missing-image@sha256:0000000000000000000000000000000000000000000000000000000000000000"}]'
printf '[PASS] Image pull failure injected. Observe ImagePullBackOff in Lens or kubectl.\n'

