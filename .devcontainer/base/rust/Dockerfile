FROM mcr.microsoft.com/devcontainers/rust:1-bullseye

# Install additional OS packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        git-core \
        curl \
        gpg \
        openssh-client \
        vim \
        build-essential \
        pkg-config \
        libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Rust tools
RUN rustup component add \
        rustfmt \
        clippy \
        rust-analyzer \
        rust-src \
    && cargo install \
        cargo-audit \
        cargo-edit \
        cargo-watch \
        cargo-tarpaulin \
        cargo-deny \
        cargo-outdated \
        just

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

# Setup environment for the non-root user
USER $USERNAME
ENV PATH="/home/$USERNAME/.cargo/bin:${PATH}"

# Configure Rust for better security
ENV RUSTFLAGS="-C target-feature=+crt-static -D warnings"
ENV CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse

# Setup working directory
WORKDIR /workspace

# Label the image
LABEL org.opencontainers.image.source=https://github.com/tzervas/perihelion-templates
LABEL org.opencontainers.image.description="Base Rust development container image for Perihelion templates"
LABEL org.opencontainers.image.licenses=MIT
