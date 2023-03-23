import Vue from 'vue';
import 'regenerator-runtime/runtime';

export default (obj: any, App: any) => {
  const { id, prop } = obj;

  new Vue({
    el: `#${id}`,
    components: { App },
    data() {
      return { obj };
    },
    template: `<App :${prop}="obj" />`
  });
};
