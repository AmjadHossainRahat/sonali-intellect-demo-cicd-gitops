# Lesson 04 - Harbor Image Publishing

Problem: how do we store a trusted build artifact outside the build machine?
Manual failure: images that exist only on one laptop or runner are not durable, auditable, or shareable.
Best-practice solution: publish a commit-SHA tagged image to Harbor and record the digest.
Files: `.github/workflows/02-release-image.yml`, `Dockerfile`, `.github/workflows/README.md`, `docs/gitops-release-model.md`, `scripts/verify/lesson-04.ps1` or `scripts/verify/lesson-04.sh`.
Action: merge to main or run the release workflow manually.
Observe: GitHub Actions UI and Harbor UI.
Success: image appears in Harbor with tag and digest; digest is available for promotion.
Troubleshooting: see Harbor login and push failures in `docs/troubleshooting-guide.md`.
