# Kind Cluster

The training cluster uses one control-plane node and two worker nodes:

```bash
kind create cluster --config kind/cluster-config.yaml --name cicd-gitops-demo
kubectl get nodes -o wide
```

This topology is for learning. It is useful for scheduling, rollout, and observation demos, but it is not production high availability.

