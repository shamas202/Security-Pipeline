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
