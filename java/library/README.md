# Java Library Template

This template provides a modern, secure foundation for building Java libraries with best practices for development, testing, and continuous integration.

## Features

- Java 21 with full module support
- Gradle build system with Kotlin DSL
- Comprehensive testing setup with JUnit 5
- Code coverage with JaCoCo
- Code quality with SonarQube
- Code formatting with Spotless (Google Java Format)
- Continuous Integration with GitHub Actions
- Development container support for VS Code
- Maven publication configuration
- Secure dependency management
- Comprehensive logging with SLF4J

## Getting Started

### Prerequisites

- Java 21 or later
- VS Code with Remote Containers extension (recommended)
- Docker (for development container)

### Development Container

This template includes a development container configuration that provides a consistent, isolated development environment. To use it:

1. Open the project in VS Code
2. When prompted, click "Reopen in Container"
3. Wait for the container to build and initialize

### Building

```bash
./gradlew build
```

### Running Tests

```bash
./gradlew test
```

### Code Coverage

```bash
./gradlew jacocoTestReport
```

The report will be available in `build/reports/jacoco/test/html/index.html`

### Code Formatting

```bash
./gradlew spotlessApply
```

## Project Structure

```
├── .devcontainer/          # Development container configuration
├── .github/                # GitHub Actions workflows
├── src/
│   ├── main/java/         # Source code
│   └── test/java/         # Test code
├── build.gradle.kts        # Gradle build configuration
└── README.md              # This file
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Run tests and ensure code coverage
4. Submit a pull request

## Security

- All dependencies are managed through Gradle with version locking
- Security scanning in CI pipeline
- SAST analysis with SonarQube
- Regular dependency updates through Dependabot

## License

MIT License - see [LICENSE](LICENSE) for details
