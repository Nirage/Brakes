import Hello from './index.vue';

// More on default export: https://storybook.js.org/docs/vue/writing-stories/introduction#default-export
export default {
  title: 'React-Migration/Hello',
  component: Hello
};

// More on component templates: https://storybook.js.org/docs/vue/writing-stories/introduction#using-args
const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { Hello },
  template: '<Hello v-bind="$props" />'
});

export const Default = Template.bind({});
// More on args: https://storybook.js.org/docs/vue/writing-stories/args
Default.args = {
  helloData: {
    prop: 'hello-data',
    id: 'hello-component',
    msg: 'Well Hello there'
  }
};
