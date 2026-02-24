# Infrastructure Environment – PROD

This repository contains the **PROD** (production) environment configuration for applications managed via GitOps.

## Structure

| Path | Description |
|------|-------------|
| `values/devops-project/values.yaml` | Application values for PROD |
| `k8s/devops-project/` | Kubernetes manifests for PROD |
| `k8s/adrian-java-app/` | Kubernetes manifests for adrian-java-app |

> **Security:** All deployments include hardened `securityContext` (runAsNonRoot, readOnlyRootFilesystem, drop ALL capabilities).

---

## GitOps Process

After merging a PR to this repository:

1. ArgoCD detects the new commit
2. Auto-sync is triggered
3. New application version is rolled out to `environment-prod` namespace

---

## Manifest Validation

The `cd-devops-project-prod` workflow automatically validates Kubernetes manifest YAML syntax before deployment.

> **Note:** Workflow logic is defined in [ci-cd-templates/validate-manifests.yml](https://github.com/Adrian-CICD-Project/ci-cd-templates/blob/main/.github/workflows/validate-manifests.yml)

---

## Related Repositories

| Repository | Purpose |
|------------|---------|
| `infrastructure-env-test` | Promotion source |
| `ci-cd-templates` | Centralized CI/CD workflow templates |
| `devops-project` | Application source code |
