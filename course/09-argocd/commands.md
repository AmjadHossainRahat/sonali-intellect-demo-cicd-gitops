# Commands

Windows PowerShell:

```powershell
.\scripts\install-argocd.ps1
kubectl -n argocd get pods
kubectl apply -f argocd/project.yaml
kubectl apply -f argocd/application-local.yaml
kubectl -n argocd port-forward svc/argocd-server 8081:443
```

Git Bash/Linux/macOS:

```bash
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
./scripts/install-argocd.sh
kubectl -n argocd get pods
kubectl apply -f argocd/project.yaml
kubectl apply -f argocd/application-local.yaml
kubectl -n argocd port-forward svc/argocd-server 8081:443
```

Open:

```text
https://localhost:8081
```

Username:

```text
admin
```

Password on Git Bash, Linux, or macOS:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
```

Password on Windows PowerShell:

```powershell
[Text.Encoding]::UTF8.GetString(
  [Convert]::FromBase64String(
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
  )
)
```
