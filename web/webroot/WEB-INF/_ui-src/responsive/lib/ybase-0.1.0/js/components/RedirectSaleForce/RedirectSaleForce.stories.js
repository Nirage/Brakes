import RedirectSaleForce from './index.vue';

// More on default export: https://storybook.js.org/docs/vue/writing-stories/introduction#default-export
export default {
  title: 'Brakes/Popover',
  component: RedirectSaleForce
};

// More on component templates: https://storybook.js.org/docs/vue/writing-stories/introduction#using-args
const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { RedirectSaleForce },
  template: `<div class="flex justify-content-center align-items-center flex-direction-column" style="height: 300px">
    <redirect-sale-force @onClick="onClick" v-bind="$props" />
  </div>`
});

export const Default = Template.bind({});
// More on args: https://storybook.js.org/docs/vue/writing-stories/args
Default.args = {
  loaderData: {
    prop: 'loader-data',
    id: 'onload-loading',
    bodyMessage: 'You are being redirected to Help center.',
    errorMessage: 'An error has occurred. Please try again later.',
    backToHome: 'Back to homepage',
    noNewTab: '',
    url: 'https://www.brake.co.uk/sfCloudInstance/status'
  }
};
