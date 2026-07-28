# GitHub Actions Workflow Map

This repository uses three workflows to separate validation, artifact publishing, and GitOps promotion.

| Workflow | Trigger | Purpose | Cluster access |
|---|---|---|---|
| `01-pr-validation.yml` | Pull request | Build, test, scan source, render manifests | None |
| `02-release-image.yml` | Merge to `main`, manual | Build once, scan final image, publish to Harbor, record digest | None |
| `03-promote-local.yml` | Manual | Update Kustomize overlay to an immutable digest, preferably by PR | None |

GitHub Actions never deploys directly to Kind. Argo CD pulls desired state from Git and reconciles the cluster.

