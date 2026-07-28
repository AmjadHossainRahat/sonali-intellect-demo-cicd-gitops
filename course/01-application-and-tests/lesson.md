# Lesson 01 - Application And Tests

Problem: how do we know the application works before packaging or deployment?
Manual failure: testing only after deployment delays feedback and makes failures harder to locate.
Best-practice solution: run Maven tests and health endpoint checks locally and in CI.
Files: `pom.xml`, `src/`, `src/test/`, `scripts/verify/lesson-01.ps1` or `scripts/verify/lesson-01.sh`.
Action: run Maven test/package and start the jar.
Observe: terminal, browser or curl, VS Code.
Success: tests pass, app starts, readiness endpoint is healthy.
Troubleshooting: see `docs/troubleshooting-guide.md#github-actions-test-failure`.
