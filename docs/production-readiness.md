# Production Readiness

This lab teaches the delivery model. It is intentionally smaller than a production platform.

| Topic | Training lab | Production expectation |
|---|---|---|
| Cluster | Local Kind | Managed or self-managed multi-node cluster with real HA |
| Registry | Demo Harbor project | Hardened Harbor or cloud registry with retention and replication |
| Repository model | Single repository | Often separate app and GitOps repositories |
| Promotion | Manual workflow and PR | Environment approvals, release policy, audit gates |
| Secrets | GitHub Secrets and Kubernetes docker-registry secret | External secret manager and rotation |
| Observability | Lens and kubectl | Metrics, logs, traces, SLOs, alerting |
| Policy | Documentation and review | Policy as code with admission controls |
| Progressive delivery | Rolling update | Canary, blue/green, or Argo Rollouts |
| Security | Trivy, SBOM, non-root, digest | Signing, provenance enforcement, runtime policy |
| DR | Cleanup/recreate | Backup, restore, tested disaster recovery |

Future improvements can include Terraform, Helm, Argo Rollouts, Prometheus, Grafana, Kyverno, OPA Gatekeeper, and External Secrets Operator. They are not part of the core lab because the first learning goal is the CI/CD and GitOps flow.

