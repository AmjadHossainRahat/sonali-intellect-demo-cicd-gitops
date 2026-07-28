# Security Best Practices

This repository demonstrates practical supply-chain basics without turning the course into a security tooling course.

| Practice | Implementation |
|---|---|
| No secrets in Git | Harbor values are documented as GitHub Secrets or environment variables |
| Least-privilege workflows | Workflows use narrow `permissions` blocks |
| CI push identity | Harbor robot account pushes images |
| Cluster pull identity | Separate Harbor pull secret for Kubernetes |
| Non-root runtime | Dockerfile creates and runs as `app` user |
| Restricted pod context | Kubernetes drops capabilities, blocks privilege escalation, and uses RuntimeDefault seccomp |
| Health probes | Readiness, liveness, and startup probes are declared |
| Resource boundaries | Requests and limits are set |
| Image scanning | Trivy scans source and final image in workflows |
| SBOM | Release workflow uploads SPDX SBOM artifact |
| Digest deployment | Kustomize overlay uses an immutable digest |
| Branch protection | Document required checks and reviewer expectations |
| Action versions | Workflows use explicit action major versions and pin tool versions where the action supports it |

Cosign signing and stronger provenance are good production additions. They are documented as future improvements because the first course version should keep the delivery flow easy to see.
