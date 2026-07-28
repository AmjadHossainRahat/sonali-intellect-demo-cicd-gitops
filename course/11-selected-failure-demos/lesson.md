# Lesson 11 - Selected Failure Demos

Problem: learners need to know where to look first when delivery fails.
Manual failure: jumping randomly between tools wastes time and hides ownership boundaries.
Best-practice solution: diagnose by stage: GitHub Actions for CI, Harbor for artifact, Argo CD for GitOps, Lens/kubectl for runtime.
Files: `scripts/failures/`, `scripts/recovery/`, `docs/troubleshooting-guide.md`, `docs/lens-guide.md`, `scripts/verify/lesson-11.ps1` or `.sh`.
Action: run one selected failure script at a time, then recover it.
Observe: GitHub Actions, Harbor, Argo CD, Lens, kubectl.
Success: learners can identify symptom, observation tool, root cause, fix, and verification.
Troubleshooting: deeper scenarios live in `docs/troubleshooting-guide.md`.
