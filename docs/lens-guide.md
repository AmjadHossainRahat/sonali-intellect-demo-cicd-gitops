# Lens Guide

Use Lens as the visual Kubernetes observation tool. Keep a terminal open beside it so learners can connect UI state with `kubectl`.

Lens connects to Kubernetes, not directly to Argo CD. For this lab, Lens should use the Kind context in your kubeconfig, while Argo CD UI is opened in a browser with `kubectl port-forward`.

Docker Desktop must be running before creating the Kind cluster. Docker Desktop's built-in Kubernetes feature is optional and should not be confused with the Kind cluster used by this repository.

## Connect Lens To Kind

1. Create the cluster with `.\scripts\create-cluster.ps1` on Windows or `./scripts/create-cluster.sh` on Git Bash/Linux/macOS.
2. Select the context with `kubectl config use-context kind-cicd-gitops-demo`.
3. Open Lens.
4. Go to Catalog -> Clusters.
5. Add or select `kind-cicd-gitops-demo`.
6. Confirm Nodes shows one control-plane node and two worker nodes.

| Goal | Lens location | kubectl equivalent |
|---|---|---|
| Connect to cluster | Catalog -> Clusters -> add/select `kind-cicd-gitops-demo` | `kubectl config use-context kind-cicd-gitops-demo` |
| See nodes | Cluster -> Nodes | `kubectl get nodes -o wide` |
| See namespaces | Cluster -> Namespaces | `kubectl get namespaces` |
| See deployments | Workloads -> Deployments | `kubectl get deployments -n si-demo-local` |
| See ReplicaSets | Workloads -> Replica Sets | `kubectl get rs -n si-demo-local` |
| See pods | Workloads -> Pods | `kubectl get pods -n si-demo-local -o wide` |
| See services | Network -> Services | `kubectl get svc -n si-demo-local` |
| See pod events | Pod -> Events tab | `kubectl describe pod <pod> -n si-demo-local` |
| See logs | Pod -> Logs tab | `kubectl logs <pod> -n si-demo-local` |
| See image pull status | Pod details -> Containers and Events | `kubectl describe pod <pod> -n si-demo-local` |
| See readiness | Pod list Ready column and Pod conditions | `kubectl get pods -n si-demo-local` |
| See restarts | Pod list Restarts column | `kubectl get pods -n si-demo-local` |
| Watch rolling update | Deployment and Replica Sets views | `kubectl rollout status deployment/sonali-intellect-demo -n si-demo-local` |
| Observe Argo CD resources | Namespaces `argocd` and `si-demo-local` | `kubectl get pods -n argocd` |
| Find ImagePullBackOff | Pods view status column and Events tab | `kubectl get pods -n si-demo-local` |
| Find probe failures | Pod Events and Logs tabs | `kubectl describe pod <pod> -n si-demo-local` |

Recommended live flow:

1. Select the Kind cluster.
2. Show Nodes to confirm one control-plane and two workers.
3. Show Namespaces and point out `argocd` and `si-demo-local`.
4. Open Deployments, then ReplicaSets, then Pods.
5. Open a Pod and show Events, Logs, container image, readiness, liveness, and restart count.
6. During a release, keep Deployments and Pods visible so the class can watch the rolling update.

## Open Argo CD UI

Run this in a terminal and keep it open:

```bash
kubectl -n argocd port-forward svc/argocd-server 8081:443
```

Open `https://localhost:8081` in a browser. Use username `admin`.

Password on Git Bash, Linux, or macOS:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
```

Password on Windows PowerShell:

```powershell
[Text.Encoding]::UTF8.GetString(
  [Convert]::FromBase64String(
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
  )
)
```
