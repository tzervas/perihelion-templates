FROM mcr.microsoft.com/devcontainers/javascript-node:21-bullseye

# Install additional OS packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        git-core \
        curl \
        gpg \
        openssh-client \
        vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

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

# Switch to non-root user
USER $USERNAME

# Install global Node.js packages
RUN npm install -g \
        npm@latest \
        pnpm \
        typescript \
        ts-node \
        @types/node \
        eslint \
        prettier \
        jest \
        nodemon \
        typeorm \
        @nestjs/cli \
        nx \
        snyk

# Configure npm for better security
RUN npm config set audit true \
    && npm config set fund false \
    && npm config set ignore-scripts true \
    && npm config set package-lock true \
    && npm config set registry https://registry.npmjs.org/

# Setup working directory
WORKDIR /workspace

# Label the image
LABEL org.opencontainers.image.source=https://github.com/tzervas/perihelion-templates
LABEL org.opencontainers.image.description="Base Node.js development container image for Perihelion templates"
LABEL org.opencontainers.image.licenses=MIT
