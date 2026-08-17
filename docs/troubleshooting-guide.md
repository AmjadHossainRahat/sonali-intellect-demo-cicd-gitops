# Troubleshooting Guide

Use this guide after the main happy-path lesson flow. Each entry starts with where to observe the symptom.

## GitHub Actions Test Failure

Symptom: PR check fails during Maven test.
Where to observe: GitHub Actions job log.
Likely cause: Code change broke an endpoint or test expectation.
Commands to inspect: `mvn clean test`.
Fix: Reproduce locally, update code or test, push a new commit.
Verification: PR checks turn green.

## Invalid GitHub Secret

Symptom: Harbor login step fails or variables are empty.
Where to observe: GitHub Actions logs.
Likely cause: Missing or misspelled `HARBOR_*` secret or variable.
Commands to inspect: Use GitHub repository Settings -> Secrets and variables -> Actions.
Fix: Add `HARBOR_REGISTRY`, `HARBOR_PROJECT`, `HARBOR_USERNAME`, and `HARBOR_PASSWORD`.
Verification: Release workflow reaches Docker push.

## Harbor Login Failure

Symptom: Docker login returns unauthorized.
Where to observe: GitHub Actions release workflow.
Likely cause: Robot account token is wrong or expired.
Commands to inspect: `docker login "$HARBOR_REGISTRY"`.
Fix: Regenerate Harbor robot token and update GitHub Secret.
Verification: Login step succeeds.

## Harbor Push Failure

Symptom: Push is denied or project not found.
Where to observe: GitHub Actions logs and Harbor UI.
Likely cause: Project `si_demo_harbor` was not created, the robot account lacks push permission, the robot username was shortened instead of copied from Harbor, or `HARBOR_PROJECT` is wrong.
Commands to inspect: Check Harbor project `si_demo_harbor`.
Fix: Create the project, keep it private for the lab, grant the CI robot account repository push and pull permissions, and update GitHub Secrets with the exact Harbor robot username and token.
Verification: Image tag and digest appear in Harbor.

## Kubernetes Image Pull Failure

Symptom: Pod waits or fails to start.
Where to observe: Lens Pods view, Events tab, or `kubectl describe pod`.
Likely cause: Missing pull secret, wrong registry, wrong digest, shortened robot username, pull robot account without pull permission, or no network route.
Commands to inspect: `kubectl describe pod <pod> -n si-demo-local`.
Fix: Create `harbor-pull-secret` with `.\scripts\create-registry-secret.ps1` on Windows or `./scripts/create-registry-secret.sh` on Git Bash/Linux/macOS, using the exact pull robot username and token from Harbor.
Verification: Pod status changes to Running and Ready.

## ImagePullBackOff

Symptom: Pod status is `ImagePullBackOff`.
Where to observe: Lens Pods status column and Events tab.
Likely cause: Kubernetes cannot pull the image.
Commands to inspect: `kubectl get events -n si-demo-local --sort-by=.lastTimestamp`.
Fix: Correct image digest or imagePullSecret.
Verification: `kubectl rollout status deployment/sonali-intellect-demo -n si-demo-local`.

## CrashLoopBackOff

Symptom: Pod repeatedly restarts.
Where to observe: Lens Pod restarts and logs.
Likely cause: JVM crash, bad env var, or startup failure.
Commands to inspect: `kubectl logs <pod> -n si-demo-local --previous`.
Fix: Correct app configuration or image.
Verification: Restart count stops increasing.

## Readiness Probe Failure

Symptom: Pod runs but is not Ready.
Where to observe: Lens Pod conditions and Events.
Likely cause: Probe path, port, or application readiness is wrong.
Commands to inspect: `kubectl describe pod <pod> -n si-demo-local`.
Fix: Restore `/actuator/health/readiness`.
Verification: Ready column shows `1/1`.

## Liveness Probe Restart

Symptom: Pod restarts periodically.
Where to observe: Lens Restarts column and Events.
Likely cause: Liveness endpoint failing or timeout too aggressive.
Commands to inspect: `kubectl describe pod <pod> -n si-demo-local`.
Fix: Correct probe path or give the app enough startup time.
Verification: Restarts stop increasing.

## Kustomize Render Failure

Symptom: `kubectl kustomize` fails.
Where to observe: Terminal or GitHub Actions validation.
Likely cause: YAML syntax error, missing resource, or bad patch.
Commands to inspect: `kubectl kustomize kubernetes/overlays/local`.
Fix: Correct the referenced file or patch.
Verification: Render command exits successfully.

## Argo CD OutOfSync

Symptom: Application sync status is OutOfSync.
Where to observe: Argo CD UI.
Likely cause: Desired Git state differs from cluster state.
Commands to inspect: Argo CD diff view or `kubectl get app -n argocd`.
Fix: Sync in Argo CD or merge the intended Git change.
Verification: Sync status becomes Synced.

## Argo CD Degraded

Symptom: Application health is Degraded.
Where to observe: Argo CD UI and Lens.
Likely cause: Pods unhealthy, image pull failure, or bad probe.
Commands to inspect: `kubectl get pods -n si-demo-local`.
Fix: Diagnose runtime issue in Lens or kubectl.
Verification: Argo CD health becomes Healthy.

## Manual Drift

Symptom: Someone changes replicas or image directly with kubectl.
Where to observe: Argo CD diff view.
Likely cause: Manual change outside Git.
Commands to inspect: `kubectl get deployment sonali-intellect-demo -n si-demo-local -o yaml`.
Fix: Let Argo CD self-heal or sync the app.
Verification: Live state matches Git desired state.

## Lens Cannot Connect To Kind Cluster

Symptom: Lens shows the cluster offline.
Where to observe: Lens cluster catalog.
Likely cause: Wrong kubeconfig or Kind cluster is stopped.
Commands to inspect: `kubectl config get-contexts` and `kind get clusters`.
Fix: Create the cluster and select `kind-cicd-gitops-demo`.
Verification: Lens shows nodes and namespaces.

## kubectl Points To Wrong Context

Symptom: Commands show unexpected namespaces or nodes.
Where to observe: Terminal.
Likely cause: Current context is not the Kind cluster.
Commands to inspect: `kubectl config current-context`.
Fix: `kubectl config use-context kind-cicd-gitops-demo`.
Verification: `kubectl get nodes` shows the Kind nodes.

## Chocolatey Install Permission Failure

Symptom: `.\scripts\prerequisites.ps1 -InstallMissing` fails with access denied under `C:\ProgramData\chocolatey`.
Where to observe: PowerShell and `C:\ProgramData\chocolatey\logs\chocolatey.log`.
Likely cause: PowerShell is not running as Administrator, or a previous Chocolatey install left a lock file.
Commands to inspect: `Get-Process choco -ErrorAction SilentlyContinue`.
Fix: Close other Chocolatey installs, open PowerShell with Run as Administrator, then rerun `.\scripts\prerequisites.ps1 -InstallMissing`.
Verification: `.\scripts\prerequisites.ps1` reports Java 21 and all tools available.
