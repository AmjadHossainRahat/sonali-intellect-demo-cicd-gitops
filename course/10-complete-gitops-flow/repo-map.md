# Repository Map

| File | Read by | Purpose |
|---|---|---|
| `.github/workflows/01-pr-validation.yml` | GitHub Actions | Validate PR |
| `.github/workflows/02-release-image.yml` | GitHub Actions | Publish image |
| `.github/workflows/03-promote-local.yml` | GitHub Actions | Update digest |
| `kubernetes/overlays/local/kustomization.yaml` | Argo CD | Desired runtime image |
| `argocd/application-local.yaml` | Argo CD | Watch local overlay |

