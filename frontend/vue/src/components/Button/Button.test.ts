import { describe, it, expect } from 'vitest';
import { render, fireEvent } from '@testing-library/vue';
import Button from './Button.vue';

describe('Button', () => {
  it('renders with default props', () => {
    const { getByRole } = render(Button, {
      slots: {
        default: 'Click me',
      },
    });
    const button = getByRole('button');
    expect(button).toBeInTheDocument();
    expect(button.className).toContain('bg-blue-600'); // primary variant
  });

  it('renders different variants', async () => {
    const { getByRole, rerender } = render(Button);

    await rerender({ props: { variant: 'secondary' } });
    expect(getByRole('button').className).toContain('bg-gray-200');

    await rerender({ props: { variant: 'danger' } });
    expect(getByRole('button').className).toContain('bg-red-600');
  });

  it('renders different sizes', async () => {
    const { getByRole, rerender } = render(Button);

    await rerender({ props: { size: 'sm' } });
    const button = getByRole('button');
    expect(button.className).toContain('px-3');
    expect(button.className).toContain('py-1.5');
    expect(button.className).toContain('text-sm');

    await rerender({ props: { size: 'lg' } });
    expect(button.className).toContain('px-6');
    expect(button.className).toContain('py-3');
    expect(button.className).toContain('text-lg');
  });

  it('shows loading state', () => {
    const { getByRole, getByText } = render(Button, {
      props: { isLoading: true },
    });
    expect(getByText('Loading...')).toBeInTheDocument();
    expect(getByRole('button')).toHaveAttribute('aria-disabled', 'true');
  });

  it('handles disabled state', () => {
    const { getByRole } = render(Button, {
      props: { disabled: true },
    });
    const button = getByRole('button');
    expect(button).toBeDisabled();
    expect(button).toHaveAttribute('aria-disabled', 'true');
  });

  it('handles click events when not disabled', async () => {
    const { getByRole, emitted } = render(Button);
    const button = getByRole('button');

    await fireEvent.click(button);
    expect(emitted()).toHaveProperty('click');
  });

  it('does not trigger click when disabled', async () => {
    const { getByRole, emitted } = render(Button, {
      props: { disabled: true },
    });
    const button = getByRole('button');

    await fireEvent.click(button);
    expect(emitted()).not.toHaveProperty('click');
  });

  it('does not trigger click when loading', async () => {
    const { getByRole, emitted } = render(Button, {
      props: { isLoading: true },
    });
    const button = getByRole('button');

    await fireEvent.click(button);
    expect(emitted()).not.toHaveProperty('click');
  });

  it('applies full width class when isFullWidth is true', () => {
    const { getByRole } = render(Button, {
      props: { isFullWidth: true },
    });
    expect(getByRole('button').className).toContain('w-full');
  });

  it('uses the correct button type', async () => {
    const { getByRole, rerender } = render(Button);
    expect(getByRole('button')).toHaveAttribute('type', 'button');

    await rerender({ props: { type: 'submit' } });
    expect(getByRole('button')).toHaveAttribute('type', 'submit');

    await rerender({ props: { type: 'reset' } });
    expect(getByRole('button')).toHaveAttribute('type', 'reset');
  });
});
