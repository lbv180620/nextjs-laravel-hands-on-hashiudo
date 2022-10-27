module.exports = {
    env: {
        browser: true,
        // es6: true,
        es2021: true,
        node: true,
        'jest/globals': true
    },
    extends: [
        "eslint:recommended",
        // "plugin:@typescript-eslint/recommended", // TypeScriptでチェックされる項目をLintから除外する設定
        // 'plugin:@typescript-eslint/eslint-recommended',
        // 'plugin:@typescript-eslint/recommended-requiring-type-checking',
        "plugin:react-hooks/recommended",
        "plugin:react/recommended",
        'plugin:jest/recommended',
        "plugin:tailwindcss/recommended",
        // "airbnb",
        "prettier", // prettierのextendsは他のextendsより後に記述する
        "prettier/@typescript-eslint",
        "prettier/react"
    ],
    plugins: [
        "jest",
        // "jest-dom",
        // "testing-library",
        "@typescript-eslint",
        // "import",
        // "jsx-a11y",
        "react",
        "react-hooks"
    ],
    ignorePatterns: ['**/node_modules/**', '/public/', '/resources/js/**/*'],
    parser: "@typescript-eslint/parser",
    parserOptions: {
        "ecmaFeatures": {
            "jsx": true
        },
        "ecmaVersion": 2021,
        "sourceType": "module",
        "project": "./tsconfig.json" // TypeScriptのLint時に参照するconfigファイルを指定
    },
    root: true, // 上位ディレクトリにある他のeslintrcを参照しないようにする
    globals: {
        "jQuery": "readonly",
        "$": "readonly",
        Atomics: "readonly",
        SharedArrayBuffer: "readonly",
        React: "writable",
    },
    rules: {
        'prefer-const': 'error',
        'react/react-in-jsx-scope': 'off',
        'jest/no-disabled-tests': 'warn',
        'jest/no-focused-tests': 'error',
        'jest/no-identical-title': 'error',
        'jest/prefer-to-have-length': 'warn',
        'jest/valid-expect': 'error'
    },
    settings: {
        react: { version: "detect" },
        "import/resolver": {
            "node": {
                "extensions": [
                    ".js",
                    ".jsx",
                    ".ts",
                    ".tsx"
                ]
            }
        }
    }
}
