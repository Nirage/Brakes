import Popover from './index.vue';

// More on default export: https://storybook.js.org/docs/vue/writing-stories/introduction#default-export
export default {
  title: 'Brakes/Popover',
  component: Popover
};

// More on component templates: https://storybook.js.org/docs/vue/writing-stories/introduction#using-args
const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { Popover },
  template: '<popover @onClick="onClick" v-bind="$props" />'
});

export const Primary = Template.bind({});
// More on args: https://storybook.js.org/docs/vue/writing-stories/args
Primary.args = {
  popoverData: {
    prop: 'loader-data',
    id: 'onload-loading',
    bodyMessage: 'You are being redirected to Help center.',
    errorMessage: 'An error has occurred. Please try again later.',
    backToHome: 'Back to homepage ',
    noNewTab: '',
    url: 'https://www.brake.co.uk/sfCloudInstance/status'
  }
};
