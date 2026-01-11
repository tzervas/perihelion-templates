# Java Web Service Template

A secure and robust template for creating Spring Boot web services.

## Features

- Modern Spring Boot 3.x setup
- JWT authentication
- Database integration with PostgreSQL and Flyway migrations
- Redis caching
- OpenAPI/Swagger documentation
- Prometheus metrics
- Grafana dashboards
- Comprehensive security setup
- Unit and integration testing with TestContainers
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
./mvnw clean package
```

### Running

```bash
./mvnw spring-boot:run
```

### Testing

```bash
./mvnw test
```

### API Documentation

Once running, access the Swagger UI at:
- http://localhost:8080/swagger-ui.html

### Monitoring

The service exposes the following endpoints:
- Prometheus metrics: http://localhost:8080/actuator/prometheus
- Health check: http://localhost:8080/actuator/health
- Info: http://localhost:8080/actuator/info

Grafana dashboard is available at:
- http://localhost:3000

## Development Container

This template includes a fully configured development container with:

- OpenJDK 21
- Maven build tool
- PostgreSQL database
- Redis cache
- Prometheus monitoring
- Grafana dashboards
- Code formatting and linting
- Testing tools
- Git with GPG signing
- VS Code extensions and settings

## Project Structure

```
.
├── .devcontainer/          # Development container configuration
├── .github/                # GitHub Actions workflows
├── src/
│   ├── main/
│   │   ├── java/          # Source code
│   │   └── resources/     # Configuration files
│   └── test/
│       ├── java/          # Test code
│       └── resources/     # Test configuration
├── pom.xml                # Project configuration
└── README.md              # Project documentation
```

## Security Features

- JWT token authentication
- Database connection pooling with timeouts
- Redis session caching
- CORS configuration
- Security headers
- OWASP dependency checking
- GPG commit signing
- No privileged operations in container

## Configuration

The application can be configured through:
- application.yml
- Environment variables
- Command line arguments

Key configuration properties:

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/devdb
    username: postgres
    password: postgres

  redis:
    host: localhost
    port: 6379

  security:
    jwt:
      secret-key: your-secret-key
      expiration: 86400000 # 24 hours
```

## License

MIT © Tyler Zervas
