#!/usr/bin/env bash
# scripts/kube-bench.sh — CIS Kubernetes Benchmark runner
set -euo pipefail

OUTPUT_FILE="${KUBE_BENCH_OUTPUT:-kube-bench-results.json}"
BENCHMARK="${KUBE_BENCH_BENCHMARK:-eks}"

echo "═══════════════════════════════════════════════"
echo "  Kube-bench CIS Benchmark"
echo "  Target    : $BENCHMARK"
echo "  Date      : $(date -u +"%Y-%m-%d %H:%M UTC")"
echo "═══════════════════════════════════════════════"

if ! kubectl cluster-info &>/dev/null; then
  echo "❌ No Kubernetes cluster accessible. Ensure kubeconfig is configured."
  exit 1
fi

# Run kube-bench as a Job in the cluster
kubectl apply -f - <<EOF
apiVersion: batch/v1
kind: Job
metadata:
  name: kube-bench-$(date +%s)
  namespace: kube-system
spec:
  ttlSecondsAfterFinished: 300
  template:
    spec:
      hostPID: true
      containers:
        - name: kube-bench
          image: aquasec/kube-bench:latest
          command: ["kube-bench", "--benchmark", "$BENCHMARK", "--json"]
          volumeMounts:
            - name: var-lib-etcd
              mountPath: /var/lib/etcd
              readOnly: true
            - name: var-lib-kubelet
              mountPath: /var/lib/kubelet
              readOnly: true
            - name: etc-systemd
              mountPath: /etc/systemd
              readOnly: true
            - name: etc-kubernetes
              mountPath: /etc/kubernetes
              readOnly: true
      restartPolicy: Never
      volumes:
        - name: var-lib-etcd
          hostPath:
            path: /var/lib/etcd
        - name: var-lib-kubelet
          hostPath:
            path: /var/lib/kubelet
        - name: etc-systemd
          hostPath:
            path: /etc/systemd
        - name: etc-kubernetes
          hostPath:
            path: /etc/kubernetes
EOF

# Wait for job completion
echo "Waiting for kube-bench job to complete..."
kubectl wait --for=condition=complete job -l app=kube-bench \
  -n kube-system --timeout=120s 2>/dev/null || \
kubectl wait --for=condition=complete job \
  -n kube-system --timeout=120s -l job-name 2>/dev/null || true

# Collect logs
JOB_POD=$(kubectl get pods -n kube-system -l job-name --sort-by=.metadata.creationTimestamp -o jsonpath='{.items[-1].metadata.name}' 2>/dev/null || echo "")

if [[ -n "$JOB_POD" ]]; then
  kubectl logs -n kube-system "$JOB_POD" > "$OUTPUT_FILE"
  echo "✅ Results saved to $OUTPUT_FILE"

  # Summary
  FAIL_COUNT=$(jq '[.[] | .tests[]?.results[]? | select(.status=="FAIL")] | length' "$OUTPUT_FILE" 2>/dev/null || echo "unknown")
  WARN_COUNT=$(jq '[.[] | .tests[]?.results[]? | select(.status=="WARN")] | length' "$OUTPUT_FILE" 2>/dev/null || echo "unknown")
  PASS_COUNT=$(jq '[.[] | .tests[]?.results[]? | select(.status=="PASS")] | length' "$OUTPUT_FILE" 2>/dev/null || echo "unknown")

  echo ""
  echo "Summary:"
  echo "  PASS: $PASS_COUNT"
  echo "  WARN: $WARN_COUNT"
  echo "  FAIL: $FAIL_COUNT"
else
  echo "⚠️  Could not retrieve job pod logs."
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
// Iteration 141: trivial update
// Iteration 142: trivial update
// Iteration 143: trivial update
// Iteration 144: trivial update
// Iteration 145: trivial update
// Iteration 146: trivial update
// Iteration 147: trivial update
// Iteration 148: trivial update
// Iteration 149: trivial update
// Iteration 150: trivial update
// Iteration 151: trivial update
// Iteration 152: trivial update
// Iteration 153: trivial update
// Iteration 154: trivial update
// Iteration 155: trivial update
// Iteration 156: trivial update
// Iteration 157: trivial update
// Iteration 158: trivial update
// Iteration 159: trivial update
// Iteration 160: trivial update
// Iteration 161: trivial update
// Iteration 162: trivial update
// Iteration 163: trivial update
// Iteration 164: trivial update
// Iteration 165: trivial update
// Iteration 166: trivial update
// Iteration 167: trivial update
// Iteration 168: trivial update
// Iteration 169: trivial update
// Iteration 170: trivial update
// Iteration 171: trivial update
// Iteration 172: trivial update
// Iteration 173: trivial update
// Iteration 174: trivial update
// Iteration 175: trivial update
// Iteration 176: trivial update
// Iteration 177: trivial update
// Iteration 178: trivial update
// Iteration 179: trivial update
// Iteration 180: trivial update
// Iteration 181: trivial update
// Iteration 182: trivial update
// Iteration 183: trivial update
// Iteration 184: trivial update
// Iteration 185: trivial update
// Iteration 186: trivial update
// Iteration 187: trivial update
// Iteration 188: trivial update
// Iteration 189: trivial update
// Iteration 190: trivial update
// Iteration 191: trivial update
// Iteration 192: trivial update
// Iteration 193: trivial update
// Iteration 194: trivial update
// Iteration 195: trivial update
// Iteration 196: trivial update
