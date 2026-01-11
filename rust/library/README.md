# Rust Library Template

A secure and robust template for creating Rust libraries.

## Features

- Modern Rust library development setup
- No-std support
- Secure by default configuration
- Comprehensive error handling
- Memory security with zeroize
- Documentation and examples
- Unit tests and property testing
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

### Building

```bash
cargo build --release
```

### Testing

```bash
# Run all tests
cargo test --all-features

# Run no-std tests
cargo test --no-default-features
```

### Benchmarking

```bash
cargo bench
```

### Documentation

```bash
# Generate and open documentation
cargo doc --open
```

### Security Audit

```bash
cargo audit
```

## Development Container

This template includes a fully configured development container with:

- Rust toolchain and development tools
- Documentation tools
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
│   └── lib.rs             # Library source code
├── tests/                  # Integration tests
├── benches/               # Performance benchmarks
├── Cargo.toml            # Project manifest
└── README.md             # Project documentation
```

## Security Features

- Memory security with zeroize
- No unsafe code by default
- Secure dependency management
- Automated security auditing
- Semver compliance checking
- GPG commit signing
- No privileged operations in container

## Library Usage

```rust
use rust_library_template::SecureData;

fn main() {
    let data = SecureData::new("public-id", "sensitive-data");
    println!("Created secure data with ID: {}", data.id());
}
```

## License

MIT © Tyler Zervas
