# Production Comparison

Use this document in Lesson 12 to keep the classroom honest about what the demo proves.

The lab proves:

- Pull requests protect the main branch.
- CI builds, tests, scans, and publishes artifacts.
- Harbor stores immutable release artifacts.
- Git records desired deployment state.
- Argo CD reconciles the cluster from Git.
- Lens and kubectl reveal runtime state.

The lab does not prove:

- Production high availability.
- Enterprise identity and access controls.
- Full vulnerability policy enforcement.
- Real network segmentation.
- Centralized observability.
- Disaster recovery.
- Regulated change approval.

Production designs should add environment-specific controls without breaking the core rule: CI creates artifacts; Git records desired state; the cluster reconciles through GitOps.

