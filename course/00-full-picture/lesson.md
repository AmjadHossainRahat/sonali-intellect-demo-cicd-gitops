# Lesson 00 - Full CI/CD And GitOps Picture

Problem: learners often see CI, registry, Kubernetes, and GitOps as disconnected tools.
Manual failure: ad hoc builds and manual deployment hide who changed what and where it is running.
Best-practice solution: use GitHub Actions for validation and artifact creation, Harbor for immutable images, Git for desired state, Argo CD for pull-based reconciliation, and Lens/kubectl for runtime observation.
Files: `README.md`, `ARCHITECTURE.md`, `diagrams/full-flow.mmd`, `docs/observation-guide.md`.
Action: show the repository layout in VS Code.
Observe: VS Code and the full-flow diagram.
Success: the class can describe Developer -> GitHub -> Actions -> Harbor -> GitOps -> Argo CD -> Kind -> Lens/kubectl.
Troubleshooting: no live failure; deeper references are in `docs/troubleshooting-guide.md`.

