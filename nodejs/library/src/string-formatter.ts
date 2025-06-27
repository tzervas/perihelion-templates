import { z } from 'zod';

const StringFormatterOptions = z.object({
  uppercase: z.boolean().default(false),
  trim: z.boolean().default(true),
  maxLength: z.number().int().positive().optional(),
});

type StringFormatterOptions = z.infer<typeof StringFormatterOptions>;

/**
 * A utility class for string formatting operations with strong type safety.
 */
export class StringFormatter {
  private readonly options: StringFormatterOptions;

  /**
   * Creates a new StringFormatter instance.
   * @param options Configuration options for string formatting
   * @throws {Error} If the options validation fails
   */
  constructor(options: Partial<StringFormatterOptions> = {}) {
    this.options = StringFormatterOptions.parse(options);
  }

  /**
   * Formats a string according to the configured options.
   * @param input The string to format
   * @returns The formatted string
   * @throws {Error} If the input is null or undefined
   */
  public format(input: string): string {
    if (input === null || input === undefined) {
      throw new Error('Input string cannot be null or undefined');
    }

    let result = input;

    if (this.options.trim) {
      result = result.trim();
    }

    if (this.options.uppercase) {
      result = result.toUpperCase();
    }

    if (this.options.maxLength !== undefined && result.length > this.options.maxLength) {
      result = result.slice(0, this.options.maxLength);
    }

    return result;
  }

  /**
   * Creates a new StringFormatter with updated options.
   * @param options New options to merge with current options
   * @returns A new StringFormatter instance
   */
  public withOptions(options: Partial<StringFormatterOptions>): StringFormatter {
    return new StringFormatter({
      ...this.options,
      ...options,
    });
  }
}
