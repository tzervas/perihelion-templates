# Python Web Service Template

A secure, production-ready template for Python web services using FastAPI with devcontainer support.

## Features

- Python 3.12+ with FastAPI
- Secure authentication with Keycloak SSO
- UV package management
- Type hints and validation
- OpenAPI/Swagger documentation
- Async database support
- Containerized development and deployment
- Comprehensive security features

## Stack

- FastAPI - Modern async web framework
- SQLAlchemy 2.0 - Async ORM
- Alembic - Database migrations
- Keycloak - SSO integration
- Redis - Caching/session store
- PostgreSQL - Primary database
- pytest - Testing framework
- Prometheus - Metrics
- Jaeger - Tracing

## Usage

1. Click "Use this template" on GitHub
2. Clone your new repository
3. Open in VS Code with devcontainer support
4. Follow the setup instructions in docs/development.md

## Structure

```
.
├── .devcontainer/          # Development container configuration
│   ├── Dockerfile         # API service container
│   ├── devcontainer.json  # VS Code configuration
│   └── docker-compose.yml # Service dependencies
├── .github/               # GitHub configuration
│   └── workflows/        # GitHub Actions workflows
├── docs/                 # Project documentation
│   ├── api.md           # API documentation
│   ├── auth.md          # Authentication guide
│   ├── development.md   # Development guide
│   └── deployment.md    # Deployment guide
├── src/                 # Source code
│   └── app/           # Application package
│       ├── api/      # API endpoints
│       ├── core/     # Core functionality
│       ├── db/       # Database models
│       ├── schemas/  # Pydantic models
│       └── services/ # Business logic
├── tests/            # Test suite
│   ├── api/        # API tests
│   ├── db/        # Database tests
│   └── services/  # Service tests
├── migrations/    # Database migrations
├── scripts/      # Utility scripts
├── .env.example # Environment template
├── .gitignore   # Git ignore rules
├── LICENSE      # MIT License
├── docker-compose.yml # Production compose
├── pyproject.toml    # Project configuration
└── README.md        # Project readme
```

## Development Environment

The devcontainer setup includes:

- FastAPI development server
- PostgreSQL database
- Redis cache
- Keycloak SSO
- Development tools
- Security scanning

### Local Setup

1. Install Docker and VS Code
2. Install Remote - Containers extension
3. Open project in container
4. Run `uvicorn app.main:app --reload`
5. Visit http://localhost:8000/docs

## Security Features

- Keycloak SSO integration
- CORS configuration
- Rate limiting
- Input validation
- SQL injection protection
- XSS prevention
- CSRF protection
- Security headers
- Audit logging
- GPG signing enforcement
- STRIDE analysis implementation
- Dependency scanning
- Container hardening

## API Documentation

- OpenAPI/Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc
- Detailed [API Documentation](docs/api.md)

## Monitoring

- Health checks: /health
- Metrics: /metrics
- Tracing: Jaeger UI
- Logs: Structured JSON

## Documentation

- [API Guide](docs/api.md)
- [Authentication](docs/auth.md)
- [Development Guide](docs/development.md)
- [Deployment Guide](docs/deployment.md)
- [Security Guide](docs/security.md)
- [Contributing Guide](CONTRIBUTING.md)

## License

MIT License - Copyright (c) Tyler Zervas
