# Lesson 03 - Pull Request CI

Problem: how do we prevent broken code from entering the main branch?
Manual failure: relying on humans to remember every check creates inconsistent reviews.
Best-practice solution: GitHub Actions runs required checks on every pull request.
Files: `.github/workflows/01-pr-validation.yml`, `.github/dependabot.yml`, `pom.xml`, `scripts/verify/lesson-03.ps1` or `scripts/verify/lesson-03.sh`.
Action: create a branch, push a small change, open a PR.
Observe: GitHub Pull Request UI, GitHub Actions UI, VS Code, terminal.
Success: workflow runs and passes; no image is pushed and no deployment occurs.
Troubleshooting: see GitHub Actions test failure in `docs/troubleshooting-guide.md`.
