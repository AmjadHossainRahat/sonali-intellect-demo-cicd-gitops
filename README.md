# sonali-intellect-demo-cicd-gitops

A step-by-step CI/CD and GitOps training lab for Sonali Intellect using GitHub Actions, Harbor, Kind, Kustomize, Argo CD, and Lens.

This repository is courseware first and application second. The Java service exists so learners can watch one code change move through pull request validation, image publishing, GitOps promotion, Argo CD reconciliation, and Kubernetes runtime observation.

## What This Repository Teaches

```text
Developer
-> GitHub pull request
-> GitHub Actions validation
-> Harbor image publishing
-> GitOps digest update
-> Argo CD pull-based reconciliation
-> Kind three-node cluster
-> Lens and kubectl observation
```

Training audience: developers, DevOps engineers, release engineers, platform engineers, QA engineers, and technical managers who need a practical mental model for modern software delivery.

## Prerequisites

Install these tools before the full local demo:

| Tool | Used for |
|---|---|
| Java 21 | Local application build and run |
| Maven 3.9+ | Build and test |
| Docker Desktop | Container build and Kind runtime |
| Kind | Local three-node Kubernetes cluster |
| kubectl | Kubernetes commands and Kustomize rendering |
| Lens | Visual Kubernetes observation |
| GitHub account | Pull requests and Actions |
| Harbor access | Image publishing and image pull demo |

Docker Desktop must be running. Docker Desktop's built-in Kubernetes does not need to be enabled because Kind creates its own Kubernetes cluster using Docker containers.

Run:

```powershell
.\scripts\prerequisites.ps1
```

To install supported missing Windows tools with `winget` or Chocolatey, run:

```powershell
.\scripts\prerequisites.ps1 -InstallMissing
```

This installs Java 21 from the official Eclipse Adoptium API into your user profile and verifies its SHA-256 checksum. For Maven, Docker Desktop, kubectl, and Kind, it uses `winget` when available, otherwise Chocolatey. After Docker Desktop is installed, open Docker Desktop and wait until the engine is running before creating the Kind cluster. Install Lens separately if it is not already on your laptop.

If the script falls back to Chocolatey for Maven, Docker Desktop, kubectl, or Kind, run PowerShell as Administrator before using `-InstallMissing`.

If your laptop already has an older machine-level Java first on `PATH`, activate the repo-installed Java 21 in the current PowerShell session before running manual Maven commands:

```powershell
. .\scripts\use-java21.ps1
```

If PowerShell blocks local scripts for the current session, run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
```

Git Bash/Linux/macOS:

```bash
./scripts/prerequisites.sh
```

## Windows Full Local Cycle

After `.\scripts\prerequisites.ps1` reports all prerequisites as passing, run the local classroom setup from PowerShell:

```powershell
.\scripts\create-cluster.ps1
.\scripts\install-argocd.ps1
kubectl apply -f argocd/project.yaml
kubectl apply -f argocd/application-local.yaml
```

Connect Lens to this kubeconfig context:

```text
kind-cicd-gitops-demo
```

Open the Argo CD UI:

```powershell
kubectl -n argocd port-forward svc/argocd-server 8081:443
```

Then browse to:

```text
https://localhost:8081
```

Keep the port-forward terminal open while using the Argo CD UI.

## Repository Structure

| Path | Purpose |
|---|---|
| `src/` | Java 21 Spring Boot training application |
| `.github/workflows/` | PR validation, Harbor publishing, and GitOps promotion workflows |
| `kubernetes/base/` | Shared Kubernetes manifests |
| `kubernetes/overlays/` | Local, staging, and production Kustomize overlays |
| `kind/` | Three-node Kind cluster configuration |
| `argocd/` | Argo CD Project and Application resources |
| `scripts/` | Bootstrap, verification, failure, and recovery scripts |
| `course/` | Lesson-by-lesson instructor material |
| `docs/` | Catalogues, references, observation guides, and storyboard |
| `diagrams/` | Mermaid diagrams for classroom explanation |

## Fast Start

```bash
mvn clean test
mvn clean package
java -jar target/*.jar
curl http://localhost:8080/
curl http://localhost:8080/actuator/health/readiness
```

Build the container:

```bash
docker build -t sonali-intellect-demo-cicd-gitops:local .
docker run --rm -p 8080:8080 sonali-intellect-demo-cicd-gitops:local
curl http://localhost:8080/api/version
```

Create the local cluster and install Argo CD:

```powershell
.\scripts\create-cluster.ps1
.\scripts\install-argocd.ps1
```

Git Bash/Linux/macOS:

```bash
./scripts/create-cluster.sh
./scripts/install-argocd.sh
```

Create the Harbor pull secret after setting external credentials:

```powershell
$env:HARBOR_REGISTRY = "demo.goharbor.io"
$env:HARBOR_USERNAME = 'robot$cluster-pull'
$env:HARBOR_PASSWORD = "<robot-token>"
.\scripts\create-registry-secret.ps1
```

Git Bash/Linux/macOS:

```bash
export HARBOR_REGISTRY=demo.goharbor.io
export HARBOR_USERNAME='robot$cluster-pull'
export HARBOR_PASSWORD='<robot-token>'
./scripts/create-registry-secret.sh
```

Apply Argo CD resources:

```bash
kubectl apply -f argocd/project.yaml
kubectl apply -f argocd/application-local.yaml
```

## Lens And Argo CD UI Quick Start

Lens connects to the Kubernetes cluster through your kubeconfig. Argo CD UI opens separately in a browser through port-forwarding.

```bash
kubectl config use-context kind-cicd-gitops-demo
kubectl get nodes -o wide
```

In Lens, add or select the cluster context:

```text
kind-cicd-gitops-demo
```

Then open the Argo CD UI:

```bash
kubectl -n argocd port-forward svc/argocd-server 8081:443
```

Keep that terminal open and browse to:

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

Accept the local certificate warning in the browser.

## Required GitHub Secrets And Variables

Use GitHub Secrets for credentials and repository variables for non-sensitive defaults.

| Name | Type | Example | Purpose |
|---|---|---|---|
| `HARBOR_REGISTRY` | Variable or secret | `demo.goharbor.io` | Harbor host |
| `HARBOR_PROJECT` | Variable or secret | `si_demo_harbor` | Harbor project |
| `HARBOR_USERNAME` | Secret | `robot$ci-push` | CI push identity |
| `HARBOR_PASSWORD` | Secret | `<robot-token>` | CI push token |

Do not commit real credentials.

## Lesson Path

Start with `course/README.md`, then teach lessons in order from `course/00-full-picture/` through `course/12-production-readiness/`.

Each lesson contains:

```text
lesson.md
instructor-notes.md
demo-script.md
repo-map.md
commands.md
observe.md
expected-output.md
troubleshooting.md
```

Lesson 11 also contains selected failure and recovery materials.

## Observation Tools During The Demo

Open these UIs as the training progresses:

| Stage | Tool |
|---|---|
| Pull request validation | GitHub Pull Request UI |
| CI and release jobs | GitHub Actions UI |
| Published artifact | Harbor UI |
| Desired state update | GitHub repository diff |
| GitOps reconciliation | Argo CD UI |
| Kubernetes runtime | Lens |
| Detailed diagnosis | `kubectl` |
| Application response | Browser or `curl` |

## Cleanup

```powershell
.\scripts\cleanup.ps1
```

Optional deeper Windows cleanup:

```powershell
.\scripts\cleanup.ps1 -RemoveLocalImages
.\scripts\cleanup.ps1 -RemoveGeneratedLogs
.\scripts\cleanup.ps1 -RemoveDownloadedTools
.\scripts\cleanup.ps1 -All
```

Git Bash/Linux/macOS:

```bash
./scripts/cleanup.sh
```

Optional deeper Git Bash/Linux/macOS cleanup:

```bash
./scripts/cleanup.sh --remove-local-images
./scripts/cleanup.sh --remove-generated-logs
./scripts/cleanup.sh --remove-downloaded-tools
./scripts/cleanup.sh --all
```

## Intentionally Not Production Grade

This lab uses Kind, a single repository, placeholder Argo CD repo URLs, and manually supplied Harbor credentials so the classroom can focus on the delivery model. See `docs/production-readiness.md` and `docs/production-comparison.md` for production differences.
