FROM ghcr.io/tzervas/perihelion-templates/rust-dev-base:latest

# Install additional library-specific tools
RUN cargo install \
    cargo-edit \
    cargo-readme \
    cargo-release \
    cargo-deadlinks \
    cargo-outdated \
    cargo-semver-checks

# Configure additional security measures for libraries
ENV RUSTFLAGS="${RUSTFLAGS} -D warnings"
ENV CARGO_BUILD_TARGET_DIR=/workspace/target

# Label the image with library-specific metadata
LABEL org.opencontainers.image.description="Rust library development container"
