# Lit Template

A modern Lit template with TypeScript and comprehensive development tools.

## Features

- Lit 3.0 with TypeScript
- Vite for fast development and building
- Web Components with Shadow DOM encapsulation
- Lit Task for asynchronous operations
- Lit Context for dependency injection
- React interop with @lit/react
- Comprehensive testing with Vitest and Testing Library
- Component documentation with Storybook
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

# Lint code
npm run lint

# Format code
npm run format

# Analyze web components
npm run analyze

# Start Storybook
npm run storybook
```

## Project Structure

```
├── .devcontainer/          # Development container configuration
├── .github/                # GitHub Actions workflows
├── src/
│   ├── components/        # Web components
│   ├── controllers/       # Custom element controllers
│   ├── styles/           # Shared styles
│   └── utils/            # Utility functions
├── test/                  # Test utilities
├── .eslintrc.json        # ESLint configuration
├── .prettierrc           # Prettier configuration
├── package.json          # Project configuration
├── tsconfig.json         # TypeScript configuration
├── vite.config.ts        # Vite configuration
└── README.md             # This file
```

## Component Example

```typescript
import { html, LitElement, css } from 'lit';
import { customElement, property } from 'lit/decorators.js';

@customElement('pl-button')
export class Button extends LitElement {
  @property({ type: String }) variant = 'primary';
  @property({ type: Boolean }) isLoading = false;

  static styles = css`
    :host {
      display: inline-block;
    }
    button {
      /* styles */
    }
  `;

  render() {
    return html`
      <button ?disabled=${this.isLoading}>
        <slot></slot>
      </button>
    `;
  }
}
```

Usage:
```html
<pl-button variant="primary">Click Me</pl-button>
```

## Testing

Tests are written using Vitest and Testing Library. Example:

```typescript
import { fixture, html } from '@open-wc/testing';
import { Button } from './Button';

test('renders button with text', async () => {
  const el = await fixture(html`<pl-button>Click me</pl-button>`);
  expect(el.shadowRoot?.textContent).toContain('Click me');
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
- Shadow DOM encapsulation
- Strict type checking

## License

MIT License - see [LICENSE](LICENSE) for details
