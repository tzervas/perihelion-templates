import { afterEach, expect } from 'vitest';
import { cleanup } from '@testing-library/vue';
import '@testing-library/jest-dom';

// Runs a cleanup after each test case
afterEach(() => {
  cleanup();
});
