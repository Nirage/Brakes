import productCarousel from '../components/ProductCarousel/ProductCarousel';

const d = document;

const productCarouselAll = d.querySelectorAll('.js-cartProductsCarousel') as NodeListOf<HTMLDivElement>;
const productCarouselLength = productCarouselAll.length as number;
productCarouselLength && productCarousel(productCarouselAll, productCarouselLength === 1 ? 4 : 2, true);
