# Go Library Template

A modern Go library template with comprehensive testing, logging, and development tools.

## Features

- Go 1.22+ with modern features
- Comprehensive testing with testify
- Structured logging with zap
- golangci-lint integration
- GitHub Actions CI/CD pipeline
- Development container support
- Security scanning with Snyk and gosec
- Example CLI application

## Getting Started

### Prerequisites

- Go 1.22 or later
- VS Code with Remote Containers extension (recommended)
- Docker (for development container)

### Development Container

This template includes a development container configuration that provides a consistent, isolated development environment. To use it:

1. Open the project in VS Code
2. When prompted, click "Reopen in Container"
3. Wait for the container to build and initialize

### Installation

```bash
go mod download
```

### Development

```bash
# Run tests
go test -v ./...

# Run tests with coverage
go test -v -race -coverprofile=coverage.txt -covermode=atomic ./...
go tool cover -html=coverage.txt

# Run linter
golangci-lint run

# Build the example
cd cmd/validate
go build
```

## Project Structure

```
├── .devcontainer/          # Development container configuration
├── .github/                # GitHub Actions workflows
├── cmd/                    # Command-line applications
│   └── validate/          # Example validation CLI
├── internal/              # Private application and library code
├── pkg/                   # Public API packages
│   ├── validator/        # String validation package
│   └── formatter/        # String formatting package
├── go.mod                 # Go module definition
├── go.sum                 # Go module checksums
└── README.md              # This file
```

## Example Usage

### Library Usage

```go
package main

import (
    "fmt"
    "github.com/tzervas/perihelion-templates/go/library/pkg/validator"
    "go.uber.org/zap"
)

func main() {
    // Create a validator with options
    v := validator.NewStringValidator(validator.StringValidationOptions{
        MaxLength: 10,
        AllowEmpty: false,
        RequireUTF8: true,
    })

    // Validate some strings
    errors := v.ValidateAll(
        "Hello",
        "This is too long",
        "",
    )

    if len(errors) > 0 {
        fmt.Printf("Found %d validation errors:\n", len(errors))
        for _, err := range errors {
            fmt.Printf("- %v\n", err)
        }
    }
}
```

### CLI Usage

The template includes an example CLI application that demonstrates the validator:

```bash
# Build the CLI
cd cmd/validate
go build

# Run validation with options
./validate --max-length=10 --require-utf8 "Hello" "This is too long" ""
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Ensure all tests pass and coverage is maintained
4. Submit a pull request

## Security

This template includes several security features:

- Dependencies are managed through Go modules
- Security scanning in CI pipeline:
  - Snyk for dependency vulnerabilities
  - gosec for Go-specific security issues
- Regular dependency updates through Dependabot
- Comprehensive logging for audit trails
- Input validation best practices

## License

MIT License - see [LICENSE](LICENSE) for details
