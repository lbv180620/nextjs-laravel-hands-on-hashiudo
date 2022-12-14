module.exports = {
  extends: ["stylelint-config-standard", "stylelint-config-recess-order", "stylelint-config-prettier"],
  plugins: ["stylelint-scss"],
  customSyntax: "postcss-scss",
  ignoreFiles: ["**/node_modules/**", "/public/", "/.next/"],
  root: true,
  rules: {
    "at-rule-no-unknown": [
      true,
      {
        ignoreAtRules: ["tailwind", "apply", "variants", "responsive", "screen", "use"],
      },
    ],
    "scss/at-rule-no-unknown": [
      true,
      {
        ignoreAtRules: ["tailwind", "apply", "variants", "responsive", "screen"],
      },
    ],
    "declaration-block-trailing-semicolon": null,
    "no-descending-specificity": null,
    // https://github.com/humanmade/coding-standards/issues/193
    "selector-class-pattern": "^[a-zA-Z][a-zA-Z0-9_-]+$",
    "keyframes-name-pattern": "^[a-zA-Z][a-zA-Z0-9_-]+$",
    "selector-id-pattern": "^[a-z][a-zA-Z0-9_-]+$",
    "property-no-unknown": [
      true,
      {
        ignoreProperties: ["composes"],
      },
    ],
  },
};
