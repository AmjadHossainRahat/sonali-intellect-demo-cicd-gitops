# Command Reference

Windows PowerShell scripts can be run from a normal PowerShell terminal. If local script execution is blocked for the current session, run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
```

To check prerequisites on Windows:

```powershell
.\scripts\prerequisites.ps1
```

To install supported missing tools with `winget` or Chocolatey:

```powershell
.\scripts\prerequisites.ps1 -InstallMissing
```

The installer switch downloads Java 21 from the official Eclipse Adoptium API into your user profile and verifies its SHA-256 checksum. For Maven, Docker Desktop, kubectl, and Kind, it uses `winget` when available, otherwise Chocolatey. Lens is a GUI observation tool and should be installed separately if missing.

If Chocolatey is used for Maven, Docker Desktop, kubectl, or Kind, open PowerShell with Run as Administrator before running `-InstallMissing`.

If an older Java remains first on `PATH`, activate the repo-installed Java 21 in the current PowerShell session:

```powershell
. .\scripts\use-java21.ps1
```

## Application

```bash
mvn clean test
mvn clean package
java -jar target/*.jar
curl http://localhost:8080/
curl http://localhost:8080/api/version
curl http://localhost:8080/actuator/health/readiness
```

## Docker

```bash
docker build -t sonali-intellect-demo-cicd-gitops:local .
docker run --rm -p 8080:8080 sonali-intellect-demo-cicd-gitops:local
docker inspect sonali-intellect-demo-cicd-gitops:local --format '{{.Config.User}}'
```

## GitHub Workflow Demo

```bash
git switch -c demo/lesson-03-pr-validation
git add .
git commit -m "Demo PR validation"
git push origin demo/lesson-03-pr-validation
```

Open the pull request, then observe the Actions tab.

## Harbor

Create the project in the Harbor UI before running these commands:

```text
Registry: demo.goharbor.io
Project: si_demo_harbor
Access: Private
Scan on push: Enabled when available
First robot account: ci-push, repository push and pull permissions
Second robot account: cluster-pull, repository pull permission only
```

Copy the exact robot usernames from Harbor. Modern project robot accounts commonly look like `robot$si_demo_harbor+ci-push` and `robot$si_demo_harbor+cluster-pull`.

Robot account UI steps:

1. Open Harbor -> `Projects` -> `si_demo_harbor` -> `Robot Accounts`.
2. Click `New Robot Account`.
3. Create `ci-push` for GitHub Actions with repository push and pull permissions. Do not grant delete permissions.
4. Copy or export the generated secret immediately and save it in GitHub Actions as `HARBOR_USERNAME` and `HARBOR_PASSWORD`.
5. Create `cluster-pull` for Kubernetes with pull-only repository permissions.
6. Copy or export the generated secret immediately and use it only for the local `harbor-pull-secret`.

GitHub Actions release secrets and variables:

```text
HARBOR_REGISTRY = demo.goharbor.io
HARBOR_PROJECT = si_demo_harbor
HARBOR_USERNAME = robot$si_demo_harbor+ci-push
HARBOR_PASSWORD = <ci-push robot token>
```

Windows PowerShell:

```powershell
$env:HARBOR_REGISTRY = "demo.goharbor.io"
$env:HARBOR_PROJECT = "si_demo_harbor"
$env:HARBOR_USERNAME = 'robot$si_demo_harbor+cluster-pull'
$env:HARBOR_PASSWORD = "<robot-token>"
.\scripts\create-registry-secret.ps1
```

Git Bash/Linux/macOS:

```bash
export HARBOR_REGISTRY=demo.goharbor.io
export HARBOR_PROJECT=si_demo_harbor
export HARBOR_USERNAME='robot$si_demo_harbor+cluster-pull'
export HARBOR_PASSWORD='<robot-token>'
./scripts/create-registry-secret.sh
```

## Kind

Windows PowerShell:

```powershell
.\scripts\create-cluster.ps1
kubectl get nodes -o wide
kubectl cluster-info
```

Git Bash/Linux/macOS:

```bash
kind create cluster --config kind/cluster-config.yaml --name cicd-gitops-demo
kubectl get nodes -o wide
kubectl cluster-info
```

## Kubernetes

```bash
kubectl get namespaces
kubectl get deployments -n si-demo-local
kubectl get replicasets -n si-demo-local
kubectl get pods -n si-demo-local -o wide
kubectl describe pod <pod> -n si-demo-local
kubectl logs <pod> -n si-demo-local
kubectl port-forward svc/sonali-intellect-demo -n si-demo-local 8080:80
```

## Kustomize

```bash
kubectl kustomize kubernetes/base
kubectl apply --dry-run=client -k kubernetes/base
kubectl kustomize kubernetes/overlays/local
kubectl apply --dry-run=client -k kubernetes/overlays/local
```

## Argo CD

Windows PowerShell:

```powershell
.\scripts\install-argocd.ps1
```

Create the Harbor pull secret and promote a real image digest before applying the Application:

```powershell
kubectl apply -f argocd/project.yaml
kubectl apply -f argocd/application-local.yaml
kubectl -n argocd port-forward svc/argocd-server 8081:443
```

Git Bash/Linux/macOS:

```bash
./scripts/install-argocd.sh
```

Create the Harbor pull secret and promote a real image digest before applying the Application:

```bash
kubectl apply -f argocd/project.yaml
kubectl apply -f argocd/application-local.yaml
kubectl -n argocd port-forward svc/argocd-server 8081:443
```

Open `https://localhost:8081` and sign in as `admin`.

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

## Lens And kubectl Observation

```bash
kubectl config use-context kind-cicd-gitops-demo
kubectl get events -n si-demo-local --sort-by=.lastTimestamp
kubectl rollout status deployment/sonali-intellect-demo -n si-demo-local
kubectl get deployment sonali-intellect-demo -n si-demo-local -o jsonpath='{.spec.template.spec.containers[0].image}'
```

## Failure Demo

Windows PowerShell:

```powershell
.\scripts\failures\break-unit-test.ps1
.\scripts\recovery\restore-unit-test.ps1
.\scripts\failures\break-image-pull.ps1
.\scripts\recovery\restore-image-pull.ps1
.\scripts\failures\break-readiness-probe.ps1
.\scripts\recovery\restore-readiness-probe.ps1
.\scripts\failures\create-argocd-drift.ps1
.\scripts\recovery\revert-drift.ps1
```

Git Bash/Linux/macOS:

```bash
./scripts/failures/break-unit-test.sh
./scripts/recovery/restore-unit-test.sh
./scripts/failures/break-image-pull.sh
./scripts/recovery/restore-image-pull.sh
./scripts/failures/break-readiness-probe.sh
./scripts/recovery/restore-readiness-probe.sh
./scripts/failures/create-argocd-drift.sh
./scripts/recovery/revert-drift.sh
```

## Cleanup

Windows PowerShell:

```powershell
.\scripts\cleanup.ps1
.\scripts\cleanup.ps1 -RemoveLocalImages
.\scripts\cleanup.ps1 -RemoveGeneratedLogs
.\scripts\cleanup.ps1 -RemoveDownloadedTools
.\scripts\cleanup.ps1 -All
```

Git Bash/Linux/macOS:

```bash
./scripts/cleanup.sh
./scripts/cleanup.sh --remove-local-images
./scripts/cleanup.sh --remove-generated-logs
./scripts/cleanup.sh --remove-downloaded-tools
./scripts/cleanup.sh --all
```
