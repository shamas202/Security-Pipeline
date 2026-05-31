# 🔒 devsecops-pipeline

A production-ready DevSecOps CI/CD pipeline demonstrating security-at-every-layer using **GitHub Actions**, **Docker**, **Kubernetes (EKS)**, and **Helm**.

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Developer Workstation                        │
│   git push ──────────────────────────────────────────────────────►  │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     GitHub Actions CI Pipeline                      │
│                                                                     │
│  ┌──────────────────┐  ┌─────────────┐  ┌──────────────────────┐   │
│  │ Static Analysis  │  │ Unit Tests  │  │  Build & Scan Image  │   │
│  │                  │  │             │  │                      │   │
│  │ • ESLint+security│  │ • Jest      │  │ • Multi-stage Docker │   │
│  │ • npm audit      │  │ • Coverage  │  │ • Trivy (SARIF)      │   │
│  │ • Semgrep SAST   │  │ • Thresholds│  │ • Docker Scout       │   │
│  │ • GitLeaks       │  │             │  │ • Push to GHCR       │   │
│  └────────┬─────────┘  └──────┬──────┘  └──────────┬───────────┘   │
│           │                   │                    │               │
│           └───────────────────┼────────────────────┘               │
│                               │                                     │
│  ┌────────────────────────────▼─────────────────────────────────┐  │
│  │               IaC Security (Kubesec + Checkov)               │  │
│  └────────────────────────────┬─────────────────────────────────┘  │
└──────────────────────────────┬──────────────────────────────────────┘
                               │ All stages pass
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                   GitHub Actions Deploy Pipeline                    │
│                                                                     │
│  AWS OIDC Auth ──► EKS kubeconfig ──► Helm upgrade ──► Verify      │
│                                                                     │
│  • Pod security context check (no root containers)                  │
│  • Rollout status verification                                      │
│  • Slack notification on failure                                    │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     Amazon EKS (production)                         │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Namespace: production                                       │   │
│  │                                                             │   │
│  │  NetworkPolicy: deny-all + allow ingress-nginx + DNS only   │   │
│  │  RBAC: least-privilege ServiceAccount                       │   │
│  │                                                             │   │
│  │  Pod: runAsNonRoot | readOnlyRootFilesystem | no privesc    │   │
│  │       resource limits | liveness/readiness probes           │   │
│  └─────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘

Weekly: Trivy FS scan + Dependency Review + Kube-bench ──► SARIF / Artifacts
```

## Security Layers

| Layer | Tool | What it checks |
|-------|------|----------------|
| Code | ESLint + security plugin | Insecure JS patterns |
| Code | Semgrep | OWASP Top 10, Node.js vulns |
| Code | GitLeaks | Hardcoded secrets |
| Dependencies | npm audit | Known CVEs in packages |
| Container | Trivy | OS + library CVEs |
| Container | Docker Scout | CVEs + policy |
| IaC | Kubesec | K8s manifest risk score |
| IaC | Checkov | CIS Kubernetes Benchmark |
| Runtime | Pod SecurityContext | Non-root, no privilege escalation |
| Runtime | NetworkPolicy | Zero-trust networking |
| Cluster | Kube-bench | CIS EKS benchmark (weekly) |

## Prerequisites

- Node.js 20+
- Docker 24+
- kubectl 1.29+
- Helm 3.14+
- kind or minikube (local dev)
- AWS CLI v2 (for EKS deploy)

## Quickstart (Local)

```bash
# 1. Install app dependencies
make install

# 2. Run tests
make test

# 3. Lint
make lint

# 4. Build Docker image
make build

# 5. Scan image
make scan-image

# 6. Create local kind cluster and deploy
make cluster-up
make deploy-local

# 7. Test the API
make port-forward &
curl http://localhost:3000/healthz
curl http://localhost:3000/api/v1/status
```

## GitHub Secrets Required

Set these in your repository **Settings → Secrets and variables → Actions**:

| Secret | Description |
|--------|-------------|
| `AWS_DEPLOY_ROLE_ARN` | IAM role ARN for EKS deploy (OIDC) |
| `AWS_READONLY_ROLE_ARN` | IAM role ARN for kube-bench read-only |
| `SLACK_WEBHOOK_URL` | Slack incoming webhook for notifications |
| `DOCKER_HUB_USER` | Docker Hub username (for Scout) |
| `DOCKER_HUB_TOKEN` | Docker Hub access token (for Scout) |
| `SEMGREP_APP_TOKEN` | Semgrep Cloud token (optional) |
| `GITLEAKS_LICENSE` | GitLeaks license (optional for public repos) |

## AWS OIDC Setup

```bash
# Create OIDC provider for GitHub Actions
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1

# Attach the trust policy to your IAM role (see docs/iam-trust-policy.json)
```

## Project Structure

```
devsecops-pipeline/
├── .github/
│   └── workflows/
│       ├── ci.yml              # CI pipeline (4 stages)
│       ├── deploy.yml          # Deploy to EKS on CI success
│       └── security-scan.yml   # Weekly security audit
├── app/
│   ├── __tests__/
│   │   └── server.test.js      # Jest tests
│   ├── server.js               # Hardened Express API
│   ├── package.json
│   ├── Dockerfile              # Multi-stage, non-root
│   ├── .dockerignore
│   └── .eslintrc.json          # Security-focused ESLint
├── kubernetes/
│   ├── deployment.yaml         # securityContext hardened
│   ├── service.yaml
│   ├── network-policy.yaml     # Default deny-all
│   ├── rbac.yaml               # Least-privilege SA
│   └── kustomization.yaml
├── helm/
│   └── devsecops-app/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── _helpers.tpl
│           ├── deployment.yaml
│           ├── service.yaml
│           └── network-policy.yaml
├── scripts/
│   ├── trivy-scan.sh
│   └── kube-bench.sh
├── Makefile
├── README.md (this file)
└── SECURITY.md
```

## See Also

- [SECURITY.md](./SECURITY.md) — Security policy and responsible disclosure
- [GitHub Security tab](../../security) — SARIF scan results
- [Trivy docs](https://aquasecurity.github.io/trivy)
- [Kubesec](https://kubesec.io)
- [OWASP Node.js Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Nodejs_Security_Cheat_Sheet.html)

# Update README.md: Add Project Goals

# Update README.md: Add How to Run

# Update README.md: Add Contributors

# Update README.md: Add License

# Update README.md: Add Acknowledgments
# Final check
# Iteration 1: trivial update
# Iteration 2: trivial update
# Iteration 3: trivial update
# Iteration 4: trivial update
# Iteration 5: trivial update
# Iteration 6: trivial update
# Iteration 7: trivial update
# Iteration 8: trivial update
# Iteration 9: trivial update
# Iteration 10: trivial update
# Iteration 11: trivial update
# Iteration 12: trivial update
# Iteration 13: trivial update
# Iteration 14: trivial update
# Iteration 15: trivial update
# Iteration 16: trivial update
# Iteration 17: trivial update
# Iteration 18: trivial update
# Iteration 19: trivial update
# Iteration 20: trivial update
# Iteration 21: trivial update
# Iteration 22: trivial update
# Iteration 23: trivial update
# Iteration 24: trivial update
# Iteration 25: trivial update
# Iteration 26: trivial update
# Iteration 27: trivial update
# Iteration 28: trivial update
# Iteration 29: trivial update
# Iteration 30: trivial update
# Iteration 31: trivial update
# Iteration 32: trivial update
# Iteration 33: trivial update
# Iteration 34: trivial update
# Iteration 35: trivial update
# Iteration 36: trivial update
# Iteration 37: trivial update
# Iteration 38: trivial update
# Iteration 39: trivial update
# Iteration 40: trivial update
# Iteration 41: trivial update
# Iteration 42: trivial update
