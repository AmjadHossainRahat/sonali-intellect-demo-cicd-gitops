# Lesson 07 - Three-Node Kind Cluster

Problem: how can we safely simulate a Kubernetes cluster on a laptop for learning?
Manual failure: using a shared cluster for first learning risks other workloads and makes cleanup harder.
Best-practice solution: use a named Kind cluster with one control-plane and two worker nodes.
Files: `kind/cluster-config.yaml`, `scripts/create-cluster.ps1` or `.sh`, `scripts/bootstrap.ps1` or `.sh`, `scripts/cleanup.ps1` or `.sh`, `scripts/verify/lesson-07.ps1` or `.sh`.
Action: create the cluster and inspect nodes.
Observe: terminal and Lens.
Success: the cluster has one control-plane node and two worker nodes, and Lens can connect.
Troubleshooting: see Lens and kubectl context entries in `docs/troubleshooting-guide.md`.
