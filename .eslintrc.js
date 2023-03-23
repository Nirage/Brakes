module.exports = {
  root: true,
  env: {
    browser: true,
    node: true,
    es6: true,
    jquery: true
  },
  extends: ['eslint:recommended', 'plugin:vue/recommended', 'plugin:vue/base', 'plugin:storybook/recommended', 'plugin:storybook/recommended', 'plugin:storybook/recommended'],
  parserOptions: {
    ecmaVersion: 6,
    sourceType: 'module'
  },
  parser: ['@typescript-eslint/parser', 'vue-eslint-parser'],
  globals: {
    ACC: true,
    google: true,
    enquire: true,
    Imager: true
  },
  rules: {
    // enable additional rules
    //"linebreak-style": ["error", "unix"],

    // override default options for rules from base configurations
    'no-cond-assign': ['error', 'always'],
    // disable rules from base configurations
    'no-console': 'off',
    'comma-dangle': 0,
    'no-mixed-spaces-and-tabs': 0
  }
};