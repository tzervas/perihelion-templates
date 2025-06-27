import { html, LitElement, css } from 'lit';
import { customElement, property } from 'lit/decorators.js';
import { classMap } from 'lit/directives/class-map.js';

export type ButtonVariant = 'primary' | 'secondary' | 'danger';
export type ButtonSize = 'sm' | 'md' | 'lg';

/**
 * A customizable button component.
 *
 * @element pl-button
 *
 * @fires click - Emitted when the button is clicked
 *
 * @slot - Default slot for button content
 *
 * @csspart button - The button element
 *
 * @cssproperty --button-primary-bg - Primary button background color
 * @cssproperty --button-primary-text - Primary button text color
 * @cssproperty --button-secondary-bg - Secondary button background color
 * @cssproperty --button-secondary-text - Secondary button text color
 * @cssproperty --button-danger-bg - Danger button background color
 * @cssproperty --button-danger-text - Danger button text color
 */
@customElement('pl-button')
export class Button extends LitElement {
  /** The button variant */
  @property({ type: String }) variant: ButtonVariant = 'primary';

  /** The button size */
  @property({ type: String }) size: ButtonSize = 'md';

  /** Whether the button is in a loading state */
  @property({ type: Boolean }) isLoading = false;

  /** Whether the button should take up the full width of its container */
  @property({ type: Boolean }) isFullWidth = false;

  /** Whether the button is disabled */
  @property({ type: Boolean }) disabled = false;

  /** The button type */
  @property({ type: String }) type: 'button' | 'submit' | 'reset' = 'button';

  static styles = css`
    :host {
      display: inline-block;
    }

    :host([isFullWidth]) {
      display: block;
    }

    .button {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      font-family: var(--button-font-family, system-ui);
      font-weight: var(--button-font-weight, 500);
      border-radius: var(--button-border-radius, 0.375rem);
      cursor: pointer;
      transition: background-color 0.2s, color 0.2s, opacity 0.2s;
      border: none;
      outline: none;
      width: var(--button-width, auto);
    }

    :host([isFullWidth]) .button {
      width: 100%;
    }

    .button:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }

    .button:focus {
      outline: 2px solid var(--button-focus-ring-color, rgb(59, 130, 246));
      outline-offset: 2px;
    }

    /* Variants */
    .button--primary {
      background-color: var(--button-primary-bg, rgb(37, 99, 235));
      color: var(--button-primary-text, white);
    }

    .button--primary:hover:not(:disabled) {
      background-color: var(--button-primary-hover-bg, rgb(29, 78, 216));
    }

    .button--secondary {
      background-color: var(--button-secondary-bg, rgb(229, 231, 235));
      color: var(--button-secondary-text, rgb(17, 24, 39));
    }

    .button--secondary:hover:not(:disabled) {
      background-color: var(--button-secondary-hover-bg, rgb(209, 213, 219));
    }

    .button--danger {
      background-color: var(--button-danger-bg, rgb(220, 38, 38));
      color: var(--button-danger-text, white);
    }

    .button--danger:hover:not(:disabled) {
      background-color: var(--button-danger-hover-bg, rgb(185, 28, 28));
    }

    /* Sizes */
    .button--sm {
      padding: 0.375rem 0.75rem;
      font-size: 0.875rem;
      line-height: 1.25rem;
    }

    .button--md {
      padding: 0.5rem 1rem;
      font-size: 1rem;
      line-height: 1.5rem;
    }

    .button--lg {
      padding: 0.75rem 1.5rem;
      font-size: 1.125rem;
      line-height: 1.75rem;
    }

    /* Loading spinner */
    .spinner {
      animation: spin 1s linear infinite;
      margin-right: 0.5rem;
      width: 1em;
      height: 1em;
    }

    @keyframes spin {
      from {
        transform: rotate(0deg);
      }
      to {
        transform: rotate(360deg);
      }
    }
  `;

  private getButtonClasses(): Record<string, boolean> {
    return {
      button: true,
      [`button--${this.variant}`]: true,
      [`button--${this.size}`]: true,
    };
  }

  protected render() {
    return html`
      <button
        part="button"
        type=${this.type}
        class=${classMap(this.getButtonClasses())}
        ?disabled=${this.disabled || this.isLoading}
        aria-disabled=${this.disabled || this.isLoading}
        @click=${this.handleClick}
      >
        ${this.isLoading
          ? html`
              <svg
                class="spinner"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
              >
                <circle
                  class="opacity-25"
                  cx="12"
                  cy="12"
                  r="10"
                  stroke="currentColor"
                  strokeWidth="4"
                />
                <path
                  class="opacity-75"
                  fill="currentColor"
                  d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                />
              </svg>
              Loading...
            `
          : html`<slot></slot>`}
      </button>
    `;
  }

  private handleClick(event: MouseEvent): void {
    if (this.disabled || this.isLoading) {
      event.preventDefault();
      event.stopPropagation();
    }
  }
}
