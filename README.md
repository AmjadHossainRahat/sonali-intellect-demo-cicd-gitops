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

## Harbor Project Setup

Before running the release workflow or creating the cluster pull secret, create the Harbor project that this lab publishes to.

1. Browse to `https://demo.goharbor.io` and sign in.
2. Create a project named `si_demo_harbor`.
3. Keep the project private for the training flow so Kubernetes must use `harbor-pull-secret` to pull images.
4. In the project `Configuration` tab, enable automatic image scan on push if the option is available.
5. Do not enable blocking controls such as prevent vulnerable images from running or content trust for the first classroom run; those can block pulls before learners reach the GitOps lesson.
6. Create the two project robot accounts described below.

If you choose a different Harbor project name, update `HARBOR_PROJECT`, the image references under `kubernetes/`, and the promotion workflow before running the full cycle.

### Harbor Robot Accounts

Create robot accounts inside the `si_demo_harbor` project, not from a global/system robot account page.

This lab uses two robot accounts because the two systems need different permissions:

| Robot account | Used by | Permission needed | Why it is separate |
|---|---|---|---|
| `ci-push` | GitHub Actions release workflow | Push and pull | CI builds and publishes new images, so it needs write access to Harbor. |
| `cluster-pull` | Kubernetes `harbor-pull-secret` | Pull only | The cluster only downloads already-published images, so it should not be able to push, overwrite, or delete images. |

Keeping these accounts separate follows least privilege. If the Kubernetes pull secret is leaked from the cluster, the exposed credential cannot publish or replace images in Harbor.

For the CI push account:

1. Open Harbor -> `Projects` -> `si_demo_harbor` -> `Robot Accounts`.
2. Click `New Robot Account`.
3. Name it `ci-push`.
4. Set an expiration suitable for the training, or choose never-expiring only for a short-lived demo environment.
5. Grant repository push and pull permissions. If Harbor shows granular permissions, include repository/artifact read or list permissions required by the UI, but do not grant delete permissions.
6. Finish the wizard and copy or export the generated secret immediately. Harbor will not show the token again later.
7. Save the exact generated username and token in GitHub Actions secrets:

```text
HARBOR_USERNAME = robot$si_demo_harbor+ci-push
HARBOR_PASSWORD = <ci-push robot token>
```

For the Kubernetes pull account:

1. Stay in Harbor -> `Projects` -> `si_demo_harbor` -> `Robot Accounts`.
2. Click `New Robot Account`.
3. Name it `cluster-pull`.
4. Grant pull-only repository permissions. If Harbor shows granular permissions, include repository/artifact read or list permissions required for pulling, but do not grant push or delete permissions.
5. Finish the wizard and copy or export the generated secret immediately.
6. Use this exact generated username and token when creating the local Kubernetes pull secret:

```text
HARBOR_USERNAME = robot$si_demo_harbor+cluster-pull
HARBOR_PASSWORD = <cluster-pull robot token>
```

Modern project robot usernames usually include the project name, for example `robot$si_demo_harbor+cluster-pull`. Copy the exact username Harbor shows; do not shorten it.

## Windows Full Local Cycle

After `.\scripts\prerequisites.ps1` reports all prerequisites as passing, run the local classroom setup from PowerShell.

Create the Kind cluster and install Argo CD:

```powershell
.\scripts\create-cluster.ps1
.\scripts\install-argocd.ps1
```

Create the Harbor pull secret before syncing the application:

```powershell
$env:HARBOR_REGISTRY = "demo.goharbor.io"
$env:HARBOR_USERNAME = 'robot$si_demo_harbor+cluster-pull'
$env:HARBOR_PASSWORD = "<robot-token>"
.\scripts\create-registry-secret.ps1
```

Only apply the Argo CD Application after `kubernetes/overlays/local/kustomization.yaml` points to a real Harbor image digest. The placeholder digest in a fresh clone is not a runnable image.

```powershell
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
$env:HARBOR_USERNAME = 'robot$si_demo_harbor+cluster-pull'
$env:HARBOR_PASSWORD = "<robot-token>"
.\scripts\create-registry-secret.ps1
```

Git Bash/Linux/macOS:

```bash
export HARBOR_REGISTRY=demo.goharbor.io
export HARBOR_USERNAME='robot$si_demo_harbor+cluster-pull'
export HARBOR_PASSWORD='<robot-token>'
./scripts/create-registry-secret.sh
```

Apply Argo CD resources after the Harbor pull secret exists and the local overlay contains a real image digest:

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
| `HARBOR_USERNAME` | Secret | `robot$si_demo_harbor+ci-push` | CI push identity |
| `HARBOR_PASSWORD` | Secret | `<robot-token>` | CI push token |

Do not commit real credentials. For robot usernames, copy the exact value from Harbor because the prefix format can vary by Harbor version and configuration.

## Training Material Path

The standalone `course/` directory has been removed from this repository. Use the documentation set instead:

| File | Purpose |
|---|---|
| `docs/presentation-storyboard.md` | PowerPoint-ready training storyline |
| `docs/command-reference.md` | Commands for app, Docker, Kind, Kubernetes, Argo CD, Lens, failure demos, and cleanup |
| `docs/observation-guide.md` | What to observe in each tool/UI |
| `docs/lens-guide.md` | Lens navigation with matching `kubectl` commands |
| `docs/troubleshooting-guide.md` | Failure symptoms, inspection commands, fixes, and verification |
| `docs/configuration-catalog.md` | File-to-tool mapping |

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
