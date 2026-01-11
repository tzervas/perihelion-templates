# syntax=docker/dockerfile:1.4

# Build stage
FROM rust:1.75-slim-bookworm as builder

# Build arguments
ARG APP_USER=appuser
ARG APP_GROUP=appgroup
ARG APP_ROOT=/app
ARG APP_PORT=8080
ARG CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse

# Install tools and dependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        pkg-config \
        libssl-dev \
        ca-certificates \
        git \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a new cargo project
WORKDIR ${APP_ROOT}

# Install cargo tools
RUN cargo install cargo-audit && \
    cargo install cargo-deny && \
    cargo install cargo-outdated

# Copy manifests
COPY Cargo.toml Cargo.lock .
COPY .cargo .cargo

# Cache dependencies
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/local/cargo/git \
    mkdir src && \
    echo "fn main() {}" > src/main.rs && \
    cargo build --release && \
    rm -rf src

# Copy source code
COPY . .

# Audit dependencies
RUN cargo audit

# Run tests
RUN cargo test --release

# Build the application
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/local/cargo/git \
    cargo build --release

# Run security scan
FROM aquasec/trivy:latest as security-scan
COPY --from=builder /app/target/release/app /app/app
RUN trivy fs --security-checks vuln,config --ignore-unfixed /app

# Development stage
FROM builder as development

# Install development tools
RUN cargo install cargo-watch && \
    cargo install cargo-expand && \
    cargo install cargo-edit && \
    rustup component add rustfmt clippy rust-analyzer

# Production stage
FROM gcr.io/distroless/cc-debian12:nonroot as production

# Import build arguments
ARG APP_USER
ARG APP_GROUP
ARG APP_ROOT
ARG APP_PORT

# Set environment variables
ENV APP_USER=${APP_USER} \
    APP_GROUP=${APP_GROUP} \
    APP_ROOT=${APP_ROOT} \
    RUST_LOG=info

# Copy binary from builder
COPY --from=builder ${APP_ROOT}/target/release/app ${APP_ROOT}/app

# Set working directory
WORKDIR ${APP_ROOT}

# Expose port
EXPOSE ${APP_PORT}

# Use distroless nonroot user
USER nonroot:nonroot

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD ["/app/app", "health"]

# Set the entrypoint
ENTRYPOINT ["/app/app"]

# Labels
LABEL org.opencontainers.image.title="Rust Application" \
      org.opencontainers.image.description="Secure Rust application with multi-stage build" \
      org.opencontainers.image.vendor="Tyler Zervas" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.base.name="gcr.io/distroless/cc-debian12:nonroot"
