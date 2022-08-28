module.exports = {
  // setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  testPathIgnorePatterns: ['<rootDir>/build/', '<rootDir>/node_modules/'],
  moduleNameMapper: {
    '\\.(css)$': '<rootDir>/node_modules/jest-css-modules',
    '^@/(.*)$': '<rootDir>/src/$1',
  },
};
