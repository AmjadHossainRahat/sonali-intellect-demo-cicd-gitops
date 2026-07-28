#!/usr/bin/env bash
set -euo pipefail
mvn -B clean test
mvn -B -DskipTests package
printf '[PASS] Lesson 01 application and tests verified\n'

