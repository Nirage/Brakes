import productCarousel from '../components/ProductCarousel/ProductCarousel';

const d = document;

const productCarouselAll = d.querySelectorAll('.js-cartProductsCarousel') as NodeListOf<HTMLDivElement>;
productCarouselAll.length && productCarousel(productCarouselAll, 1, false);
