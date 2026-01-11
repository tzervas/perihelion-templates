FROM mcr.microsoft.com/devcontainers/go:1.22-bullseye

# Install additional OS packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        git-core \
        curl \
        gpg \
        openssh-client \
        vim \
        gcc \
        g++ \
        make \
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

# Install Go tools
RUN go install golang.org/x/tools/gopls@latest \
    && go install golang.org/x/tools/cmd/goimports@latest \
    && go install golang.org/x/lint/golint@latest \
    && go install github.com/go-delve/delve/cmd/dlv@latest \
    && go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest \
    && go install github.com/cosmtrek/air@latest \
    && go install github.com/securego/gosec/v2/cmd/gosec@latest \
    && go install github.com/swaggo/swag/cmd/swag@latest \
    && go install github.com/mgechev/revive@latest

# Configure Go environment
ENV GOPATH=/home/$USERNAME/go
ENV PATH=$GOPATH/bin:$PATH
ENV GO111MODULE=on
ENV CGO_ENABLED=0
ENV GOOS=linux

# Setup working directory
WORKDIR /workspace

# Label the image
LABEL org.opencontainers.image.source=https://github.com/tzervas/perihelion-templates
LABEL org.opencontainers.image.description="Base Go development container image for Perihelion templates"
LABEL org.opencontainers.image.licenses=MIT
