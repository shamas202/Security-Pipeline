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
