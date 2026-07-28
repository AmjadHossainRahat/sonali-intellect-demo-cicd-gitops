#!/usr/bin/env bash
set -euo pipefail
printf '[INFO] This demo intentionally creates a failing test assertion.\n'
perl -0pi -e 's/sonali-intellect-demo-cicd-gitops/intentional-failure-for-training/' src/test/java/com/sonaliintellect/training/api/InfoControllerTest.java
printf '[PASS] Unit test failure injected. Run mvn test, then restore with scripts/recovery/restore-unit-test.sh\n'

