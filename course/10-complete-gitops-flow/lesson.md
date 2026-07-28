# Lesson 10 - Complete GitOps Flow

Problem: how does a code change become a running Kubernetes deployment without CI directly touching the cluster?
Manual failure: direct deploy jobs mix build credentials with cluster control and hide runtime drift.
Best-practice solution: PR validation, Harbor publishing, digest promotion PR, Argo CD reconciliation, Kubernetes rolling update, Lens observation.
Files: `.github/workflows/01-pr-validation.yml`, `.github/workflows/02-release-image.yml`, `.github/workflows/03-promote-local.yml`, `kubernetes/overlays/local/kustomization.yaml`, `argocd/application-local.yaml`, `scripts/verify/lesson-10.ps1` or `.sh`.
Action: merge a change, publish image, promote digest, merge promotion PR, watch Argo CD sync.
Observe: GitHub PR, Actions, Harbor, Argo CD, Lens, kubectl, browser or curl.
Success: deployed image digest matches GitOps manifest and pods become Ready.
Troubleshooting: use `docs/troubleshooting-guide.md`.
