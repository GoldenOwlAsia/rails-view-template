export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'body-max-line-length': [1, 'always', 200],
    'subject-case': [0],
  },
  ignores: [(message) => message.includes('CodeFactor')],
};
