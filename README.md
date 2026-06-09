# Infrastructure Environment – PROD

This repository contains the **PROD** (production) environment configuration for applications managed via GitOps.

## Structure

| Path | Description |
|------|-------------|
| `values/devops-project/values.yaml` | Application values for PROD |
| `k8s/devops-project/` | Kubernetes manifests for PROD (Deployment, Service, NetworkPolicy) |
| `k8s/adrian-java-app/` | Rollout (canary), Service, HPA, PDB, NetworkPolicy |

> **Security:** All deployments include hardened `securityContext` (runAsNonRoot, readOnlyRootFilesystem, drop ALL capabilities) and startup/readiness/liveness probes against Spring Actuator.

---

## Canary Deployments (adrian-java-app)

`adrian-java-app` is deployed as an Argo Rollouts **Rollout** with a canary strategy:
**50% traffic → 60s pause → full rollout**.

- The manifest intentionally keeps the filename `k8s/adrian-java-app/deployment.yaml`
  so the promotion workflow can still rewrite the `image:` line by file path.
- Requires the `argo-rollouts` controller (installed by `platform-apps` app-of-apps on PROD).
- Scaling: HPA (2–4 replicas, CPU 80%); availability: PodDisruptionBudget (`minAvailable: 1`).

Watch a rollout:

```bash
kubectl argo rollouts get rollout adrian-java-app -n environment-prod --watch
```

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
