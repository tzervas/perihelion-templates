import { describe, it, expect } from 'vitest';
import { StringFormatter } from '../src/string-formatter';

describe('StringFormatter', () => {
  describe('constructor', () => {
    it('should create instance with default options', () => {
      const formatter = new StringFormatter();
      expect(formatter.format(' test ')).toBe('test');
    });

    it('should throw error for invalid options', () => {
      expect(() => new StringFormatter({ maxLength: -1 })).toThrow();
    });
  });

  describe('format', () => {
    it('should trim string by default', () => {
      const formatter = new StringFormatter();
      expect(formatter.format('  hello  ')).toBe('hello');
    });

    it('should not trim string when trim is false', () => {
      const formatter = new StringFormatter({ trim: false });
      expect(formatter.format('  hello  ')).toBe('  hello  ');
    });

    it('should convert to uppercase when uppercase is true', () => {
      const formatter = new StringFormatter({ uppercase: true });
      expect(formatter.format('hello')).toBe('HELLO');
    });

    it('should apply maxLength constraint', () => {
      const formatter = new StringFormatter({ maxLength: 3 });
      expect(formatter.format('hello')).toBe('hel');
    });

    it('should apply all transformations in correct order', () => {
      const formatter = new StringFormatter({
        trim: true,
        uppercase: true,
        maxLength: 3,
      });
      expect(formatter.format('  hello  ')).toBe('HEL');
    });

    it('should throw error for null input', () => {
      const formatter = new StringFormatter();
      expect(() => formatter.format(null as unknown as string)).toThrow('Input string cannot be null or undefined');
    });
  });

  describe('withOptions', () => {
    it('should create new instance with merged options', () => {
      const formatter = new StringFormatter({ trim: true });
      const newFormatter = formatter.withOptions({ uppercase: true });
      expect(newFormatter.format('  hello  ')).toBe('HELLO');
    });

    it('should override existing options', () => {
      const formatter = new StringFormatter({ trim: true });
      const newFormatter = formatter.withOptions({ trim: false });
      expect(newFormatter.format('  hello  ')).toBe('  hello  ');
    });

    it('should maintain immutability', () => {
      const formatter = new StringFormatter({ trim: true });
      const newFormatter = formatter.withOptions({ uppercase: true });
      expect(formatter.format('  hello  ')).toBe('hello');
      expect(newFormatter.format('  hello  ')).toBe('HELLO');
    });
  });
});
