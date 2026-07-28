# Lesson 09 - Argo CD

Problem: how do we make Kubernetes automatically match desired state stored in Git?
Manual failure: CI push deployments require cluster credentials and make drift harder to see.
Best-practice solution: run Argo CD inside the cluster and let it pull desired state from Git.
Files: `argocd/project.yaml`, `argocd/application-local.yaml`, `scripts/install-argocd.ps1` or `.sh`, `scripts/verify/lesson-09.ps1` or `.sh`.
Action: install Argo CD and apply Project/Application resources.
Observe: Argo CD UI, terminal, Lens.
Success: Argo CD is installed and the application appears with sync and health status.
Troubleshooting: see Argo CD OutOfSync and Degraded in `docs/troubleshooting-guide.md`.
