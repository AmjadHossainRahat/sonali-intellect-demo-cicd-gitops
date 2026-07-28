# Lesson 06 - Kubernetes Fundamentals

Problem: how do we describe how the application should run in Kubernetes?
Manual failure: manually starting containers does not define desired replicas, probes, networking, or recovery behavior.
Best-practice solution: declare Namespace, ServiceAccount, Deployment, ReplicaSet, Pod template, Service, probes, resources, security context, NetworkPolicy, and PodDisruptionBudget.
Files: `kubernetes/base/`, `scripts/verify/lesson-06.ps1` or `scripts/verify/lesson-06.sh`.
Action: render and dry-run the base manifests.
Observe: VS Code, terminal, kubectl.
Success: manifests render correctly and learners know which resource solves which runtime problem.
Troubleshooting: see Kustomize render failure in `docs/troubleshooting-guide.md`.
