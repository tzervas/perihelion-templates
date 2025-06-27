# Node.js Library Template

A modern Node.js library template with TypeScript, comprehensive testing, and best practices for development and security.

## Features

- TypeScript 5.3+ with strict type checking
- Modern ESM support
- Vitest for testing with coverage reporting
- ESLint with strict TypeScript rules
- Prettier for consistent code formatting
- Husky for Git hooks
- Comprehensive CI/CD with GitHub Actions
- Development container support
- Runtime type validation with Zod
- Security scanning with Snyk and CodeQL

## Getting Started

### Prerequisites

- Node.js 20.x or later
- VS Code with Remote Containers extension (recommended)
- Docker (for development container)

### Development Container

This template includes a development container configuration that provides a consistent, isolated development environment. To use it:

1. Open the project in VS Code
2. When prompted, click "Reopen in Container"
3. Wait for the container to build and initialize

### Installation

```bash
npm ci
```

### Development

```bash
# Build the project
npm run build

# Run tests
npm test

# Run tests with coverage
npm run test:coverage

# Lint code
npm run lint

# Fix lint issues
npm run lint:fix

# Format code
npm run format
```

## Project Structure

```
├── .devcontainer/          # Development container configuration
├── .github/                # GitHub Actions workflows
├── src/                    # Source code
├── test/                   # Test files
├── .eslintrc.json         # ESLint configuration
├── .prettierrc            # Prettier configuration
├── package.json           # Project configuration
├── tsconfig.json          # TypeScript configuration
├── vitest.config.ts       # Vitest configuration
└── README.md              # This file
```

## Example Usage

```typescript
import { StringFormatter } from '@perihelion/library-template';

const formatter = new StringFormatter({
  uppercase: true,
  trim: true,
  maxLength: 10,
});

const result = formatter.format('  hello world  ');
console.log(result); // 'HELLO WORL'

// Create new formatter with different options
const newFormatter = formatter.withOptions({ uppercase: false });
console.log(newFormatter.format('  hello world  ')); // 'hello worl'
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Ensure all tests pass and coverage is maintained
4. Submit a pull request

## Security

This template includes several security features:

- Runtime type validation with Zod
- Strict TypeScript configuration
- Dependencies are managed through npm with package-lock.json
- Security scanning in CI pipeline
  - Snyk for dependency vulnerabilities
  - CodeQL for code analysis
- Regular dependency updates through Dependabot

## License

MIT License - see [LICENSE](LICENSE) for details
