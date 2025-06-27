import {
  ChangeDetectionStrategy,
  Component,
  EventEmitter,
  Input,
  Output,
} from '@angular/core';
import { CommonModule } from '@angular/common';

export type ButtonVariant = 'primary' | 'secondary' | 'danger';
export type ButtonSize = 'sm' | 'md' | 'lg';

@Component({
  selector: 'app-button',
  standalone: true,
  imports: [CommonModule],
  template: `
    <button
      type="button"
      [class]="buttonClasses"
      [disabled]="disabled || isLoading"
      (click)="onClick($event)"
    >
      <ng-container *ngIf="isLoading; else content">
        <svg
          class="animate-spin -ml-1 mr-2 h-4 w-4"
          fill="none"
          viewBox="0 0 24 24"
          xmlns="http://www.w3.org/2000/svg"
        >
          <circle
            class="opacity-25"
            cx="12"
            cy="12"
            r="10"
            stroke="currentColor"
            stroke-width="4"
          />
          <path
            class="opacity-75"
            fill="currentColor"
            d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
          />
        </svg>
        Loading...
      </ng-container>
      <ng-template #content>
        <ng-content></ng-content>
      </ng-template>
    </button>
  `,
  styles: [
    `
      :host {
        display: inline-block;
      }

      .base {
        @apply inline-flex items-center justify-center font-medium rounded-md;
        @apply focus:outline-none focus:ring-2 focus:ring-offset-2;
        @apply disabled:opacity-50 disabled:cursor-not-allowed;
        @apply transition-colors duration-200;
      }

      .primary {
        @apply bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-500;
      }

      .secondary {
        @apply bg-gray-200 text-gray-900 hover:bg-gray-300 focus:ring-gray-500;
      }

      .danger {
        @apply bg-red-600 text-white hover:bg-red-700 focus:ring-red-500;
      }

      .sm {
        @apply px-3 py-1.5 text-sm;
      }

      .md {
        @apply px-4 py-2 text-base;
      }

      .lg {
        @apply px-6 py-3 text-lg;
      }

      .full-width {
        @apply w-full;
      }
    `,
  ],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ButtonComponent {
  @Input() variant: ButtonVariant = 'primary';
  @Input() size: ButtonSize = 'md';
  @Input() isLoading = false;
  @Input() isFullWidth = false;
  @Input() disabled = false;
  @Output() buttonClick = new EventEmitter<MouseEvent>();

  protected get buttonClasses(): string {
    return [
      'base',
      this.variant,
      this.size,
      this.isFullWidth ? 'full-width' : '',
    ].join(' ');
  }

  protected onClick(event: MouseEvent): void {
    if (!this.disabled && !this.isLoading) {
      this.buttonClick.emit(event);
    }
  }
}
