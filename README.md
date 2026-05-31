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
# Iteration 43: trivial update
# Iteration 44: trivial update
# Iteration 45: trivial update
# Iteration 46: trivial update
# Iteration 47: trivial update
# Iteration 48: trivial update
# Iteration 49: trivial update
# Iteration 50: trivial update
# Iteration 51: trivial update
# Iteration 52: trivial update
# Iteration 53: trivial update
# Iteration 54: trivial update
# Iteration 55: trivial update
# Iteration 56: trivial update
# Iteration 57: trivial update
# Iteration 58: trivial update
# Iteration 59: trivial update
# Iteration 60: trivial update
# Iteration 61: trivial update
# Iteration 62: trivial update
# Iteration 63: trivial update
# Iteration 64: trivial update
# Iteration 65: trivial update
# Iteration 66: trivial update
# Iteration 67: trivial update
# Iteration 68: trivial update
# Iteration 69: trivial update
# Iteration 70: trivial update
# Iteration 71: trivial update
# Iteration 72: trivial update
# Iteration 73: trivial update
# Iteration 74: trivial update
# Iteration 75: trivial update
# Iteration 76: trivial update
# Iteration 77: trivial update
# Iteration 78: trivial update
# Iteration 79: trivial update
# Iteration 80: trivial update
# Iteration 81: trivial update
# Iteration 82: trivial update
# Iteration 83: trivial update
# Iteration 84: trivial update
# Iteration 85: trivial update
# Iteration 86: trivial update
# Iteration 87: trivial update
# Iteration 88: trivial update
# Iteration 89: trivial update
# Iteration 90: trivial update
# Iteration 91: trivial update
# Iteration 92: trivial update
# Iteration 93: trivial update
# Iteration 94: trivial update
# Iteration 95: trivial update
# Iteration 96: trivial update
# Iteration 97: trivial update
# Iteration 98: trivial update
# Iteration 99: trivial update
# Iteration 100: trivial update
# Iteration 101: trivial update
# Iteration 102: trivial update
# Iteration 103: trivial update
# Iteration 104: trivial update
# Iteration 105: trivial update
# Iteration 106: trivial update
# Iteration 107: trivial update
# Iteration 108: trivial update
# Iteration 109: trivial update
# Iteration 110: trivial update
# Iteration 111: trivial update
# Iteration 112: trivial update
# Iteration 113: trivial update
# Iteration 114: trivial update
# Iteration 115: trivial update
# Iteration 116: trivial update
# Iteration 117: trivial update
# Iteration 118: trivial update
# Iteration 119: trivial update
# Iteration 120: trivial update
# Iteration 121: trivial update
# Iteration 122: trivial update
# Iteration 123: trivial update
# Iteration 124: trivial update
# Iteration 125: trivial update
# Iteration 126: trivial update
# Iteration 127: trivial update
# Iteration 128: trivial update
# Iteration 129: trivial update
# Iteration 130: trivial update
# Iteration 131: trivial update
# Iteration 132: trivial update
# Iteration 133: trivial update
# Iteration 134: trivial update
# Iteration 135: trivial update
# Iteration 136: trivial update
# Iteration 137: trivial update
# Iteration 138: trivial update
# Iteration 139: trivial update
# Iteration 140: trivial update
# Iteration 141: trivial update
# Iteration 142: trivial update
# Iteration 143: trivial update
# Iteration 144: trivial update
# Iteration 145: trivial update
# Iteration 146: trivial update
# Iteration 147: trivial update
# Iteration 148: trivial update
# Iteration 149: trivial update
# Iteration 150: trivial update
# Iteration 151: trivial update
# Iteration 152: trivial update
# Iteration 153: trivial update
# Iteration 154: trivial update
# Iteration 155: trivial update
# Iteration 156: trivial update
# Iteration 157: trivial update
# Iteration 158: trivial update
# Iteration 159: trivial update
# Iteration 160: trivial update
# Iteration 161: trivial update
# Iteration 162: trivial update
# Iteration 163: trivial update
# Iteration 164: trivial update
# Iteration 165: trivial update
# Iteration 166: trivial update
# Iteration 167: trivial update
# Iteration 168: trivial update
# Iteration 169: trivial update
# Iteration 170: trivial update
# Iteration 171: trivial update
# Iteration 172: trivial update
# Iteration 173: trivial update
# Iteration 174: trivial update
# Iteration 175: trivial update
# Iteration 176: trivial update
# Iteration 177: trivial update
# Iteration 178: trivial update
# Iteration 179: trivial update
# Iteration 180: trivial update
# Iteration 181: trivial update
# Iteration 182: trivial update
# Iteration 183: trivial update
# Iteration 184: trivial update
# Iteration 185: trivial update
# Iteration 186: trivial update
# Iteration 187: trivial update
# Iteration 188: trivial update
# Iteration 189: trivial update
# Iteration 190: trivial update
