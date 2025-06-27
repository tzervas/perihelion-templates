# Angular Template

A modern Angular template with comprehensive development tools and best practices.

## Features

- Angular 17 with standalone components
- NgRx for state management
- Comprehensive testing with Jasmine and Karma
- Code documentation with Compodoc
- Component documentation with Storybook
- ESLint and Prettier for code quality
- SCSS with modern CSS features
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
npm start

# Run tests
npm test

# Run tests with coverage
npm test:coverage

# Lint code
npm run lint

# Format code
npm run format

# Start Storybook
npm run storybook

# Generate documentation
npm run compodoc
```

## Project Structure

```
├── .devcontainer/          # Development container configuration
├── .github/                # GitHub Actions workflows
├── src/
│   ├── app/
│   │   ├── components/    # Reusable components
│   │   ├── features/     # Feature modules
│   │   ├── services/     # Application services
│   │   ├── shared/       # Shared modules and utilities
│   │   └── core/         # Core functionality
│   ├── assets/           # Static assets
│   └── styles/           # Global styles
├── .eslintrc.json        # ESLint configuration
├── .prettierrc           # Prettier configuration
├── angular.json          # Angular CLI configuration
├── package.json          # Project configuration
└── README.md            # This file
```

## Component Example

```typescript
import { ButtonComponent } from '@app/shared/components/button';

@Component({
  selector: 'app-my-component',
  standalone: true,
  imports: [ButtonComponent],
  template: `
    <app-button
      variant="primary"
      size="md"
      (buttonClick)="handleClick()"
    >
      Click Me
    </app-button>
  `,
})
export class MyComponent {
  handleClick(): void {
    console.log('Button clicked!');
  }
}
```

## Testing

Tests are written using Jasmine and Karma. Example:

```typescript
describe('ButtonComponent', () => {
  let component: ButtonComponent;
  let fixture: ComponentFixture<ButtonComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ButtonComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(ButtonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
```

## Documentation

- Component documentation is available through Storybook. Run `npm run storybook` to view.
- API documentation is generated using Compodoc. Run `npm run compodoc` to generate.

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
- Type-safe templates and APIs
- Input validation best practices

## License

MIT License - see [LICENSE](LICENSE) for details
