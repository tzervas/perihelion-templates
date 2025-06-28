# Use Python 3.12 slim as base
FROM python:3.12-slim

# Build arguments
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    UV_VERSION=0.1.15 \
    POETRY_VERSION=1.7.1 \
    PATH="/home/vscode/.local/bin:$PATH"

# Create non-root user and install system dependencies
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y \
        sudo \
        git \
        gpg \
        curl \
        make \
        postgresql-client \
        libpq-dev \
        wget \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && rm -rf /var/lib/apt/lists/*

# Install UV
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Set work directory
WORKDIR /workspace

# Switch to non-root user
USER $USERNAME

# Install Python tools and dependencies
RUN uv pip install \
    fastapi[all] \
    uvicorn[standard] \
    gunicorn \
    sqlalchemy[asyncio] \
    alembic \
    asyncpg \
    redis \
    python-jose[cryptography] \
    passlib[bcrypt] \
    python-multipart \
    prometheus-client \
    opentelemetry-api \
    opentelemetry-sdk \
    opentelemetry-instrumentation-fastapi \
    opentelemetry-exporter-jaeger \
    black \
    pylint \
    mypy \
    pytest \
    pytest-asyncio \
    pytest-cov \
    httpx \
    bandit \
    safety \
    pre-commit

# Security hardening
ENV PYTHONWARNINGS="default,ignore:::pkg_resources" \
    PIP_ROOT_USER_ACTION="ignore"

# Add secure defaults
RUN git config --global commit.gpgsign true \
    && git config --global tag.gpgsign true

# Install dockerize for service dependency management
RUN sudo wget https://github.com/jwilder/dockerize/releases/download/v0.7.0/dockerize-linux-amd64-v0.7.0.tar.gz \
    && sudo tar -C /usr/local/bin -xzvf dockerize-linux-amd64-v0.7.0.tar.gz \
    && sudo rm dockerize-linux-amd64-v0.7.0.tar.gz

# Create log directory
RUN sudo mkdir -p /var/log/app \
    && sudo chown -R $USERNAME:$USERNAME /var/log/app

# Ensure no new privileges can be gained
LABEL org.opencontainers.image.security.caps.drop="ALL"
LABEL org.opencontainers.image.security.no-new-privileges="true"
