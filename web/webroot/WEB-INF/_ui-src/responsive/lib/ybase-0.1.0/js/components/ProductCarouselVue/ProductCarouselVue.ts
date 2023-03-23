import observer from '../../utils/observer';
import ProductCarouselVue from './index.vue';

export default (configurations: { [key: string]: any }) => {
  interface Object {
    prop: string;
    id: string;
    url: string;
    heading: string;
    paragraph: string;
    maxNumberOfProducts: number;
    notPlp?: boolean;
    messageUpdate?: string;
    messageOutOfStock?: string;
    messageDiscontinued?: string;
    messageAdd?: string;
    currencySymbol: string;
    isLoggedIn: boolean;
    CSRFToken: string;
  }

  const sfProductList = document.getElementById('vue-sf-product-list') as HTMLDivElement;
  if (!sfProductList) return;
  const { id, dataset } = sfProductList;
  const { maxNumberOfProducts, notPlp, messageUpdate, messageOutOfStock, messageDiscontinued, messageAdd } = dataset;
  const heading = sfProductList.querySelector('.site-header__text')?.textContent as string;
  const paragraph = sfProductList.querySelector('.site-header__subtext')?.textContent as string;
  const { currencySymbol, authenticated, CSRFToken } = configurations;

  const obj: Object = {
    prop: 'sf-product-list-data',
    id,
    url: '/interactionStudio/getProducts',
    heading,
    paragraph,
    maxNumberOfProducts: parseInt(maxNumberOfProducts as string),
    notPlp: notPlp === 'true',
    messageUpdate,
    messageOutOfStock,
    messageDiscontinued,
    messageAdd,
    currencySymbol,
    isLoggedIn: authenticated,
    CSRFToken
  };

  observer(obj, ProductCarouselVue);
};
