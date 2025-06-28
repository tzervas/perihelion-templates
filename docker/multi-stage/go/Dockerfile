# syntax=docker/dockerfile:1.4

# Build stage
FROM golang:1.22-bookworm as builder

# Build arguments
ARG APP_USER=appuser
ARG APP_GROUP=appgroup
ARG APP_ROOT=/app
ARG APP_PORT=8080
ARG CGO_ENABLED=0
ARG GOOS=linux
ARG GOARCH=amd64

# Install tools and dependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR ${APP_ROOT}

# Download dependencies
COPY go.mod go.sum ./
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download

# Copy source code
COPY . .

# Run tests
RUN go test -v ./...

# Build the application
RUN go build \
    -ldflags="-w -s -extldflags=-static" \
    -tags netgo \
    -o app \
    ./cmd/app

# Run security scan
FROM aquasec/trivy:latest as security-scan
COPY --from=builder /app/app /app/app
RUN trivy fs --security-checks vuln,config --ignore-unfixed /app

# Development stage
FROM builder as development

# Install development tools
RUN go install github.com/go-delve/delve/cmd/dlv@latest && \
    go install golang.org/x/tools/cmd/godoc@latest && \
    go install golang.org/x/tools/gopls@latest && \
    go install honnef.co/go/tools/cmd/staticcheck@latest

# Production stage
FROM gcr.io/distroless/static-debian12:nonroot as production

# Import build arguments
ARG APP_USER
ARG APP_GROUP
ARG APP_ROOT
ARG APP_PORT

# Set environment variables
ENV APP_USER=${APP_USER} \
    APP_GROUP=${APP_GROUP} \
    APP_ROOT=${APP_ROOT}

# Copy binary from builder
COPY --from=builder ${APP_ROOT}/app ${APP_ROOT}/app

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
LABEL org.opencontainers.image.title="Go Application" \
      org.opencontainers.image.description="Secure Go application with multi-stage build" \
      org.opencontainers.image.vendor="Tyler Zervas" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.base.name="gcr.io/distroless/static-debian12:nonroot"
