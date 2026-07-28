# GitOps Release Model

This lab separates artifact creation from deployment.

1. A pull request validates code.
2. A merge to `main` builds and publishes an image to Harbor.
3. The release workflow records the image digest.
4. The promotion workflow updates `kubernetes/overlays/local/kustomization.yaml`.
5. The promotion change is reviewed as a pull request by default.
6. Argo CD sees the Git change and reconciles the cluster.

## Training-Fast Mode

The promotion workflow can commit directly when `mode=training-fast`. This is useful for a classroom demonstration when time is limited.

## Production-Like Mode

The default is to create a promotion pull request. The instructor merges that PR after review. Argo CD then reads the merged desired state.

## Why Digest-Based Deployment

The overlay should point to:

```text
registry/project/repository@sha256:<digest>
```

This avoids mutable tag surprises and lets learners compare the Harbor digest with the deployed pod image.

