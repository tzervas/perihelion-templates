FROM ghcr.io/tzervas/perihelion-templates/rust-dev-base:latest

# Install additional CLI-specific tools
RUN cargo install \
    clap-cargo-generate \
    cargo-release \
    cargo-dist

# Configure additional security measures for CLI applications
ENV RUSTFLAGS="${RUSTFLAGS} -Z panic=abort"
ENV CARGO_BUILD_TARGET_DIR=/workspace/target

# Label the image with CLI-specific metadata
LABEL org.opencontainers.image.description="Rust CLI application development container"
