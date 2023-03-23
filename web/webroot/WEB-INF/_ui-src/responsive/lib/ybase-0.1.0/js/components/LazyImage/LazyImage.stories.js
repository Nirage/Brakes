import LazyImage from './index.vue';

export default {
  title: 'Brakes/LazyImage',
  component: LazyImage
};

const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { LazyImage },
  template: '<LazyImage v-bind="$props" />'
});

export const Default = Template.bind({});
Default.args = {
  lazyImageData: {
    prop: 'lazy-image-data',
    url: 'https://i1.adis.ws/i/Brakes/BRA3727-Buy-With-Confidence-Assets-P1-New-Cards-2022update-awardwinningfood'
  }
};
