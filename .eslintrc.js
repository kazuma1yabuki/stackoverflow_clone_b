module.exports = {
  extends: [
    'plugin:vue/recommended',
    'airbnb',
  ],
  env: {
    mocha: true,
    browser: true,
  },
  globals: {
    expect: true,
  },
  rules: {
    'func-names': 0,  // too verbose
    'import/first': 0,  // for test
    'import/extensions': 0, // for @
    'import/no-unresolved': [
      'error',
      {
        ignore: [ '@/' ],
      },
    ],
    'max-len': ['error', { 'code': 140 }],
    'no-console': 0,  // for console on debug and console.assert()
    'no-underscore-dangle': 0,  // for id
    'object-shorthand': 0,  // for vue's arrow problem
    'prefer-arrow-callback': 0, // for mocha and vue
  },
  settings: {
    'import/resolver': {
      node: {
        extensions: ['.js','.jsx','.vue'],
      },
    },
  },
}
