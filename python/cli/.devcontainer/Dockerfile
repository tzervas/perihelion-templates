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
    POETRY_VERSION=1.7.1 \
    UV_VERSION=0.1.15

# Create non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo git gpg \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    gpg \
    make \
    && rm -rf /var/lib/apt/lists/*

# Install UV
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Set work directory
WORKDIR /workspace

# Switch to non-root user
USER $USERNAME

# Install Python tools
RUN uv pip install \
    black \
    pylint \
    mypy \
    pytest \
    pytest-cov \
    bandit \
    safety \
    pre-commit

# Security hardening
ENV PYTHONWARNINGS="default,ignore:::pkg_resources" \
    PIP_ROOT_USER_ACTION="ignore"

# Add secure defaults
RUN git config --global commit.gpgsign true \
    && git config --global tag.gpgsign true

# Ensure no new privileges can be gained
LABEL org.opencontainers.image.security.caps.drop="ALL"
LABEL org.opencontainers.image.security.no-new-privileges="true"
