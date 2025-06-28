FROM ghcr.io/tzervas/perihelion-templates/rust-dev-base:latest

# Install additional web service specific tools
RUN cargo install \
    sqlx-cli \
    diesel-cli \
    sea-orm-cli \
    cargo-watch \
    cargo-generate

# Install database clients for development
USER root
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        postgresql-client \
        redis-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
USER vscode

# Configure additional security measures for web services
ENV RUSTFLAGS="${RUSTFLAGS} -C target-cpu=native"
ENV RUST_LOG="info"
ENV RUST_BACKTRACE=1
ENV CARGO_BUILD_TARGET_DIR=/workspace/target

# Label the image with web service specific metadata
LABEL org.opencontainers.image.description="Rust web service development container"
