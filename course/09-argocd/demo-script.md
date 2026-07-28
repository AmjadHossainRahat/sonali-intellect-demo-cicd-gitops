# Demo Script

1. Run `.\scripts\install-argocd.ps1` on Windows or `./scripts/install-argocd.sh` on Git Bash/Linux/macOS.
2. Show Argo CD pods in Lens namespace `argocd`.
3. Apply `argocd/project.yaml`.
4. Apply `argocd/application-local.yaml`.
5. Port-forward the UI and inspect sync/health.
