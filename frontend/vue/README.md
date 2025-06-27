# Vue Template

A modern Vue 3 template with TypeScript and comprehensive development tools.

## Features

- Vue 3 with Composition API and script setup
- TypeScript support
- Vite for fast development and building
- Pinia for state management
- VueUse for composition utilities
- Comprehensive testing with Vitest and Testing Library
- Component documentation with Storybook
- ESLint and Prettier for code quality
- Tailwind CSS for styling
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
npm run test:unit

# Run tests with coverage
npm run test:coverage

# Type check
npm run type-check

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
│   ├── composables/       # Vue composables
│   ├── stores/           # Pinia stores
│   ├── utils/            # Utility functions
│   └── views/            # Page components
├── tests/
│   └── unit/             # Unit tests
├── .eslintrc.json        # ESLint configuration
├── .prettierrc           # Prettier configuration
├── package.json          # Project configuration
├── tsconfig.json         # TypeScript configuration
├── vite.config.ts        # Vite configuration
└── README.md             # This file
```

## Component Example

```vue
<script setup lang="ts">
import { Button } from '@/components';

function handleClick(): void {
  console.log('Button clicked!');
}
</script>

<template>
  <Button
    variant="primary"
    size="md"
    @click="handleClick"
  >
    Click Me
  </Button>
</template>
```

## Testing

Tests are written using Vitest and Testing Library. Example:

```typescript
import { render, fireEvent } from '@testing-library/vue';
import Button from './Button.vue';

test('renders button with text', () => {
  const { getByRole } = render(Button, {
    slots: { default: 'Click me' },
  });
  expect(getByRole('button')).toHaveTextContent('Click me');
});
```

## Documentation

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
- Type-safe state management with Pinia
- Input validation with Zod

## License

MIT License - see [LICENSE](LICENSE) for details
