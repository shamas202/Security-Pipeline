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
// Iteration 6: trivial update
// Iteration 7: trivial update
// Iteration 8: trivial update
// Iteration 9: trivial update
// Iteration 10: trivial update
// Iteration 11: trivial update
// Iteration 12: trivial update
// Iteration 13: trivial update
// Iteration 14: trivial update
// Iteration 15: trivial update
// Iteration 16: trivial update
// Iteration 17: trivial update
// Iteration 18: trivial update
// Iteration 19: trivial update
// Iteration 20: trivial update
// Iteration 21: trivial update
// Iteration 22: trivial update
// Iteration 23: trivial update
// Iteration 24: trivial update
// Iteration 25: trivial update
// Iteration 26: trivial update
// Iteration 27: trivial update
// Iteration 28: trivial update
// Iteration 29: trivial update
// Iteration 30: trivial update
// Iteration 31: trivial update
// Iteration 32: trivial update
// Iteration 33: trivial update
// Iteration 34: trivial update
// Iteration 35: trivial update
// Iteration 36: trivial update
// Iteration 37: trivial update
// Iteration 38: trivial update
// Iteration 39: trivial update
// Iteration 40: trivial update
// Iteration 41: trivial update
// Iteration 42: trivial update
// Iteration 43: trivial update
// Iteration 44: trivial update
// Iteration 45: trivial update
// Iteration 46: trivial update
// Iteration 47: trivial update
// Iteration 48: trivial update
// Iteration 49: trivial update
// Iteration 50: trivial update
// Iteration 51: trivial update
// Iteration 52: trivial update
// Iteration 53: trivial update
// Iteration 54: trivial update
// Iteration 55: trivial update
// Iteration 56: trivial update
// Iteration 57: trivial update
// Iteration 58: trivial update
// Iteration 59: trivial update
// Iteration 60: trivial update
// Iteration 61: trivial update
// Iteration 62: trivial update
// Iteration 63: trivial update
// Iteration 64: trivial update
// Iteration 65: trivial update
// Iteration 66: trivial update
// Iteration 67: trivial update
// Iteration 68: trivial update
// Iteration 69: trivial update
// Iteration 70: trivial update
// Iteration 71: trivial update
// Iteration 72: trivial update
// Iteration 73: trivial update
// Iteration 74: trivial update
// Iteration 75: trivial update
// Iteration 76: trivial update
// Iteration 77: trivial update
// Iteration 78: trivial update
// Iteration 79: trivial update
// Iteration 80: trivial update
// Iteration 81: trivial update
// Iteration 82: trivial update
// Iteration 83: trivial update
// Iteration 84: trivial update
// Iteration 85: trivial update
// Iteration 86: trivial update
// Iteration 87: trivial update
// Iteration 88: trivial update
// Iteration 89: trivial update
// Iteration 90: trivial update
// Iteration 91: trivial update
// Iteration 92: trivial update
// Iteration 93: trivial update
// Iteration 94: trivial update
// Iteration 95: trivial update
// Iteration 96: trivial update
// Iteration 97: trivial update
// Iteration 98: trivial update
// Iteration 99: trivial update
// Iteration 100: trivial update
// Iteration 101: trivial update
// Iteration 102: trivial update
// Iteration 103: trivial update
// Iteration 104: trivial update
// Iteration 105: trivial update
// Iteration 106: trivial update
// Iteration 107: trivial update
// Iteration 108: trivial update
// Iteration 109: trivial update
// Iteration 110: trivial update
// Iteration 111: trivial update
// Iteration 112: trivial update
// Iteration 113: trivial update
// Iteration 114: trivial update
// Iteration 115: trivial update
// Iteration 116: trivial update
// Iteration 117: trivial update
// Iteration 118: trivial update
// Iteration 119: trivial update
// Iteration 120: trivial update
// Iteration 121: trivial update
// Iteration 122: trivial update
// Iteration 123: trivial update
// Iteration 124: trivial update
// Iteration 125: trivial update
// Iteration 126: trivial update
// Iteration 127: trivial update
// Iteration 128: trivial update
// Iteration 129: trivial update
// Iteration 130: trivial update
// Iteration 131: trivial update
// Iteration 132: trivial update
// Iteration 133: trivial update
// Iteration 134: trivial update
// Iteration 135: trivial update
// Iteration 136: trivial update
// Iteration 137: trivial update
// Iteration 138: trivial update
// Iteration 139: trivial update
// Iteration 140: trivial update
