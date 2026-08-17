#!/usr/bin/env bash
set -euo pipefail
# Run unit tests and application context tests.
mvn -B clean test
# Build the Spring Boot executable jar without rerunning tests.
mvn -B -DskipTests package
printf '[PASS] Lesson 01 application and tests verified\n'
