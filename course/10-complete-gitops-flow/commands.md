# Commands

```bash
kubectl get deployment sonali-intellect-demo -n si-demo-local -o jsonpath='{.spec.template.spec.containers[0].image}'
kubectl rollout status deployment/sonali-intellect-demo -n si-demo-local
kubectl get pods -n si-demo-local -o wide
kubectl port-forward svc/sonali-intellect-demo -n si-demo-local 8080:80
curl http://localhost:8080/api/build-info
```

