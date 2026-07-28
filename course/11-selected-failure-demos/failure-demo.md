# Failure Demo Details

| Failure | Symptom | Where to observe | Root cause | Fix | Verification |
|---|---|---|---|---|---|
| Unit test failure | PR check fails | GitHub Actions | Test assertion intentionally changed | `scripts/recovery/restore-unit-test.ps1` or `.sh` | `mvn clean test` |
| Image pull failure | `ImagePullBackOff` | Lens Pods, kubectl events | Bad image reference or pull credential | restore GitOps state or pull secret | rollout healthy |
| Readiness probe failure | Pod not Ready | Lens Pod conditions | Bad readiness path | restore probe through GitOps sync | Ready `1/1` |
| Manual drift | Argo CD OutOfSync | Argo CD diff | Direct kubectl change | self-heal or sync | Synced and Healthy |
