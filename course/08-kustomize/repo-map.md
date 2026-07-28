# Repository Map

| File | Read by | Purpose |
|---|---|---|
| `kubernetes/base/` | Kustomize | Common resources |
| `kubernetes/overlays/local/` | Kustomize, Argo CD | Local desired state |
| `kubernetes/overlays/staging/` | Kustomize | Reference overlay |
| `kubernetes/overlays/production/` | Kustomize | Reference overlay |

