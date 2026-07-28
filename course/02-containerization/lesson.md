# Lesson 02 - Containerization

Problem: how do we package the application so it runs consistently on different machines?
Manual failure: copying jars between machines leaves runtime dependencies and Java versions ambiguous.
Best-practice solution: use a BuildKit-compatible multi-stage Dockerfile and a non-root runtime image.
Files: `Dockerfile`, `.dockerignore`, `pom.xml`, `src/`, `scripts/verify/lesson-02.ps1` or `scripts/verify/lesson-02.sh`.
Action: build and run the image.
Observe: terminal, Docker Desktop if available, browser or curl.
Success: image builds, container starts, app responds, runtime user is non-root.
Troubleshooting: see Docker entries in `docs/command-reference.md`.
