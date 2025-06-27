# React Template

A modern React template with TypeScript, Vite, and comprehensive development tools.

## Features

- React 18 with TypeScript
- Vite for fast development and building
- TanStack Router for type-safe routing
- TanStack Query for data fetching
- Zustand for state management
- React Hook Form with Zod validation
- Tailwind CSS for styling
- Comprehensive testing with Vitest and Testing Library
- Storybook for component documentation
- ESLint and Prettier for code quality
- GitHub Actions CI/CD pipeline
- Development container support

## Getting Started

### Prerequisites

- Node.js 20 or later
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
# Start development server
npm run dev

# Run tests
npm test

# Run tests with coverage
npm run test:coverage

# Run type checking
npm run typecheck

# Lint code
npm run lint

# Format code
npm run format

# Start Storybook
npm run storybook
```

## Project Structure

```
├── .devcontainer/          # Development container configuration
├── .github/                # GitHub Actions workflows
├── src/
│   ├── components/        # Reusable components
│   ├── features/         # Feature-specific components
│   ├── hooks/           # Custom React hooks
│   ├── services/        # API and external services
│   ├── utils/           # Utility functions
│   ├── types/           # TypeScript type definitions
│   ├── assets/          # Static assets
│   └── styles/          # Global styles
├── tests/                 # Test setup and utilities
├── .eslintrc.json        # ESLint configuration
├── .prettierrc           # Prettier configuration
├── package.json          # Project configuration
├── tsconfig.json         # TypeScript configuration
├── vite.config.ts        # Vite configuration
└── README.md             # This file
```

## Component Example

```tsx
import { Button } from '@/components/Button';

function MyComponent() {
  return (
    <div>
      <Button
        variant="primary"
        size="md"
        onClick={() => console.log('clicked')}
      >
        Click Me
      </Button>
    </div>
  );
}
```

## Testing

Tests are written using Vitest and Testing Library. Example:

```tsx
import { render, screen } from '@testing-library/react';
import { Button } from './Button';

test('renders button with text', () => {
  render(<Button>Click me</Button>);
  expect(screen.getByRole('button')).toHaveTextContent('Click me');
});
```

## Storybook

Components are documented using Storybook. Run `npm run storybook` to view the documentation.

## Contributing

1. Create a feature branch
2. Make your changes
3. Ensure all tests pass and coverage is maintained
4. Submit a pull request

## Security

This template includes several security features:

- Dependencies are managed through npm with package-lock.json
- Security scanning in CI pipeline:
  - Snyk for dependency vulnerabilities
  - ESLint security plugins
- Regular dependency updates through Dependabot
- Type-safe APIs and forms with TypeScript and Zod
- Input validation best practices

## License

MIT License - see [LICENSE](LICENSE) for details
