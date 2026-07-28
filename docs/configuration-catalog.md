# Configuration Catalog

| File | Read by | When used | Purpose | Lesson |
|---|---|---|---|---|
| `pom.xml` | Maven, GitHub Actions, Docker build stage | Build and test | Java 21 dependencies and packaging | 01 |
| `src/main/java/.../DemoApplication.java` | Maven, JVM | Application startup | Spring Boot entry point | 01 |
| `src/main/java/.../InfoController.java` | JVM, tests | Runtime and tests | Demo endpoints and build metadata | 01 |
| `src/main/resources/application.yml` | Spring Boot | Runtime | Actuator health and app settings | 01 |
| `src/test/java/.../InfoControllerTest.java` | Maven Surefire | Test phase | Endpoint and readiness checks | 01 |
| `Dockerfile` | Docker/BuildKit, GitHub Actions | Image build | Multi-stage Java 21 container package | 02 |
| `.dockerignore` | Docker/BuildKit | Image build | Keeps build context small | 02 |
| `.github/workflows/01-pr-validation.yml` | GitHub Actions | Pull request | Validate code before merge | 03 |
| `.github/workflows/02-release-image.yml` | GitHub Actions | Merge to main or manual | Publish immutable image to Harbor | 04 |
| `.github/workflows/03-promote-local.yml` | GitHub Actions | Manual promotion | Update GitOps overlay digest by PR | 10 |
| `.github/dependabot.yml` | Dependabot | Scheduled | Dependency update guidance | 05 |
| `kubernetes/base/deployment.yaml` | Kustomize, Argo CD, Kubernetes API | Render and sync | Workload, probes, resources, security | 06 |
| `kubernetes/base/service.yaml` | Kubernetes API | Runtime | Stable in-cluster endpoint | 06 |
| `kubernetes/base/service-account.yaml` | Kubernetes API | Runtime | Pod identity | 06 |
| `kubernetes/base/network-policy.yaml` | Kubernetes API/CNI | Runtime | Network boundary demonstration | 06 |
| `kubernetes/base/pod-disruption-budget.yaml` | Kubernetes API | Runtime | Availability during voluntary disruption | 06 |
| `kubernetes/base/kustomization.yaml` | Kustomize, Argo CD | Render | Base manifest composition | 06 |
| `kubernetes/overlays/local/kustomization.yaml` | Kustomize, Argo CD | Local sync | Namespace and digest-based image | 08, 10 |
| `kubernetes/overlays/local/namespace.yaml` | Kubernetes API | Local sync | Demo namespace | 08 |
| `kubernetes/overlays/staging/kustomization.yaml` | Kustomize | Reference | Staging-shaped overlay | 12 |
| `kubernetes/overlays/production/kustomization.yaml` | Kustomize | Reference | Production-shaped overlay | 12 |
| `kind/cluster-config.yaml` | Kind | Cluster creation | One control-plane and two workers | 07 |
| `argocd/project.yaml` | Argo CD | GitOps setup | Project boundary | 09 |
| `argocd/application-local.yaml` | Argo CD | Reconciliation | Connect Git path to cluster namespace | 09 |
| `scripts/prerequisites.sh` | Instructor | Setup | Tool checks | 07 |
| `scripts/prerequisites.ps1` | Instructor on Windows | Setup | Tool checks | 07 |
| `scripts/bootstrap.sh` | Instructor | Setup | Cluster and Argo CD bootstrap | 07, 09 |
| `scripts/bootstrap.ps1` | Instructor on Windows | Setup | Cluster and Argo CD bootstrap | 07, 09 |
| `scripts/create-cluster.sh` | Instructor, Kind | Setup | Create local cluster | 07 |
| `scripts/create-cluster.ps1` | Instructor on Windows, Kind | Setup | Create local cluster | 07 |
| `scripts/install-argocd.sh` | Instructor, kubectl | Setup | Install Argo CD | 09 |
| `scripts/install-argocd.ps1` | Instructor on Windows, kubectl | Setup | Install Argo CD | 09 |
| `scripts/create-registry-secret.sh` | Instructor, kubectl | Setup | Create Harbor pull secret | 04, 10 |
| `scripts/create-registry-secret.ps1` | Instructor on Windows, kubectl | Setup | Create Harbor pull secret | 04, 10 |
| `scripts/verify.sh` | Instructor, CI-like local check | Verification | Overall repository validation | All |
| `scripts/verify.ps1` | Instructor on Windows | Verification | Overall repository validation | All |
| `scripts/verify/lesson-*.ps1` | Instructor on Windows | Lesson checkpoints | Lesson-specific verification | All |
| `scripts/failures/*.sh` | Instructor | Failure lesson | Inject selected failures | 11 |
| `scripts/failures/*.ps1` | Instructor on Windows | Failure lesson | Inject selected failures | 11 |
| `scripts/recovery/*.sh` | Instructor | Failure lesson | Recover selected failures | 11 |
| `scripts/recovery/*.ps1` | Instructor on Windows | Failure lesson | Recover selected failures | 11 |
| `docs/lens-guide.md` | Instructor, learners | Observation | Lens and kubectl mapping | 07, 09, 10, 11 |
| `docs/presentation-storyboard.md` | Instructor | Slide preparation | PowerPoint-ready storyboard | All |
