# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.x     | ✅ Yes    |
| < 1.0   | ❌ No     |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please follow responsible disclosure:

1. **Do NOT open a public GitHub issue.**
2. Email **security@example.com** with:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested remediation (if any)
3. You will receive an acknowledgement within **48 hours**.
4. We aim to release a fix within **14 days** for critical issues.

## Security Controls

This project enforces the following controls:

- All containers run as non-root (UID 1000)
- Read-only root filesystem in all pods
- No privilege escalation (`allowPrivilegeEscalation: false`)
- All Linux capabilities dropped
- Seccomp RuntimeDefault profile applied
- NetworkPolicy: default deny-all, allowlist only required traffic
- RBAC: least-privilege service accounts
- OWASP-recommended HTTP security headers (Helmet.js)
- Rate limiting on all endpoints
- Input validation and sanitization
- No hardcoded secrets (GitHub Secrets + OIDC)
- Dependency scanning on every commit
- Container vulnerability scanning on every build
- Weekly CIS Kubernetes Benchmark (kube-bench)

## Threat Model

| Threat | Mitigation |
|--------|------------|
| Compromised dependency | npm audit + Trivy + Dependabot |
| Container escape | Non-root + seccomp + read-only FS |
| Lateral movement | NetworkPolicy deny-all |
| Privilege escalation | RBAC + no privileged containers |
| Secret leakage | GitLeaks + no env secrets in code |
| XSS / injection | Helmet CSP + input sanitization |
| DDoS / abuse | Rate limiting per IP |
| Vulnerable base image | Trivy + Docker Scout weekly |

# Update SECURITY.md: Add reporting details

# Update SECURITY.md: Add security policy
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
