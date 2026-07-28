# Local Overlay

The local overlay deploys the application into namespace `si-demo-local` and replaces the base image with an immutable digest reference.

Render before applying:

```bash
kubectl kustomize kubernetes/overlays/local
kubectl apply --dry-run=client -k kubernetes/overlays/local
```

