# Rust Web Service Template

A secure and robust template for creating web services in Rust using Axum.

## Features

- Modern Rust web development stack with Axum
- Secure by default configuration
- Database integration with SeaORM/SQLx
- Redis caching support
- JWT authentication
- Comprehensive error handling
- Structured logging and telemetry
- Performance metrics
- OpenTelemetry integration
- Unit tests and integration tests
- Performance benchmarking
- Security auditing
- GitHub Actions CI pipeline
- DevContainer support

## Getting Started

### Prerequisites

- VS Code with Remote Containers extension
- Docker installed and running
- Git with GPG signing configured

### Development

1. Clone the repository
2. Open in VS Code with Remote Containers
3. The development container will automatically build and install dependencies

### Environment Variables

```bash
DATABASE_URL=postgres://postgres:postgres@localhost:5432/db_name
REDIS_URL=redis://localhost:6379
JWT_SECRET=your-secret-key
ENVIRONMENT=development
```

### Running

```bash
# Development with auto-reload
cargo watch -x run

# Production
cargo run --release
```

### Testing

```bash
cargo test --all-features
```

### Benchmarking

```bash
cargo bench
```

### Security Audit

```bash
cargo audit
```

## Development Container

This template includes a fully configured development container with:

- Rust toolchain and development tools
- PostgreSQL and Redis clients
- Database migration tools
- Code formatting and linting
- Testing and benchmarking setup
- Security tools
- Git with GPG signing
- VS Code extensions and settings

## Project Structure

```
.
├── .devcontainer/          # Development container configuration
├── .github/                # GitHub Actions workflows
├── src/
│   ├── main.rs            # Application entry point
│   ├── config.rs          # Configuration management
│   ├── db.rs              # Database connection handling
│   ├── error.rs           # Error types and handling
│   └── telemetry.rs       # Logging and metrics
├── tests/                  # Integration tests
├── benches/               # Performance benchmarks
├── Cargo.toml            # Project manifest
└── README.md             # Project documentation
```

## Security Features

- Database connection pooling with timeouts
- Secure password hashing with Argon2
- JWT token-based authentication
- CORS and request validation
- Rate limiting and timeout middleware
- Secure headers
- No privileged operations in container
- Automated security auditing

## API Documentation

- `GET /health` - Health check endpoint
  - Returns service status and version
  - No authentication required

## License

MIT © Tyler Zervas
