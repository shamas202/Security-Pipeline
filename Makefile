.PHONY: build test lint scan deploy-local clean help

REGISTRY    ?= ghcr.io
IMAGE_NAME  ?= your-org/devsecops-pipeline
IMAGE_TAG   ?= $(shell git rev-parse --short HEAD)
FULL_IMAGE  := $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)
NAMESPACE   ?= development
CLUSTER     ?= kind-devsecops

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ─── App ──────────────────────────────────────────────────────────────────────
install: ## Install Node.js dependencies
	cd app && npm ci

build: ## Build Docker image
	docker build \
	  --label "org.opencontainers.image.revision=$(shell git rev-parse HEAD)" \
	  --label "org.opencontainers.image.created=$(shell date -u +%Y-%m-%dT%H:%M:%SZ)" \
	  -t $(FULL_IMAGE) \
	  -t $(REGISTRY)/$(IMAGE_NAME):latest \
	  ./app
	@echo "✅ Built $(FULL_IMAGE)"

test: ## Run unit tests with coverage
	cd app && npm test

lint: ## Run ESLint
	cd app && npm run lint

audit: ## Run npm security audit
	cd app && npm audit --audit-level=high

# ─── Security Scans ───────────────────────────────────────────────────────────
scan: scan-image scan-iac ## Run all security scans

scan-image: ## Trivy scan on Docker image
	@echo "🔍 Scanning image $(FULL_IMAGE)..."
	bash scripts/trivy-scan.sh $(FULL_IMAGE)

scan-iac: ## Trivy and Checkov scan on IaC
	@echo "🔍 Scanning Kubernetes manifests..."
	trivy config kubernetes/
	checkov -d kubernetes/ --framework kubernetes --compact

scan-secrets: ## GitLeaks secret scan
	gitleaks detect --source . --verbose

# ─── Local Kubernetes ──────────────────────────────────────────────────────────
cluster-up: ## Create local kind cluster
	kind create cluster --name devsecops --config - <<EOF
	kind: Cluster
	apiVersion: kind.x-k8s.io/v1alpha4
	nodes:
	  - role: control-plane
	  - role: worker
	EOF
	@echo "✅ Kind cluster ready"

cluster-down: ## Delete local kind cluster
	kind delete cluster --name devsecops

load-image: build ## Load Docker image into kind cluster
	kind load docker-image $(FULL_IMAGE) --name devsecops
	kind load docker-image $(REGISTRY)/$(IMAGE_NAME):latest --name devsecops

deploy-local: load-image ## Deploy to local kind cluster via Helm
	kubectl create namespace $(NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -
	helm upgrade --install devsecops-app helm/devsecops-app \
	  --namespace $(NAMESPACE) \
	  --set image.repository=$(REGISTRY)/$(IMAGE_NAME) \
	  --set image.tag=$(IMAGE_TAG) \
	  --set image.pullPolicy=Never \
	  --wait --timeout 3m
	@echo "✅ Deployed to local cluster"

port-forward: ## Forward port 3000 to local machine
	kubectl port-forward -n $(NAMESPACE) svc/devsecops-app 3000:80

kube-bench: ## Run kube-bench against local cluster
	bash scripts/kube-bench.sh

# ─── Cleanup ──────────────────────────────────────────────────────────────────
clean: ## Remove build artifacts
	rm -rf app/coverage app/node_modules
	docker rmi $(FULL_IMAGE) $(REGISTRY)/$(IMAGE_NAME):latest 2>/dev/null || true
	@echo "✅ Cleaned"
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
