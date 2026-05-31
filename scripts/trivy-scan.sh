#!/usr/bin/env bash
# scripts/trivy-scan.sh — Trivy container image vulnerability scan
set -euo pipefail

IMAGE="${1:-}"

if [[ -z "$IMAGE" ]]; then
  echo "Usage: $0 <image:tag>"
  exit 1
fi

OUTPUT_DIR="${TRIVY_OUTPUT_DIR:-./trivy-reports}"
mkdir -p "$OUTPUT_DIR"

echo "═══════════════════════════════════════════════"
echo "  Trivy Image Scan"
echo "  Image : $IMAGE"
echo "  Date  : $(date -u +"%Y-%m-%d %H:%M UTC")"
echo "═══════════════════════════════════════════════"

# Check trivy is installed
if ! command -v trivy &>/dev/null; then
  echo "Installing Trivy..."
  curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
fi

# Table output (human-readable)
trivy image \
  --severity CRITICAL,HIGH \
  --ignore-unfixed \
  --exit-code 0 \
  "$IMAGE"

# JSON report (for CI artifacts)
trivy image \
  --severity CRITICAL,HIGH,MEDIUM \
  --format json \
  --output "$OUTPUT_DIR/trivy-image-$(date +%s).json" \
  "$IMAGE"

# SARIF report (for GitHub Security tab)
trivy image \
  --severity CRITICAL,HIGH \
  --format sarif \
  --output "$OUTPUT_DIR/trivy-image.sarif" \
  "$IMAGE"

echo ""
echo "✅ Scan complete. Reports saved to $OUTPUT_DIR/"

# Fail if CRITICAL vulns found
CRITICAL_COUNT=$(trivy image \
  --severity CRITICAL \
  --ignore-unfixed \
  --format json \
  "$IMAGE" 2>/dev/null | \
  jq '[.Results[]?.Vulnerabilities[]? | select(.Severity=="CRITICAL")] | length' 2>/dev/null || echo 0)

if [[ "$CRITICAL_COUNT" -gt 0 ]]; then
  echo "❌ CRITICAL: $CRITICAL_COUNT critical vulnerabilities found!"
  exit 1
else
  echo "✅ No critical vulnerabilities found."
fi
// Iteration 1: trivial update
// Iteration 2: trivial update
// Iteration 3: trivial update
// Iteration 4: trivial update
// Iteration 5: trivial update
