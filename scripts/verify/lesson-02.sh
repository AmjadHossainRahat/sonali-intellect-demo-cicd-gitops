#!/usr/bin/env bash
set -euo pipefail
# Build the local training container image.
docker build -t sonali-intellect-demo-cicd-gitops:local .
printf '[PASS] Lesson 02 container image builds\n'
