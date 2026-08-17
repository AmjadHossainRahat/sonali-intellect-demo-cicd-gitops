# Argo CD

Install Argo CD into the local Kind cluster:

Windows PowerShell:

```powershell
.\scripts\install-argocd.ps1
kubectl -n argocd get pods
```

Git Bash/Linux/macOS:

```bash
./scripts/install-argocd.sh
kubectl -n argocd get pods
```

Before applying the Application, create the Harbor pull secret and make sure `kubernetes/overlays/local/kustomization.yaml` contains a real Harbor image digest.

A fresh clone contains an all-zero placeholder digest. That placeholder is not an image in Harbor; it only keeps the YAML valid before the first release. Publish an image with the release workflow, then run the promotion workflow so the local overlay contains a real value like:

```text
demo.goharbor.io/si_demo_harbor/sonali-intellect-demo-cicd-gitops@sha256:<real-digest>
```

After that, apply the Argo CD resources:

```powershell
kubectl apply -f argocd/project.yaml
kubectl apply -f argocd/application-local.yaml
```

Access the UI:

```bash
kubectl -n argocd port-forward svc/argocd-server 8081:443
```

Keep that terminal open, then open `https://localhost:8081` in a browser. Accept the local certificate warning and sign in as `admin`.

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

Lens is separate from the Argo CD UI. Use Lens to observe Kubernetes resources in the `argocd` and `si-demo-local` namespaces.
