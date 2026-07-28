# SKILL.md — Complete CI/CD + GitOps Training Repository

## Purpose

Create a new GitHub repository that teaches the full picture of modern software delivery from the bottom up:

```text
Code change
→ Pull request validation
→ Container image build
→ Harbor image publishing
→ GitOps release update
→ Argo CD reconciliation
→ Local three-node Kind deployment
→ Runtime observation with Lens and kubectl
```

This repository is **courseware first and application second**. The goal is not only to create a working CI/CD pipeline, but to make every step teachable, visible, repeatable, and easy to explain to a software company training audience.

Do **not** generate PowerPoint slides or `.pptx` files in this repository. Instead, generate repository documentation and a presentation storyboard that can later be converted into PowerPoint manually or by another tool.

---

## Repository identity

Use this working repository name unless changed by the user:

```text
si-demo-complete-cicd-gitops
```

Repository theme:

> A progressive, checkpoint-based training repository that visually demonstrates how source code travels through CI, Harbor, GitOps, Argo CD, and a local three-node Kubernetes cluster.

Core teaching principle:

> Each lesson adds one meaningful delivery capability, shows the repository files involved, provides exact commands/actions to run, tells the instructor where to observe the result, and defines the expected success state.

---

## Non-negotiable requirements

1. Build a complete working repository.
2. Use a simple application only as a vehicle for teaching CI/CD and GitOps.
3. Use one repository for application code, CI workflows, Kubernetes manifests, Argo CD resources, local Kind setup, scripts, and course documentation.
4. Keep logical separation between application source, delivery configuration, cluster setup, GitOps manifests, and course material.
5. Do not create PowerPoint slides.
6. Do create a PowerPoint-ready storyboard in Markdown.
7. Include lesson documentation that maps every lesson to repository files, commands/actions, observation tools, and expected result.
8. Include Lens as a first-class observation tool for Kubernetes runtime demonstrations.
9. Include `kubectl` commands beside Lens guidance so learners understand what Lens is showing.
10. Prefer clarity over cleverness. Avoid advanced abstractions before the underlying commands are taught.
11. Use happy-path demonstrations for every lesson.
12. Include only selected live failure cases; do not make every lesson failure-heavy.
13. Keep deeper troubleshooting in repository docs, not in the main instructor flow.
14. Use reproducible pinned versions wherever practical.
15. Use a single Java version consistently across build, Docker image, runtime, and CI.
16. Deploy by immutable image digest in GitOps manifests, not by a mutable tag.
17. GitHub Actions must not deploy directly into the local Kind cluster.
18. GitHub Actions must publish artifacts and update GitOps desired state only.
19. Argo CD running inside the local Kind cluster must pull desired state from Git and reconcile the cluster.
20. Never store real secrets in the repository.

---

## Preferred technology choices

Use these defaults unless there is a strong reason not to:

| Area | Choice |
|---|---|
| Application | Simple Java REST API |
| Java version | Java 21 LTS, used consistently everywhere |
| Build tool | Maven |
| Container build | Dockerfile with BuildKit-compatible multi-stage build |
| Registry | Harbor |
| Demo Harbor project | `si_demo_harbor` when using the user's demo Harbor setup |
| CI/CD | GitHub Actions |
| Local Kubernetes | Kind, three-node cluster |
| Kubernetes customization | Kustomize |
| GitOps controller | Argo CD |
| Kubernetes visual tool | Lens |
| CLI troubleshooting | `kubectl` |
| Optional local command helper | `Taskfile.yml` or Makefile, but raw commands must still be documented |

The Java application should be intentionally small. It should include enough runtime endpoints to support deployment and health demonstrations.

Required endpoints:

```text
GET /
GET /api/version
GET /api/build-info
GET /actuator/health/liveness
GET /actuator/health/readiness
```

The response may include application name, version, commit SHA if available, hostname/pod name, and timestamp.

---

## Expected repository structure

Create a structure close to this:

```text
si-demo-complete-cicd-gitops/
│
├── src/
│   └── ... application source ...
│
├── tests/
│   └── ... unit/integration tests if applicable ...
│
├── pom.xml
├── Dockerfile
├── .dockerignore
├── .gitignore
├── README.md
├── ARCHITECTURE.md
├── SKILL.md
│
├── .github/
│   ├── workflows/
│   │   ├── 01-pr-validation.yml
│   │   ├── 02-release-image.yml
│   │   ├── 03-promote-local.yml
│   │   └── README.md
│   ├── dependabot.yml
│   └── CODEOWNERS
│
├── kind/
│   ├── cluster-config.yaml
│   └── README.md
│
├── kubernetes/
│   ├── base/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   ├── service-account.yaml
│   │   ├── network-policy.yaml
│   │   ├── pod-disruption-budget.yaml
│   │   └── kustomization.yaml
│   │
│   └── overlays/
│       ├── local/
│       │   ├── namespace.yaml
│       │   ├── kustomization.yaml
│       │   └── README.md
│       ├── staging/
│       │   ├── kustomization.yaml
│       │   └── README.md
│       └── production/
│           ├── kustomization.yaml
│           └── README.md
│
├── argocd/
│   ├── project.yaml
│   ├── application-local.yaml
│   └── README.md
│
├── scripts/
│   ├── prerequisites.sh
│   ├── bootstrap.sh
│   ├── create-cluster.sh
│   ├── install-argocd.sh
│   ├── create-registry-secret.sh
│   ├── verify.sh
│   ├── cleanup.sh
│   │
│   ├── verify/
│   │   ├── lesson-01.sh
│   │   ├── lesson-02.sh
│   │   ├── lesson-03.sh
│   │   ├── lesson-04.sh
│   │   ├── lesson-05.sh
│   │   ├── lesson-06.sh
│   │   ├── lesson-07.sh
│   │   ├── lesson-08.sh
│   │   ├── lesson-09.sh
│   │   ├── lesson-10.sh
│   │   └── lesson-11.sh
│   │
│   ├── failures/
│   │   ├── break-unit-test.sh
│   │   ├── break-image-pull.sh
│   │   ├── break-readiness-probe.sh
│   │   └── create-argocd-drift.sh
│   │
│   └── recovery/
│       ├── restore-unit-test.sh
│       ├── restore-image-pull.sh
│       ├── restore-readiness-probe.sh
│       └── revert-drift.sh
│
├── course/
│   ├── README.md
│   ├── 00-full-picture/
│   ├── 01-application-and-tests/
│   ├── 02-containerization/
│   ├── 03-pull-request-ci/
│   ├── 04-harbor-publishing/
│   ├── 05-supply-chain-security/
│   ├── 06-kubernetes-fundamentals/
│   ├── 07-kind-cluster/
│   ├── 08-kustomize/
│   ├── 09-argocd/
│   ├── 10-complete-gitops-flow/
│   ├── 11-selected-failure-demos/
│   └── 12-production-readiness/
│
├── docs/
│   ├── configuration-catalog.md
│   ├── command-reference.md
│   ├── observation-guide.md
│   ├── troubleshooting-guide.md
│   ├── lens-guide.md
│   ├── production-comparison.md
│   ├── security-best-practices.md
│   ├── gitops-release-model.md
│   └── presentation-storyboard.md
│
└── diagrams/
    ├── full-flow.mmd
    ├── ci-flow.mmd
    ├── gitops-flow.mmd
    ├── k8s-runtime.mmd
    └── failure-flow.mmd
```

Each lesson directory under `course/` must contain:

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

For selected failure lessons, also include:

```text
failure-demo.md
recovery.md
```

---

## Teaching model

Use this repeatable classroom loop:

```text
1. Show the problem
2. Explain why the manual approach fails
3. Introduce the best-practice solution
4. Show the repository files involved
5. Open the files in VS Code
6. Run the command or trigger the workflow
7. Observe the result in GitHub / Harbor / Argo CD / Lens / kubectl
8. Confirm the expected success state
9. For selected lessons only, demonstrate a common failure
10. Discuss production differences
```

Every lesson must answer:

```text
What problem are we solving?
Which repository files are involved?
Who reads those files?
When are those files read?
What command or UI action should the instructor run?
Which tool or UI should the instructor open?
What should the audience observe?
What does success look like?
What can go wrong?
Where is deeper troubleshooting documented?
```

---

## Lesson sequence

Generate these lessons.

### Lesson 00 — Full CI/CD and GitOps picture

Purpose:

- Give learners the complete visual map before introducing files and tools.
- Explain CI versus CD.
- Explain artifact creation versus deployment.
- Explain push-based CI and pull-based GitOps deployment.
- Explain Git as desired state.

Must include:

```text
Developer
→ GitHub
→ GitHub Actions
→ Harbor
→ GitOps manifest update
→ Argo CD
→ Kind cluster
→ Lens/kubectl observation
```

No live demo is required except showing the repository layout.

---

### Lesson 01 — Application and tests

Problem:

> How do we know the application works before we package or deploy it?

Teach:

- Simple application structure
- Maven build lifecycle
- Unit tests
- Health endpoints
- Local execution

Repository mapping must include:

```text
pom.xml
src/
tests/ or src/test/
README.md
course/01-application-and-tests/
scripts/verify/lesson-01.sh
```

Commands must include:

```bash
mvn clean test
mvn clean package
java -jar target/*.jar
curl http://localhost:8080/
curl http://localhost:8080/actuator/health/readiness
```

Observation tools:

```text
Terminal
Browser or curl
VS Code
```

Expected result:

```text
Tests pass.
Application starts locally.
Health endpoints return healthy status.
```

---

### Lesson 02 — Containerization

Problem:

> How do we package the application so it runs consistently on different machines?

Teach:

- Dockerfile
- Build context
- `.dockerignore`
- Multi-stage build
- Runtime image
- Non-root user
- Container port
- Container health check if appropriate
- Image tag versus container instance

Repository mapping:

```text
Dockerfile
.dockerignore
pom.xml
src/
course/02-containerization/
scripts/verify/lesson-02.sh
```

Commands:

```bash
docker build -t si-demo-complete-cicd-gitops:local .
docker run --rm -p 8080:8080 si-demo-complete-cicd-gitops:local
curl http://localhost:8080/api/version
```

Observation tools:

```text
Terminal
Docker Desktop if available
Browser or curl
```

Expected result:

```text
Image builds successfully.
Container starts.
Application responds from inside the container.
Container does not run as root.
```

---

### Lesson 03 — Pull-request CI

Problem:

> How do we prevent broken code from entering the main branch?

Teach:

- Pull-request validation
- GitHub Actions workflow anatomy
- `name`
- `on`
- `permissions`
- `jobs`
- `steps`
- `uses`
- `run`
- Required checks
- Branch protection guidance

Repository mapping:

```text
.github/workflows/01-pr-validation.yml
.github/CODEOWNERS
.github/dependabot.yml
pom.xml
course/03-pull-request-ci/
scripts/verify/lesson-03.sh
```

Actions:

```text
Create a feature branch.
Push a small application change.
Open a pull request.
Watch GitHub Actions run.
```

Commands:

```bash
git switch -c demo/lesson-03-pr-validation
# make a small change
git add .
git commit -m "Demo PR validation"
git push origin demo/lesson-03-pr-validation
```

Observation tools:

```text
GitHub Pull Request UI
GitHub Actions UI
VS Code
Terminal
```

Expected result:

```text
Workflow runs on pull request.
Checks pass.
Merge is allowed only when required checks are green.
No image is pushed and no deployment occurs in this lesson.
```

---

### Lesson 04 — Harbor image publishing

Problem:

> How do we store a trusted build artifact outside the build machine?

Teach:

- Registry
- Harbor project
- Repository
- Robot account
- Tag
- Digest
- Immutable artifact
- Push credentials versus pull credentials

Repository mapping:

```text
.github/workflows/02-release-image.yml
Dockerfile
.github/workflows/README.md
docs/gitops-release-model.md
course/04-harbor-publishing/
scripts/verify/lesson-04.sh
```

Required GitHub secrets/variables documentation:

```text
HARBOR_REGISTRY
HARBOR_PROJECT
HARBOR_USERNAME
HARBOR_PASSWORD
```

Default example values may reference:

```text
HARBOR_REGISTRY=demo.goharbor.io
HARBOR_PROJECT=si_demo_harbor
```

Do not hardcode credentials.

Action:

```text
Merge a pull request to main, or run the release workflow manually when documented.
```

Observation tools:

```text
GitHub Actions UI
Harbor UI
```

Expected result:

```text
Image is built once.
Image is pushed to Harbor.
Image has a commit-SHA tag.
Image digest is visible.
The digest is recorded for promotion.
```

---

### Lesson 05 — Supply-chain security

Problem:

> How do we gain confidence that the artifact is safe enough to publish and deploy?

Teach:

- Dependency scanning
- Secret scanning
- Container image scanning
- SBOM
- Provenance
- Image signing concept
- Why final image scanning matters

Use a minimal coherent toolchain. Prefer Trivy for scanning and Cosign for signing if feasible. Do not add too many overlapping tools.

Repository mapping:

```text
.github/workflows/01-pr-validation.yml
.github/workflows/02-release-image.yml
Dockerfile
docs/security-best-practices.md
course/05-supply-chain-security/
scripts/verify/lesson-05.sh
```

Observation tools:

```text
GitHub Actions UI
Harbor UI
Workflow artifacts if generated
```

Expected result:

```text
Security checks run as part of CI/release.
SBOM/provenance/signing approach is documented.
Image scanning result is visible.
High-level policy is clear for training.
```

Do not make supply-chain tooling so complex that it hides the CI/CD teaching objective.

---

### Lesson 06 — Kubernetes fundamentals

Problem:

> How do we describe how the application should run in Kubernetes?

Teach in this order:

```text
Namespace
ServiceAccount
Deployment
ReplicaSet
Pod
Service
Readiness probe
Liveness probe
Resource requests and limits
Security context
NetworkPolicy
PodDisruptionBudget
```

Repository mapping:

```text
kubernetes/base/deployment.yaml
kubernetes/base/service.yaml
kubernetes/base/service-account.yaml
kubernetes/base/network-policy.yaml
kubernetes/base/pod-disruption-budget.yaml
kubernetes/base/kustomization.yaml
course/06-kubernetes-fundamentals/
scripts/verify/lesson-06.sh
```

Commands:

```bash
kubectl kustomize kubernetes/base
kubectl apply --dry-run=client -k kubernetes/base
```

Observation tools:

```text
VS Code
Terminal
kubectl
```

Expected result:

```text
Kubernetes manifests render correctly.
Learners understand which Kubernetes resource solves which runtime problem.
```

---

### Lesson 07 — Three-node Kind cluster

Problem:

> How can we safely simulate a Kubernetes cluster on a laptop for learning?

Teach:

- Kind purpose
- Control-plane node
- Worker nodes
- Local cluster limitations
- Why this is not real high availability
- Why it is still useful for rollout and scheduling demonstrations

Repository mapping:

```text
kind/cluster-config.yaml
scripts/create-cluster.sh
scripts/bootstrap.sh
scripts/cleanup.sh
course/07-kind-cluster/
scripts/verify/lesson-07.sh
```

Commands:

```bash
kind create cluster --config kind/cluster-config.yaml --name cicd-gitops-demo
kubectl get nodes -o wide
kubectl cluster-info
```

Observation tools:

```text
Terminal
Lens
```

Lens guidance:

```text
Open Lens.
Add or select the Kind cluster context.
Show Nodes.
Show Namespaces.
Show system Pods.
```

Expected result:

```text
Cluster has one control-plane node and two worker nodes.
Lens can connect to the cluster.
```

---

### Lesson 08 — Kustomize overlays

Problem:

> How do we keep common Kubernetes configuration while allowing environment-specific differences?

Teach:

- Base
- Overlay
- Rendered manifest
- Image replacement
- Namespace difference
- Local/staging/production separation

Repository mapping:

```text
kubernetes/base/
kubernetes/overlays/local/
kubernetes/overlays/staging/
kubernetes/overlays/production/
course/08-kustomize/
scripts/verify/lesson-08.sh
```

Commands:

```bash
kubectl kustomize kubernetes/overlays/local
kubectl apply --dry-run=client -k kubernetes/overlays/local
```

Observation tools:

```text
VS Code
Terminal
```

Expected result:

```text
Local overlay renders a complete Kubernetes manifest.
Learners understand base versus environment overlay.
```

---

### Lesson 09 — Argo CD

Problem:

> How do we make Kubernetes automatically match the desired state stored in Git?

Teach:

- GitOps
- Desired state
- Actual state
- Argo CD Application
- Sync
- Health
- Prune
- Self-heal
- Why Argo CD pulls from Git instead of GitHub Actions pushing to the cluster

Repository mapping:

```text
argocd/project.yaml
argocd/application-local.yaml
scripts/install-argocd.sh
course/09-argocd/
scripts/verify/lesson-09.sh
```

Commands:

```bash
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
# install Argo CD using documented script
./scripts/install-argocd.sh
kubectl -n argocd get pods
kubectl apply -f argocd/project.yaml
kubectl apply -f argocd/application-local.yaml
```

Observation tools:

```text
Argo CD UI
Terminal
Lens
```

Expected result:

```text
Argo CD is installed.
Application appears in Argo CD.
Application sync status and health are visible.
```

---

### Lesson 10 — Complete GitOps flow

Problem:

> How does a code change become a running Kubernetes deployment without CI directly touching the cluster?

Teach full flow:

```text
Feature branch
→ Pull request
→ PR validation
→ Merge to main
→ Build and publish image
→ Generate release update
→ Update Kustomize overlay with image digest
→ Argo CD detects Git change
→ Argo CD syncs
→ Kubernetes rolls out new pods
→ Lens shows runtime state
```

Repository mapping:

```text
.github/workflows/01-pr-validation.yml
.github/workflows/02-release-image.yml
.github/workflows/03-promote-local.yml
kubernetes/overlays/local/kustomization.yaml
argocd/application-local.yaml
course/10-complete-gitops-flow/
scripts/verify/lesson-10.sh
```

Observation tools:

```text
GitHub Pull Request UI
GitHub Actions UI
Harbor UI
Argo CD UI
Lens
kubectl
Browser or curl
```

Expected result:

```text
New code reaches Kubernetes through image publishing and GitOps reconciliation.
The deployed image digest matches the digest stored in the GitOps manifest.
Pods become Ready.
Application returns the updated version/build information.
```

---

### Lesson 11 — Selected failure demos

Do not make every lesson failure-heavy. Include only selected common failures that are valuable for live teaching.

Required selected failures:

```text
1. Unit test failure in GitHub Actions
2. Harbor image pull/authentication failure or ImagePullBackOff
3. Readiness probe failure
4. Argo CD manual drift and self-healing
```

For each failure include:

```text
Symptom
Where to observe
Command/UI path
Root cause
Fix
Verification
```

Observation tools:

```text
GitHub Actions UI
Harbor UI if relevant
Argo CD UI
Lens
kubectl
```

Expected result:

```text
Learners understand where to look first when the delivery pipeline or Kubernetes deployment fails.
```

Keep detailed extra errors in `docs/troubleshooting-guide.md`.

---

### Lesson 12 — Production readiness comparison

Problem:

> What is different between this local training setup and a production-grade implementation?

Teach:

- Local Kind versus real cluster
- Demo Harbor versus production registry
- Single repository versus separate application and GitOps repositories
- GitHub Actions environment approvals
- Secrets management
- Observability
- Progressive delivery
- Policy as code
- High availability
- Backup and disaster recovery
- Network security
- Release approvals

Repository mapping:

```text
docs/production-comparison.md
docs/security-best-practices.md
docs/gitops-release-model.md
course/12-production-readiness/
```

No live demo required.

Expected result:

```text
Learners understand what this demo teaches and what it intentionally does not provide.
```

---

## GitHub Actions requirements

Create three main workflows.

### `01-pr-validation.yml`

Triggered by pull requests.

Must include:

```text
Checkout
Set up Java
Cache dependencies if useful
Build
Unit tests
Basic static validation
Dockerfile validation or build check
Kubernetes manifest render validation
No Harbor login
No image push
No deployment
Minimum permissions
Concurrency control
```

This workflow must prove whether a pull request is safe enough to review and merge.

---

### `02-release-image.yml`

Triggered by merge to `main` and optionally manual dispatch.

Must include:

```text
Checkout
Set up Java
Run tests
Build container image once
Tag with commit SHA
Scan final image
Generate SBOM/provenance if feasible
Login to Harbor using secrets
Push image to Harbor
Resolve image digest
Expose digest as workflow output or artifact
```

Use immutable SHA tags. Do not rely on `latest` for deployment.

Do not deploy to Kubernetes from this workflow.

---

### `03-promote-local.yml`

Purpose:

- Update the local GitOps overlay with the new image digest.
- Prefer opening a promotion pull request rather than silently committing directly to protected `main`.

Must include documentation for two possible modes:

```text
Mode A — training-fast mode: workflow updates a demo branch or creates a PR.
Mode B — production-like mode: release PR requires review before Argo CD sees the change.
```

The default should be production-like where practical:

```text
Build publishes image.
Promotion workflow creates PR changing the local Kustomize image digest.
Instructor merges promotion PR.
Argo CD syncs from Git.
```

---

## Kubernetes requirements

The Kubernetes manifests must include:

```text
Namespace in overlay
ServiceAccount
Deployment
Service
NetworkPolicy
PodDisruptionBudget
Kustomization files
```

Deployment should include:

```text
replicas: 2
rolling update strategy
readinessProbe
livenessProbe
startupProbe if useful
resource requests
resource limits
non-root user
allowPrivilegeEscalation: false
capabilities drop ALL
seccompProfile RuntimeDefault
readOnlyRootFilesystem if compatible
imagePullSecrets documented
labels and selectors consistent
```

Use digest-based image references in GitOps overlays where possible.

---

## Kind requirements

Create a local Kind cluster config with:

```text
1 control-plane node
2 worker nodes
```

Name the cluster clearly:

```text
cicd-gitops-demo
```

Document that this is a learning topology, not real high availability.

Scripts must help with:

```text
Prerequisite check
Cluster creation
Argo CD installation
Registry pull secret creation
Verification
Cleanup
```

---

## Argo CD requirements

Create:

```text
argocd/project.yaml
argocd/application-local.yaml
```

The Application should point to the local overlay path:

```text
kubernetes/overlays/local
```

It should demonstrate:

```text
Sync status
Health status
Automated sync where appropriate
Prune
Self-heal
Retry policy
Namespace creation where appropriate
```

Document how to access the Argo CD UI.

Do not commit real Argo CD admin passwords.

---

## Harbor requirements

Document Harbor setup clearly.

Include:

```text
Project name
Repository name
Robot account for CI push
Robot account or credential for cluster pull
GitHub secrets needed
Kubernetes imagePullSecret creation
Image tags
Image digest
Immutability recommendation
Retention recommendation
Vulnerability scanning observation
```

Use the user's demo Harbor project name where relevant:

```text
si_demo_harbor
```

Assume credentials are provided externally through GitHub Secrets and local environment variables.

Do not hardcode sensitive values.

---

## Lens observation requirements

Create `docs/lens-guide.md`.

Include guidance for:

```text
Connecting Lens to the Kind cluster
Viewing nodes
Viewing namespaces
Viewing deployments
Viewing pods
Viewing replica sets
Viewing services
Viewing events
Viewing logs
Viewing resource usage
Finding ImagePullBackOff
Finding readiness/liveness failures
Watching a rolling update
Observing Argo CD-created resources
```

For every Lens observation, include equivalent `kubectl` commands.

Example format:

| Goal | Lens location | kubectl equivalent |
|---|---|---|
| See pods | Workloads → Pods | `kubectl get pods -n demo -o wide` |
| See pod events | Pod → Events tab | `kubectl describe pod <pod> -n demo` |
| See logs | Pod → Logs tab | `kubectl logs <pod> -n demo` |

---

## Documentation requirements

### Root `README.md`

Must include:

```text
What this repository teaches
Training audience
End-to-end architecture picture
Prerequisites
Repository structure
Fast-start path
Lesson-by-lesson path
Required GitHub secrets
Required local environment variables
How to run locally
How to create Kind cluster
How to install Argo CD
How to observe with Lens
How to run the complete demo
How to clean up
What is intentionally not production-grade
```

---

### `ARCHITECTURE.md`

Must include:

```text
Full delivery architecture
CI responsibilities
Harbor responsibilities
GitOps responsibilities
Argo CD responsibilities
Kubernetes runtime responsibilities
Trust boundaries
Why CI does not access the cluster
Why Argo CD pulls from Git
Why image digests matter
```

---

### `docs/configuration-catalog.md`

Create a table mapping every important file:

| File | Read by | When used | Purpose | Lesson |
|---|---|---|---|---|
| `.github/workflows/01-pr-validation.yml` | GitHub Actions | Pull request | Validate code before merge | 03 |
| `Dockerfile` | Docker/BuildKit | Image build | Package app as OCI image | 02 |
| `kubernetes/base/deployment.yaml` | Kubernetes API | Argo CD sync | Declare workload | 06 |
| `argocd/application-local.yaml` | Argo CD | Reconciliation | Connect Git to cluster | 09 |

Include all meaningful files.

---

### `docs/command-reference.md`

Group commands by purpose:

```text
Application
Docker
GitHub workflow demo
Harbor
Kind
Kubernetes
Kustomize
Argo CD
Lens/kubectl observation
Failure demo
Cleanup
```

---

### `docs/observation-guide.md`

Map stages to UI/tools:

| Stage | Tool/UI | What to observe |
|---|---|---|
| PR validation | GitHub Pull Request | Checks and merge status |
| CI job | GitHub Actions | Build/test/scan steps |
| Artifact | Harbor | Tag, digest, scan result |
| GitOps state | GitHub repo | Overlay digest update |
| Sync | Argo CD UI | Sync and health |
| Runtime | Lens | Pods, services, events, logs |
| CLI diagnosis | kubectl | Detailed cluster state |

---

### `docs/presentation-storyboard.md`

Create a PowerPoint-ready Markdown storyboard.

Do not generate the actual PowerPoint.

For each lesson, include slide suggestions in this format:

```text
Slide title
Problem statement
Visual idea
Repository files to show
Command/action to run
Tool/UI to open
Expected audience observation
Speaker notes
```

Use this slide pattern:

```text
1. Problem
2. Best-practice solution
3. Repository mapping
4. Command/action to run
5. Where to observe
6. Expected result
```

Only selected lessons should include a failure slide.

---

### `docs/troubleshooting-guide.md`

Include common issues but do not make them the primary teaching path.

Required entries:

```text
GitHub Actions test failure
Invalid GitHub secret
Harbor login failure
Harbor push failure
Kubernetes image pull failure
ImagePullBackOff
CrashLoopBackOff
Readiness probe failure
Liveness probe restart
Kustomize render failure
Argo CD OutOfSync
Argo CD Degraded
Manual drift
Lens cannot connect to Kind cluster
kubectl points to wrong context
```

Each entry must include:

```text
Symptom
Where to observe
Likely cause
Commands to inspect
Fix
Verification
```

---

## Script requirements

Scripts must be safe, readable, and idempotent where practical.

Use Bash scripts for Linux/macOS/Git Bash compatibility. Do not use PowerShell.

Every script should:

```text
set -euo pipefail
print clear progress messages
check required tools before use
fail with actionable errors
avoid deleting resources without explicit cleanup script
```

Main scripts:

```text
scripts/prerequisites.sh
scripts/bootstrap.sh
scripts/create-cluster.sh
scripts/install-argocd.sh
scripts/create-registry-secret.sh
scripts/verify.sh
scripts/cleanup.sh
```

Verification output should look like:

```text
[PASS] Java is available
[PASS] Docker is running
[PASS] Kind cluster exists
[PASS] Argo CD pods are running
[PASS] Application deployment is healthy
[FAIL] Harbor pull secret is missing
```

Failure scripts must be clearly labeled and reversible.

---

## Branches, tags, and checkpoints

Prepare the repository so it can support progressive teaching.

Document a recommended checkpoint strategy:

```text
lesson-00-start
lesson-00-complete
lesson-01-start
lesson-01-complete
...
lesson-12-complete
```

If it is not practical for Codex to create actual Git tags, generate a `course/checkpoints.md` file explaining the intended tags and the commands to create them.

Example:

```bash
git tag lesson-03-start <commit-sha>
git tag lesson-03-complete <commit-sha>
```

Also document how instructors can compare lesson changes:

```bash
git diff lesson-03-start lesson-03-complete
```

---

## Security and best-practice expectations

Implement and document:

```text
Least-privilege GitHub token permissions
No secrets in repository
GitHub Secrets for Harbor credentials
Separate CI push and cluster pull credentials concept
Container runs as non-root
Kubernetes restricted security context where practical
Resource requests and limits
Readiness and liveness probes
Digest-based deployment
Branch protection recommendations
CODEOWNERS for workflow and Kubernetes files
Dependency update guidance
Image scanning guidance
SBOM/provenance guidance where feasible
```

GitHub Actions should use minimum required permissions. Avoid broad `write-all` permissions.

Pin third-party actions to stable versions or commit SHAs where practical. If commit-SHA pinning is too cumbersome for maintainability, document the tradeoff and use explicit major/minor versions.

---

## Acceptance criteria

The repository is complete only when all of the following are true:

### Application

- Application builds successfully.
- Tests pass.
- Application runs locally.
- Application runs inside Docker.
- Health endpoints are available.

### CI/CD

- Pull-request validation workflow exists and is documented.
- Release image workflow exists and is documented.
- Promotion workflow exists and is documented.
- Workflows use clear names and readable steps.
- Workflows do not deploy directly into Kind.
- Harbor credentials are referenced through secrets only.

### Harbor

- Documentation explains project, repository, robot accounts, tags, digests, scanning, immutability, and retention.
- Image publishing flow uses commit-SHA tag and digest.
- Deployment guidance uses digest, not mutable `latest`.

### Kubernetes

- Base manifests render successfully.
- Local overlay renders successfully.
- Deployment includes probes, resources, and security context.
- Service exposes the app inside the cluster.
- NetworkPolicy and PodDisruptionBudget are present and explained.

### Kind and Argo CD

- Kind cluster config defines one control-plane and two worker nodes.
- Scripts can create and clean up the local cluster.
- Argo CD manifests exist.
- Argo CD Application points to the local Kustomize overlay.
- Argo CD UI access is documented.

### Lens

- Lens guide exists.
- Lens observation points are included in relevant lessons.
- Equivalent `kubectl` commands are documented.

### Courseware

- Every lesson has `lesson.md`, `instructor-notes.md`, `demo-script.md`, `repo-map.md`, `commands.md`, `observe.md`, `expected-output.md`, and `troubleshooting.md`.
- Selected failure demos are present but not overused.
- Root README clearly explains how to use the repo for training.
- Configuration catalogue maps files to tools and lessons.
- Presentation storyboard exists in Markdown.
- Troubleshooting guide is complete.

### Verification

- `scripts/verify.sh` provides an overall verification path.
- Lesson verification scripts exist.
- Commands are tested or written so they can be executed with minimal correction.
- Documentation and scripts agree on names, namespaces, cluster name, registry names, and paths.

---

## Final Codex execution instruction

When using this `SKILL.md`, Codex should work autonomously:

```text
Read SKILL.md completely. Create the complete si-demo-complete-cicd-gitops training repository as described. Do not generate PowerPoint slides or .pptx files. Generate the application, workflows, Dockerfile, Kubernetes manifests, Kind setup, Argo CD resources, scripts, diagrams, lesson documentation, Lens guide, troubleshooting guide, configuration catalogue, and presentation storyboard. Validate that the application builds, tests pass, Docker image builds, Kubernetes manifests render, scripts are coherent, and documentation matches the repository. Fix every inconsistency found. Stop only for an unavoidable external blocker such as missing Harbor credentials or unavailable local tools, and in that case document the smallest exact action required from the user.
```

---

## Final output expected from Codex

At completion, Codex should report:

```text
Repository created/updated
Application summary
Workflow summary
Kubernetes/GitOps summary
Course documentation summary
Scripts created
How to configure GitHub secrets
How to run local demo
How to observe using Lens
Verification commands executed
Results of tests/builds/render checks
Known limitations or external blockers
```
