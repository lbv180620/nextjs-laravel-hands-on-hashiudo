import { server } from './src/mocks/server';
import { cleanup } from '@testing-library/react';

beforeAll(() => {
  server.listen();
});

afterEach(() => {
  server.resetHandlers();
  cleanup();
});

afterAll(() => {
  server.close();
});
