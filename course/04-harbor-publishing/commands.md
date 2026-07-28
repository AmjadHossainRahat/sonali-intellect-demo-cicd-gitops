# Commands

Windows PowerShell:

```powershell
$env:HARBOR_REGISTRY = "demo.goharbor.io"
$env:HARBOR_PROJECT = "si_demo_harbor"
$env:HARBOR_USERNAME = 'robot$cluster-pull'
$env:HARBOR_PASSWORD = "<robot-token>"
.\scripts\create-registry-secret.ps1
```

Git Bash/Linux/macOS:

```bash
export HARBOR_REGISTRY=demo.goharbor.io
export HARBOR_PROJECT=si_demo_harbor
export HARBOR_USERNAME='robot$cluster-pull'
export HARBOR_PASSWORD='<robot-token>'
./scripts/create-registry-secret.sh
```
