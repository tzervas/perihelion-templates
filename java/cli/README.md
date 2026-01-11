# Java CLI Template

A secure and robust template for creating command-line applications in Java.

## Features

- Modern Java 21 development setup
- Command-line parsing with Picocli
- Structured logging with SLF4J and Logback
- Comprehensive error handling
- Unit testing with JUnit 5
- Performance benchmarking with JMH
- Security scanning with OWASP dependency check
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
java -jar target/java-cli-template-0.1.0.jar --name World
```

### Testing

```bash
./mvnw test
```

### Benchmarking

```bash
./mvnw clean verify
java -jar target/benchmarks.jar
```

### Security Scan

```bash
./mvnw org.owasp:dependency-check-maven:check
```

## Development Container

This template includes a fully configured development container with:

- OpenJDK 21
- Maven build tool
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
│   ├── main/
│   │   ├── java/          # Source code
│   │   └── resources/     # Resources and configuration
│   └── test/
│       └── java/          # Test code
├── pom.xml                # Project configuration
└── README.md              # Project documentation
```

## Security Features

- Latest JDK security updates
- OWASP dependency checking
- CodeQL analysis
- Secure logging practices
- GPG commit signing
- No privileged operations in container

## Usage

The template provides a basic CLI application with the following features:

```bash
# Show help
java -jar target/java-cli-template-0.1.0.jar --help

# Run with parameters
java -jar target/java-cli-template-0.1.0.jar --name World --count 5

# Show version
java -jar target/java-cli-template-0.1.0.jar --version
```

## License

MIT © Tyler Zervas
