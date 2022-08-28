module.exports = {
  root: true, // ルートに設定ファイルがある場合はtrue。上位ディレクトリを検索しない）
  env: {
    browser: true, // ブラウザのグローバル変数を有効にする。
    node: true, // Node.jsのグローバル変数やスコープを有効にします。
    es6: true, // ECMAScript6のモジュールを除いた全ての機能が使用可能になります。
    // jest: true,
  },
  // 追加でまとめられたルールを設定。
  extends: [
    "eslint:recommended",
    "next",
    "next/core-web-vitals",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/recommended-requiring-type-checking",
    "plugin:import/recommended",
    "plugin:import/warnings",
    "prettier",
    // "prettier/@typescript-eslint"
  ],
  plugins: ["@typescript-eslint"], // サードパーティ用のプラグインを追加
  parser: "@typescript-eslint/parser",
  parserOptions: {
    sourceType: "module",
    // envの設定と重複するので不要
    // ecmaVersion: 12,
    // eslint-plugin-reactを適応させている場合不要
    // ecmaFeatures: {
    //   jsx: true,
    // },
    // extends で指定しているplugin:@typescript-eslint/recommended-requiring-type-checkingに対して型情報を提供するため tsconfig.json の場所を指定。
    project: "./tsconfig.json",
  },
  settings: {
    // Reactのバージョンを指定。detectにすることでインストールしているバージョンを参照してくれる。
    react: {
      version: "detect",
    },
    // Next.jsの場合不要
    // 'import/resolver': {
    //   node: {
    //     extensions: ['.js', '.jsx', '.ts', '.tsx', 'json'],
    //   },
    //   typescript: { project: './' },
    //   typescript: {
    //     config: path.join(__dirname, './webpack.config.js'),
    //     alwaysTryTypes: true,
    //   },
    // },
  },
  rules: {
    "import/order": [
      "error",
      {
        // グループごとの並び順
        groups: [
          "builtin", // node "builtin" のモジュール
          "external", // npm install したパッケージ
          "internal", // パス設定したモジュール
          ["parent", "sibling"], // 親階層と子階層のファイル
          "object", // object-imports
          "type", // 型だけをインポートする
          "index", // 同階層のファイル
        ],
        // グループごとに改行を入れるか
        "newlines-between": "always",
        // アルファベット順・大文字小文字を区別なし
        alphabetize: {
          order: "asc",
          caseInsensitive: true,
        },
      },
    ],
    // 適当なルールを設定
    "react/display-name": "off",
    "@typescript-eslint/ban-types": "warn",
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
