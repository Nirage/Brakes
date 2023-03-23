import Footer from './index.vue';

export default {
  title: 'Brakes/Footer',
  component: Footer
};

const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { Footer },
  template: '<Footer v-bind="$props" />'
});

export const Default = Template.bind({});
Default.args = {
  footerData: {
    prop: 'footer-data'
  }
};
