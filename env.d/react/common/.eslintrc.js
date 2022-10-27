module.exports = {
  root: true,
  env: {
    browser: true,
    node: true,
    es6: true,
    // jest: true,
  },
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:@typescript-eslint/recommended-requiring-type-checking',
    'plugin:import/recommended',
    'plugin:import/warnings',
    'prettier',
    // "prettier/@typescript-eslint"
  ],
  plugins: ['@typescript-eslint'],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    sourceType: 'module',
    project: './tsconfig.json',
  },
  settings: {
    react: {
      version: 'detect',
    },
    'import/resolver': {
      alias: {
        map: [
          ['@', './src'],
          ['@public', './public'],
        ],
        extensions: ['.js', '.jsx', '.ts', '.tsx'],
      },
    },
  },
  rules: {
    'import/order': [
      'error',
      {
        // グループごとの並び順
        groups: [
          'builtin', // node "builtin" のモジュール
          'external', // npm install したパッケージ
          'internal', // パス設定したモジュール
          ['parent', 'sibling'], // 親階層と子階層のファイル
          'object', // object-imports
          'type', // 型だけをインポートする
          'index', // 同階層のファイル
        ],
        // グループごとに改行を入れるか
        'newlines-between': 'always',
        // アルファベット順・大文字小文字を区別なし
        alphabetize: {
          order: 'asc',
          caseInsensitive: true,
        },
      },
    ],
    // 適当なルール
    '@typescript-eslint/ban-types': 'warn',
    '@typescript-eslint/ban-types': 'warn',
    /**
     * ^ @typescript-eslint/no-misused-promisesの回避策
     * https://github.com/typescript-eslint/typescript-eslint/blob/main/packages/eslint-plugin/docs/rules/no-misused-promises.md
     */
    '@typescript-eslint/no-misused-promises': [
      'error',
      {
        checksVoidReturn: false,
      },
    ],
  },
};
