# syntax=docker/dockerfile:1.4

# Base build stage
FROM python:3.12-slim-bookworm as build-base

# Build arguments
ARG PYTHON_VERSION=3.12
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
        build-essential \
        git \
        procps \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Development Python packages
RUN --mount=type=cache,target=/root/.cache/pip \
    python -m pip install --upgrade pip && \
    pip install \
        black \
        flake8 \
        isort \
        mypy \
        poetry \
        pytest \
        pytest-cov

# Production stage
FROM build-base as production

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONPATH=${APP_ROOT} \
    PATH="${APP_ROOT}/.local/bin:${PATH}" \
    POETRY_VERSION=1.7.1 \
    POETRY_HOME="/opt/poetry" \
    POETRY_NO_INTERACTION=1

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    ln -s /opt/poetry/bin/poetry /usr/local/bin/poetry

# Switch to non-root user
USER ${APP_USER}:${APP_GROUP}

# Set secure file permissions
RUN umask 027

# Set the entrypoint to Tini
ENTRYPOINT ["/usr/bin/tini", "--"]

# Default command
CMD ["python3"]

# Labels
LABEL org.opencontainers.image.title="Python Base Image" \
      org.opencontainers.image.description="Secure Python base image with Poetry" \
      org.opencontainers.image.vendor="Tyler Zervas" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.base.name="python:3.12-slim-bookworm"
