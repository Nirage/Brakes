import Amplience from './index.vue';

export default {
  title: 'Brakes/Amplience',
  component: Amplience
};

const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { Amplience },
  template: '<Amplience v-bind="$props" />'
});

export const Default = Template.bind({});
Default.args = {
  amplienceData: {
    prop: 'amplience-data'
  }
};
