import type { Meta, StoryObj } from '@storybook/web-components';
import { html } from 'lit';
import './Button';

const meta = {
  title: 'Components/Button',
  tags: ['autodocs'],
  render: (args) => html`
    <pl-button
      variant=${args.variant || 'primary'}
      size=${args.size || 'md'}
      type=${args.type || 'button'}
      ?isLoading=${args.isLoading}
      ?isFullWidth=${args.isFullWidth}
      ?disabled=${args.disabled}
      @click=${args.onClick}
    >
      ${args.content}
    </pl-button>
  `,
  argTypes: {
    variant: {
      control: 'select',
      options: ['primary', 'secondary', 'danger'],
    },
    size: {
      control: 'select',
      options: ['sm', 'md', 'lg'],
    },
    type: {
      control: 'select',
      options: ['button', 'submit', 'reset'],
    },
    isLoading: {
      control: 'boolean',
    },
    isFullWidth: {
      control: 'boolean',
    },
    disabled: {
      control: 'boolean',
    },
    content: {
      control: 'text',
    },
    onClick: { action: 'clicked' },
  },
} satisfies Meta;

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {
  args: {
    variant: 'primary',
    content: 'Primary Button',
  },
};

export const Secondary: Story = {
  args: {
    variant: 'secondary',
    content: 'Secondary Button',
  },
};

export const Danger: Story = {
  args: {
    variant: 'danger',
    content: 'Danger Button',
  },
};

export const Small: Story = {
  args: {
    size: 'sm',
    content: 'Small Button',
  },
};

export const Large: Story = {
  args: {
    size: 'lg',
    content: 'Large Button',
  },
};

export const Loading: Story = {
  args: {
    isLoading: true,
    content: 'Loading Button',
  },
};

export const Disabled: Story = {
  args: {
    disabled: true,
    content: 'Disabled Button',
  },
};

export const FullWidth: Story = {
  args: {
    isFullWidth: true,
    content: 'Full Width Button',
  },
};

export const Submit: Story = {
  args: {
    type: 'submit',
    content: 'Submit Button',
  },
};
