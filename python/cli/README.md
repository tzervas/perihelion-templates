# Python CLI Template

A secure, production-ready template for Python CLI applications with devcontainer support.

## Features

- Python 3.12+ support
- UV package management
- Type hints and static type checking
- Comprehensive documentation
- Secure development practices
- GitHub Actions CI/CD
- Devcontainer support

## Usage

1. Click "Use this template" on GitHub
2. Clone your new repository
3. Open in VS Code with devcontainer support
4. Follow the setup instructions in docs/development.md

## Structure

```
.
├── .devcontainer/          # Development container configuration
│   ├── Dockerfile         # Container definition
│   ├── devcontainer.json  # VS Code configuration
│   └── docker-compose.yml # Service definitions
├── .github/               # GitHub configuration
│   └── workflows/        # GitHub Actions workflows
├── docs/                 # Project documentation
│   ├── development.md   # Development guide
│   └── ...             # Additional documentation
├── src/                 # Source code
│   └── your_cli/       # CLI implementation
├── tests/              # Test suite
├── .gitignore         # Git ignore rules
├── LICENSE           # MIT License
├── pyproject.toml   # Project configuration
└── README.md       # Project readme
```

## Development Environment

This template includes a devcontainer configuration for:

- Python 3.12
- UV package manager
- Development tools
- Security tools
- Testing framework

### VS Code Setup

1. Install Docker and VS Code
2. Install Remote - Containers extension
3. Open project in container
4. Start developing with full IDE support

## Security Features

- GPG signing enforcement
- STRIDE analysis requirements
- Secure defaults
- Dependency scanning
- Container hardening

## Documentation

- [Development Guide](docs/development.md)
- [Security Guide](docs/security.md)
- [Contributing Guide](CONTRIBUTING.md)
- [Design Decisions](docs/decisions.md)

## License

MIT License - Copyright (c) Tyler Zervas
