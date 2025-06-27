# Svelte Template

A modern SvelteKit template with comprehensive development tools and best practices.

## Features

- SvelteKit 2.0 with TypeScript
- Lucia for authentication
- Prisma for type-safe database access
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
npm test

# Run tests with coverage
npm run test:coverage

# Type check
npm run check

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
│   ├── lib/
│   │   ├── components/    # Reusable components
│   │   ├── features/     # Feature modules
│   │   ├── stores/       # Svelte stores
│   │   └── utils/        # Utility functions
│   └── routes/           # SvelteKit routes
├── static/                # Static assets
├── tests/                 # Test utilities
├── .eslintrc.json        # ESLint configuration
├── .prettierrc           # Prettier configuration
├── package.json          # Project configuration
├── svelte.config.js      # Svelte configuration
├── tsconfig.json         # TypeScript configuration
└── README.md             # This file
```

## Component Example

```svelte
<script lang="ts">
  import { Button } from '$lib/components';

  function handleClick(): void {
    console.log('Button clicked!');
  }
</script>

<Button
  variant="primary"
  size="md"
  on:click={handleClick}
>
  Click Me
</Button>
```

## Testing

Tests are written using Vitest and Testing Library. Example:

```typescript
import { render, fireEvent } from '@testing-library/svelte';
import Button from './Button.svelte';

test('renders button with text', () => {
  const { getByRole } = render(Button, { props: { children: 'Click me' } });
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

- Authentication with Lucia
- Dependencies are managed through npm with package-lock.json
- Security scanning in CI pipeline:
  - Snyk for dependency vulnerabilities
  - ESLint security plugins
- Regular dependency updates through Dependabot
- Type-safe database access with Prisma
- Input validation with Zod

## License

MIT License - see [LICENSE](LICENSE) for details
