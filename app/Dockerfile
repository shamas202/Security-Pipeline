# ─── Stage 1: Build / dependency install ─────────────────────────────────────
FROM node:20-slim AS builder

LABEL org.opencontainers.image.source="https://github.com/your-org/devsecops-pipeline"
LABEL org.opencontainers.image.description="DevSecOps hardened Node.js API"
LABEL org.opencontainers.image.licenses="MIT"

WORKDIR /build

# Copy package files first for layer caching
COPY package.json package-lock.json ./

# Install production deps only; disable scripts to prevent supply-chain attacks
RUN npm ci --omit=dev --ignore-scripts

# ─── Stage 2: Production runtime ─────────────────────────────────────────────
FROM node:20-slim AS runtime

# Metadata
LABEL org.opencontainers.image.source="https://github.com/your-org/devsecops-pipeline"
LABEL org.opencontainers.image.description="DevSecOps hardened Node.js API"
LABEL org.opencontainers.image.licenses="MIT"

# Security hardening
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends dumb-init && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # Remove SUID/SGID binaries
    find / -xdev \( -perm -4000 -o -perm -2000 \) -exec chmod ug-s {} + 2>/dev/null || true

WORKDIR /app

# Copy production node_modules from builder stage
COPY --from=builder --chown=node:node /build/node_modules ./node_modules

# Copy application source
COPY --chown=node:node server.js ./

# Switch to non-root user
USER node

# Expose port
EXPOSE 3000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/healthz', (r) => { process.exit(r.statusCode === 200 ? 0 : 1) })"

# Use dumb-init to handle signals correctly
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "server.js"]
# Iteration 1: trivial update
# Iteration 2: trivial update
# Iteration 3: trivial update
# Iteration 4: trivial update
# Iteration 5: trivial update
# Iteration 6: trivial update
