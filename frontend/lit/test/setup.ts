import '@testing-library/jest-dom';
import { beforeAll, afterAll } from 'vitest';

beforeAll(() => {
  // Setup Web Components polyfills
  const polyfills = document.createElement('script');
  polyfills.src = require.resolve('@webcomponents/webcomponentsjs/webcomponents-bundle.js');
  document.head.appendChild(polyfills);
});

afterAll(() => {
  // Cleanup any global state
});
