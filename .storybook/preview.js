import '../web/webroot/WEB-INF/_ui-src/responsive/themes/brakes/less/style.less';

export const parameters = {
  actions: { argTypesRegex: '^on[A-Z].*' },
  controls: {
    matchers: {
      color: /(background|color)$/i,
      date: /Date$/
    }
  }
};
