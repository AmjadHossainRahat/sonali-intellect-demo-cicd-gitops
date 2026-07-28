# Observation Guide

| Stage | Tool/UI | What to observe |
|---|---|---|
| Source change | VS Code | Application code, tests, Dockerfile, manifests |
| PR validation | GitHub Pull Request | Checks and merge status |
| CI job | GitHub Actions | Build, test, scan, Docker build, Kustomize render steps |
| Artifact | Harbor | Repository, commit-SHA tag, digest, scan result |
| GitOps state | GitHub repo | Promotion PR changing overlay digest |
| Sync | Argo CD UI | Application sync status, health, history, live manifest |
| Runtime | Lens | Namespace, Deployment, ReplicaSet, Pods, Services, Events, Logs |
| CLI diagnosis | kubectl | Detailed cluster state and rollout status |
| App behavior | Browser or curl | Endpoint response and build metadata |

The teaching rhythm is: show the file, run the command or workflow, observe the tool, confirm expected state.

