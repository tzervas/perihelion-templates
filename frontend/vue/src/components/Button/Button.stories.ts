import type { Meta, StoryObj } from '@storybook/vue3';
import Button from './Button.vue';

const meta = {
  title: 'Components/Button',
  component: Button,
  tags: ['autodocs'],
  args: {
    default: 'Button Text',
  },
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
    default: {
      control: 'text',
      description: 'Slot content',
    },
    click: {
      action: 'clicked',
    },
  },
} satisfies Meta<typeof Button>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Primary: Story = {
  args: {
    variant: 'primary',
    default: 'Primary Button',
  },
};

export const Secondary: Story = {
  args: {
    variant: 'secondary',
    default: 'Secondary Button',
  },
};

export const Danger: Story = {
  args: {
    variant: 'danger',
    default: 'Danger Button',
  },
};

export const Small: Story = {
  args: {
    size: 'sm',
    default: 'Small Button',
  },
};

export const Large: Story = {
  args: {
    size: 'lg',
    default: 'Large Button',
  },
};

export const Loading: Story = {
  args: {
    isLoading: true,
    default: 'Loading Button',
  },
};

export const Disabled: Story = {
  args: {
    disabled: true,
    default: 'Disabled Button',
  },
};

export const FullWidth: Story = {
  args: {
    isFullWidth: true,
    default: 'Full Width Button',
  },
};

export const Submit: Story = {
  args: {
    type: 'submit',
    default: 'Submit Button',
  },
};
