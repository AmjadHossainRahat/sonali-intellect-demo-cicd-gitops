# Commands

Windows PowerShell:

```powershell
.\scripts\failures\break-unit-test.ps1
.\scripts\recovery\restore-unit-test.ps1
.\scripts\failures\break-image-pull.ps1
.\scripts\recovery\restore-image-pull.ps1
.\scripts\failures\break-readiness-probe.ps1
.\scripts\recovery\restore-readiness-probe.ps1
.\scripts\failures\create-argocd-drift.ps1
.\scripts\recovery\revert-drift.ps1
```

Git Bash/Linux/macOS:

```bash
./scripts/failures/break-unit-test.sh
./scripts/recovery/restore-unit-test.sh
./scripts/failures/break-image-pull.sh
./scripts/recovery/restore-image-pull.sh
./scripts/failures/break-readiness-probe.sh
./scripts/recovery/restore-readiness-probe.sh
./scripts/failures/create-argocd-drift.sh
./scripts/recovery/revert-drift.sh
```
