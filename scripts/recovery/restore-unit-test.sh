#!/usr/bin/env bash
set -euo pipefail
# Restore the expected application name used by the passing assertion.
perl -0pi -e 's/intentional-failure-for-training/sonali-intellect-demo-cicd-gitops/' src/test/java/com/sonaliintellect/training/api/InfoControllerTest.java
printf '[PASS] Unit test restored.\n'
