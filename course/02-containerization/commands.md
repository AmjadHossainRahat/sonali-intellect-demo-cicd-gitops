# Commands

```bash
docker build -t sonali-intellect-demo-cicd-gitops:local .
docker run --rm -p 8080:8080 sonali-intellect-demo-cicd-gitops:local
curl http://localhost:8080/api/version
docker inspect sonali-intellect-demo-cicd-gitops:local --format '{{.Config.User}}'
```

