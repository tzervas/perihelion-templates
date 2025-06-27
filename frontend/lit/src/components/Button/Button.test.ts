import { describe, it, expect, vi } from 'vitest';
import { fixture, html } from '@open-wc/testing';
import { Button } from './Button';

// Register the component
customElements.define('pl-button', Button);

describe('Button', () => {
  it('renders with default props', async () => {
    const el = await fixture<Button>(html`<pl-button>Click me</pl-button>`);
    const button = el.shadowRoot?.querySelector('button');
    expect(button).toBeTruthy();
    expect(button?.className).toContain('button--primary');
    expect(button?.className).toContain('button--md');
  });

  it('renders different variants', async () => {
    const el = await fixture<Button>(html`<pl-button variant="secondary">Secondary</pl-button>`);
    let button = el.shadowRoot?.querySelector('button');
    expect(button?.className).toContain('button--secondary');

    const el2 = await fixture<Button>(html`<pl-button variant="danger">Danger</pl-button>`);
    button = el2.shadowRoot?.querySelector('button');
    expect(button?.className).toContain('button--danger');
  });

  it('renders different sizes', async () => {
    const el = await fixture<Button>(html`<pl-button size="sm">Small</pl-button>`);
    let button = el.shadowRoot?.querySelector('button');
    expect(button?.className).toContain('button--sm');

    const el2 = await fixture<Button>(html`<pl-button size="lg">Large</pl-button>`);
    button = el2.shadowRoot?.querySelector('button');
    expect(button?.className).toContain('button--lg');
  });

  it('shows loading state', async () => {
    const el = await fixture<Button>(html`<pl-button isLoading>Submit</pl-button>`);
    const button = el.shadowRoot?.querySelector('button');
    const spinner = el.shadowRoot?.querySelector('.spinner');
    const loadingText = el.shadowRoot?.textContent?.includes('Loading...');

    expect(button).toHaveAttribute('aria-disabled', 'true');
    expect(spinner).toBeTruthy();
    expect(loadingText).toBeTruthy();
  });

  it('handles disabled state', async () => {
    const el = await fixture<Button>(html`<pl-button disabled>Click me</pl-button>`);
    const button = el.shadowRoot?.querySelector('button');
    expect(button).toBeDisabled();
    expect(button).toHaveAttribute('aria-disabled', 'true');
  });

  it('handles click events when not disabled', async () => {
    const onClick = vi.fn();
    const el = await fixture<Button>(html`<pl-button @click=${onClick}>Click me</pl-button>`);
    const button = el.shadowRoot?.querySelector('button');

    button?.click();
    expect(onClick).toHaveBeenCalled();
  });

  it('does not trigger click when disabled', async () => {
    const onClick = vi.fn();
    const el = await fixture<Button>(html`<pl-button disabled @click=${onClick}>Click me</pl-button>`);
    const button = el.shadowRoot?.querySelector('button');

    button?.click();
    expect(onClick).not.toHaveBeenCalled();
  });

  it('does not trigger click when loading', async () => {
    const onClick = vi.fn();
    const el = await fixture<Button>(
      html`<pl-button isLoading @click=${onClick}>Click me</pl-button>`,
    );
    const button = el.shadowRoot?.querySelector('button');

    button?.click();
    expect(onClick).not.toHaveBeenCalled();
  });

  it('applies full width when isFullWidth is true', async () => {
    const el = await fixture<Button>(html`<pl-button isFullWidth>Full Width</pl-button>`);
    expect(el).toHaveAttribute('isFullWidth');
  });

  it('uses the correct button type', async () => {
    const el = await fixture<Button>(html`<pl-button type="submit">Submit</pl-button>`);
    const button = el.shadowRoot?.querySelector('button');
    expect(button).toHaveAttribute('type', 'submit');
  });
});
