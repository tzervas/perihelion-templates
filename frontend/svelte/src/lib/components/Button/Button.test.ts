import { describe, it, expect, vi } from 'vitest';
import { render, fireEvent } from '@testing-library/svelte';
import Button from './Button.svelte';

describe('Button', () => {
  it('renders with default props', () => {
    const { getByRole } = render(Button, { props: { children: 'Click me' } });
    const button = getByRole('button');
    expect(button).toBeInTheDocument();
    expect(button.className).toContain('bg-blue-600'); // primary variant
  });

  it('renders different variants', () => {
    const { getByRole, rerender } = render(Button);

    rerender({ variant: 'secondary' });
    expect(getByRole('button').className).toContain('bg-gray-200');

    rerender({ variant: 'danger' });
    expect(getByRole('button').className).toContain('bg-red-600');
  });

  it('renders different sizes', () => {
    const { getByRole, rerender } = render(Button);

    rerender({ size: 'sm' });
    const button = getByRole('button');
    expect(button.className).toContain('px-3');
    expect(button.className).toContain('py-1.5');
    expect(button.className).toContain('text-sm');

    rerender({ size: 'lg' });
    expect(button.className).toContain('px-6');
    expect(button.className).toContain('py-3');
    expect(button.className).toContain('text-lg');
  });

  it('shows loading state', () => {
    const { getByRole, getByText } = render(Button, { props: { isLoading: true } });
    expect(getByText('Loading...')).toBeInTheDocument();
    expect(getByRole('button')).toHaveAttribute('aria-disabled', 'true');
  });

  it('handles disabled state', () => {
    const { getByRole } = render(Button, { props: { disabled: true } });
    const button = getByRole('button');
    expect(button).toBeDisabled();
    expect(button).toHaveAttribute('aria-disabled', 'true');
  });

  it('handles click events when not disabled', async () => {
    const { component, getByRole } = render(Button);
    const mockClick = vi.fn();
    component.$on('click', mockClick);

    await fireEvent.click(getByRole('button'));
    expect(mockClick).toHaveBeenCalled();
  });

  it('does not trigger click when disabled', async () => {
    const { component, getByRole } = render(Button, { props: { disabled: true } });
    const mockClick = vi.fn();
    component.$on('click', mockClick);

    await fireEvent.click(getByRole('button'));
    expect(mockClick).not.toHaveBeenCalled();
  });

  it('does not trigger click when loading', async () => {
    const { component, getByRole } = render(Button, { props: { isLoading: true } });
    const mockClick = vi.fn();
    component.$on('click', mockClick);

    await fireEvent.click(getByRole('button'));
    expect(mockClick).not.toHaveBeenCalled();
  });

  it('applies full width class when isFullWidth is true', () => {
    const { getByRole } = render(Button, { props: { isFullWidth: true } });
    expect(getByRole('button').className).toContain('w-full');
  });

  it('uses the correct button type', () => {
    const { getByRole, rerender } = render(Button);
    expect(getByRole('button')).toHaveAttribute('type', 'button');

    rerender({ type: 'submit' });
    expect(getByRole('button')).toHaveAttribute('type', 'submit');

    rerender({ type: 'reset' });
    expect(getByRole('button')).toHaveAttribute('type', 'reset');
  });
});
