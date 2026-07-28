# Course Guide

Teach the lessons in order. Each lesson is designed for a repeatable classroom loop:

1. Show the problem.
2. Explain why the manual or naive approach fails.
3. Introduce the best-practice solution.
4. Show repository files in VS Code.
5. Run the command or trigger the workflow.
6. Observe in the right UI or CLI.
7. Confirm the expected state.
8. Discuss selected failures only where useful.

Use `docs/presentation-storyboard.md` to prepare slides and `docs/lens-guide.md` during Kubernetes lessons.

On Windows, prefer the `.ps1` scripts from PowerShell:

```powershell
.\scripts\create-cluster.ps1
.\scripts\install-argocd.ps1
.\scripts\verify.ps1
```

The `.sh` scripts remain available for Git Bash, Linux, macOS, CI runners, and dev containers.
