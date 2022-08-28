module.exports = {
  // setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],  
  testPathIgnorePatterns: ['<rootDir>/.next/', '<rootDir>/node_modules/'],
  moduleNameMapper: {
    '\\.(css)$': '<rootDir>/node_modules/jest-css-modules',
    '^@/(.*)$': '<rootDir>/src/$1',
  },
};
