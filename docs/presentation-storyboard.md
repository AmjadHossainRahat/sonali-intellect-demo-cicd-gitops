# PowerPoint-Ready Storyboard

Do not convert this file into a `.pptx` inside this repository. Use it as a source for a future slide deck.

## Lesson 00 - Full CI/CD and GitOps Picture

Slide title: Code to cluster, one visible path
Problem statement: Teams often confuse building software with deploying software.
Visual idea: Full flow diagram from developer to Lens.
Repository files to show: `diagrams/full-flow.mmd`, repository tree.
Command/action to run: No live command required.
Tool/UI to open: VS Code.
Expected audience observation: The repository is organized by delivery responsibility.
Speaker notes: Explain CI as validation and artifact creation. Explain GitOps as pull-based runtime reconciliation.

## Lesson 01 - Application And Tests

Slide title: Validate before packaging
Problem statement: Packaging broken code only makes the failure more expensive.
Visual idea: Source code and tests before Docker.
Repository files to show: `pom.xml`, `src/`, `src/test/`.
Command/action to run: `mvn clean test`.
Tool/UI to open: Terminal, browser or curl.
Expected audience observation: Tests pass and health endpoints return UP.
Speaker notes: Keep the application intentionally small.

## Lesson 02 - Containerization

Slide title: Same app, portable runtime
Problem statement: Local machine differences create inconsistent runtime behavior.
Visual idea: Multi-stage Docker build.
Repository files to show: `Dockerfile`, `.dockerignore`.
Command/action to run: `docker build -t sonali-intellect-demo-cicd-gitops:local .`.
Tool/UI to open: Terminal, Docker Desktop if available.
Expected audience observation: Image builds and container runs as non-root.
Speaker notes: Explain image tags versus container instances.

## Lesson 03 - Pull Request CI

Slide title: Protect the main branch
Problem statement: Broken code should not reach `main`.
Visual idea: PR checks gate merge.
Repository files to show: `.github/workflows/01-pr-validation.yml`, `.github/dependabot.yml`.
Command/action to run: Open a PR.
Tool/UI to open: GitHub Pull Request and Actions.
Expected audience observation: Checks run without publishing images or deploying.
Speaker notes: Show workflow anatomy and branch protection guidance.

## Lesson 04 - Harbor Publishing

Slide title: Publish a trusted artifact
Problem statement: Build output must live somewhere durable and auditable.
Visual idea: GitHub Actions pushes to Harbor.
Repository files to show: `.github/workflows/02-release-image.yml`.
Command/action to run: Merge to main or manually run release.
Tool/UI to open: GitHub Actions and Harbor.
Expected audience observation: Commit-SHA tag and digest appear.
Speaker notes: Separate push and pull credentials.

## Lesson 05 - Supply Chain Security

Slide title: Trust but verify the artifact
Problem statement: Passing tests alone does not prove an artifact is safe.
Visual idea: Scan, SBOM, digest.
Repository files to show: release workflow and `docs/security-best-practices.md`.
Command/action to run: Inspect release workflow security steps.
Tool/UI to open: GitHub Actions, Harbor.
Expected audience observation: Scanning and SBOM are visible but not overcomplicated.
Speaker notes: Mention signing as production improvement.

## Lesson 06 - Kubernetes Fundamentals

Slide title: Runtime desired state
Problem statement: Kubernetes needs declarative instructions.
Visual idea: Namespace, Deployment, ReplicaSet, Pods, Service.
Repository files to show: `kubernetes/base/`.
Command/action to run: `kubectl kustomize kubernetes/base`.
Tool/UI to open: VS Code and terminal.
Expected audience observation: Manifests render into Kubernetes resources.
Speaker notes: Walk resources in order.

## Lesson 07 - Three-Node Kind Cluster

Slide title: A safe local cluster
Problem statement: Learners need a cluster without risking shared infrastructure.
Visual idea: One control-plane and two workers.
Repository files to show: `kind/cluster-config.yaml`.
Command/action to run: `.\scripts\create-cluster.ps1` on Windows or `./scripts/create-cluster.sh` on Git Bash/Linux/macOS.
Tool/UI to open: Terminal and Lens.
Expected audience observation: Lens shows nodes, namespaces, and system pods.
Speaker notes: Explain why this is not real HA.

## Lesson 08 - Kustomize Overlays

Slide title: Common base, environment differences
Problem statement: Copying YAML per environment creates drift.
Visual idea: Base plus local/staging/production overlays.
Repository files to show: `kubernetes/base/`, `kubernetes/overlays/local/`.
Command/action to run: `kubectl kustomize kubernetes/overlays/local`.
Tool/UI to open: VS Code and terminal.
Expected audience observation: Overlay renders namespace and image digest.
Speaker notes: Point to digest-based deployment.

## Lesson 09 - Argo CD

Slide title: The cluster pulls desired state
Problem statement: CI pushing to clusters spreads credentials and hides deployment state.
Visual idea: Argo CD compares Git and cluster.
Repository files to show: `argocd/project.yaml`, `argocd/application-local.yaml`.
Command/action to run: `.\scripts\install-argocd.ps1` on Windows or `./scripts/install-argocd.sh` on Git Bash/Linux/macOS.
Tool/UI to open: Argo CD UI, Lens, terminal.
Expected audience observation: Application appears with sync and health.
Speaker notes: Explain prune and self-heal.

## Lesson 10 - Complete GitOps Flow

Slide title: Change to running pod
Problem statement: Learners need to see the whole chain connected.
Visual idea: PR to digest to Argo CD to pods.
Repository files to show: all three workflows and local overlay.
Command/action to run: Publish image, promote digest, merge promotion PR.
Tool/UI to open: GitHub, Harbor, Argo CD, Lens, browser.
Expected audience observation: Running pod image matches Git digest.
Speaker notes: Keep this happy-path and visual.

## Lesson 11 - Selected Failure Demos

Slide title: Know where to look first
Problem statement: Failures look similar unless you know which tool owns each stage.
Visual idea: Symptom to observation tool to fix.
Repository files to show: `scripts/failures/`, `scripts/recovery/`, troubleshooting guide.
Command/action to run: One selected failure script at a time.
Tool/UI to open: GitHub Actions, Harbor, Argo CD, Lens, kubectl.
Expected audience observation: Symptom, root cause, fix, verification.
Speaker notes: Use only the highest-value failures live.

## Lesson 12 - Production Readiness

Slide title: What changes in production
Problem statement: A training lab is not a production platform.
Visual idea: Lab versus production comparison table.
Repository files to show: `docs/production-readiness.md`, `docs/production-comparison.md`.
Command/action to run: No live command required.
Tool/UI to open: VS Code.
Expected audience observation: The delivery model carries forward, but controls mature.
Speaker notes: Avoid adding every advanced tool to the core training flow.
