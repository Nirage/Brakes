import ProductCarousel from './index.vue';

export default {
  title: 'Brakes/ProductCarousel',
  component: ProductCarousel
};

const Template = (args, { argTypes }) => ({
  props: Object.keys(argTypes),
  components: { ProductCarousel },
  template: '<ProductCarousel v-bind="$props" />'
});

export const Default = Template.bind({});
Default.args = {
  sfProductListData: {
    prop: 'sf-product-list-data',
    id: 'someId',
    url: '/json/getProducts.json',
    heading: 'Shop with Brakes',
    paragraph: 'This is a paragraph',
    maxNumberOfProducts: 12,
    notPlp: true,
    messageUpdate: 'Update message',
    messageOutOfStock: 'Out of stock message',
    messageDiscontinued: 'Discontinued message',
    messageAdd: 'Add',
    currencySymbol: '£',
    isLoggedIn: true,
    CSRFToken: 'pk001'
  }
};
