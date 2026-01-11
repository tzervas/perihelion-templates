FROM mcr.microsoft.com/devcontainers/python:3.12-bullseye

# Install additional OS packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        git-core \
        curl \
        gpg \
        openssh-client \
        sqlite3 \
        vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python tools
RUN pip install --no-cache-dir \
    uv \
    black \
    flake8 \
    mypy \
    pytest \
    pytest-cov \
    pre-commit

# Set up Git configuration for GPG signing
RUN git config --system commit.gpgsign true \
    && git config --system gpg.program gpg

# Create non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Setup Python environment for the non-root user
USER $USERNAME
ENV PATH="/home/$USERNAME/.local/bin:${PATH}"

# Setup working directory
WORKDIR /workspace

# Label the image
LABEL org.opencontainers.image.source=https://github.com/tzervas/perihelion-templates
LABEL org.opencontainers.image.description="Base Python development container image for Perihelion templates"
LABEL org.opencontainers.image.licenses=MIT
