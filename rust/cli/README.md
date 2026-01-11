# Rust CLI Template

A secure and robust template for creating command-line applications in Rust.

## Features

- Modern Rust tooling and best practices
- Secure by default configuration
- Comprehensive error handling and logging
- Command-line argument parsing with clap
- Unit tests and integration tests
- Performance benchmarking
- Security auditing
- GitHub Actions CI pipeline
- DevContainer support for consistent development environment

## Getting Started

### Prerequisites

- VS Code with Remote Containers extension
- Docker installed and running
- Git with GPG signing configured

### Development

1. Clone the repository
2. Open in VS Code with Remote Containers
3. The development container will automatically build and install dependencies

### Building

```bash
cargo build --release
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
├── src/                    # Source code
├── tests/                  # Integration tests
├── benches/                # Performance benchmarks
├── Cargo.toml             # Project manifest
└── README.md              # Project documentation
```

## Security Features

- Static linking by default
- Memory safety with Rust's ownership system
- Secure dependency management
- Automated security auditing
- GPG commit signing
- No privileged operations in container

## License

MIT © Tyler Zervas
