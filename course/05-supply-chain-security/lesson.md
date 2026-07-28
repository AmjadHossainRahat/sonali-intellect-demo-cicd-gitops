# Lesson 05 - Supply Chain Security

Problem: how do we gain confidence that the artifact is safe enough to publish and deploy?
Manual failure: tests do not detect vulnerable dependencies, leaked secrets, or risky container contents.
Best-practice solution: add lightweight scanning, SBOM generation, non-root containers, digest deployment, and documented signing/provenance guidance.
Files: `.github/workflows/01-pr-validation.yml`, `.github/workflows/02-release-image.yml`, `Dockerfile`, `docs/security-best-practices.md`, `scripts/verify/lesson-05.ps1` or `scripts/verify/lesson-05.sh`.
Action: inspect security steps in workflows and release artifacts.
Observe: GitHub Actions UI, Harbor UI, workflow artifacts.
Success: security checks are visible and understandable.
Troubleshooting: see `docs/troubleshooting-guide.md`.
