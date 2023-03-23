module.exports = {
  stories: ['../web/webroot/WEB-INF/_ui-src/**/*.stories.mdx', '../web/webroot/WEB-INF/_ui-src/**/*.stories.@(js|jsx|ts|tsx)'],
  addons: ['@storybook/addon-links', '@storybook/addon-essentials', '@storybook/addon-interactions', 'storybook-preset-less'],
  staticDirs: ['../public'],
  framework: '@storybook/vue',
  core: {
    builder: '@storybook/builder-webpack5'
  }
};
