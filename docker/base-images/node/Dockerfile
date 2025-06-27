# syntax=docker/dockerfile:1.4

# Base build stage
FROM node:20-slim as build-base

# Build arguments
ARG NODE_VERSION=20
ARG DEBIAN_FRONTEND=noninteractive
ARG APP_USER=appuser
ARG APP_GROUP=appgroup
ARG APP_ROOT=/app
ARG APP_UID=10001
ARG APP_GID=10001

# Security: Update base system and install security packages
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
        tini \
        && \
    # Create non-root user
    groupadd -g ${APP_GID} ${APP_GROUP} && \
    useradd -u ${APP_UID} -g ${APP_GROUP} -s /bin/bash -m ${APP_USER} && \
    # Create app directory and set permissions
    mkdir -p ${APP_ROOT} && \
    chown -R ${APP_USER}:${APP_GROUP} ${APP_ROOT} && \
    # Set npm to use exact versions
    npm config set save-exact=true && \
    # Cleanup
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR ${APP_ROOT}

# Development stage with build tools
FROM build-base as development

# Install development dependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        procps \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Development Node.js packages
RUN npm install -g \
        typescript \
        @types/node \
        ts-node \
        eslint \
        prettier \
        vitest \
        c8 \
        && \
    npm cache clean --force

# Production stage
FROM build-base as production

# Set environment variables
ENV NODE_ENV=production \
    NPM_CONFIG_LOGLEVEL=warn \
    NPM_CONFIG_COLOR=false \
    NODE_OPTIONS="--max-old-space-size=4096"

# Install PM2 globally
RUN npm install -g pm2 && \
    npm cache clean --force

# Switch to non-root user
USER ${APP_USER}:${APP_GROUP}

# Set secure file permissions
RUN umask 027

# Set the entrypoint to Tini
ENTRYPOINT ["/usr/bin/tini", "--"]

# Default command
CMD ["node"]

# Labels
LABEL org.opencontainers.image.title="Node.js Base Image" \
      org.opencontainers.image.description="Secure Node.js base image with PM2" \
      org.opencontainers.image.vendor="Tyler Zervas" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.base.name="node:20-slim"
