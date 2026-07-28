# Lesson 08 - Kustomize Overlays

Problem: how do we keep common Kubernetes configuration while allowing environment-specific differences?
Manual failure: copying full YAML per environment creates drift and review noise.
Best-practice solution: use a shared base and overlays for local, staging, and production.
Files: `kubernetes/base/`, `kubernetes/overlays/local/`, `kubernetes/overlays/staging/`, `kubernetes/overlays/production/`, `scripts/verify/lesson-08.ps1` or `scripts/verify/lesson-08.sh`.
Action: render the local overlay.
Observe: VS Code and terminal.
Success: local overlay renders a full manifest with namespace and digest.
Troubleshooting: see Kustomize render failure in `docs/troubleshooting-guide.md`.
