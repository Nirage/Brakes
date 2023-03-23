import breakpoints from '../../acc.breakpoints';

export default (listOfElements: NodeListOf<HTMLDivElement>, items: number, dots: boolean) => {
  listOfElements.forEach((element: HTMLDivElement) => {
    const mq = window.matchMedia(`(min-width: ${breakpoints.screenSm})`) as MediaQueryList;
    const itemWidth = element.parentElement?.clientWidth as number;
    const itemList = element.querySelectorAll('.product-item') as NodeListOf<HTMLDivElement>;

    const setCheckoutColumn = (wrapper: HTMLDivElement, comp: HTMLDivElement): void => {
      wrapper?.classList.remove('product-recommendations--loading');
      const columnWidth = listOfElements.length > 1 ? ['col-xs-12', 'col-sm-6'] : ['col-xs-12'];
      comp?.classList.add(...columnWidth);
    };

    const removeSkeletonLoader = (target: HTMLDivElement): void => {
      const skeleton = target.nextElementSibling! as HTMLDivElement;
      skeleton.parentNode?.removeChild(skeleton);
      target.classList.remove('hide');
    };

    const qtyBtnHandler = (e: Event): void => {
      const target = e.currentTarget as HTMLButtonElement;
      const currentQuantityField = target.parentElement?.querySelector('.js-productQtyInput') as HTMLInputElement;
      const { action } = target.dataset;
      let getCurrentQuantity = parseInt(currentQuantityField.value);
      const quantityField = target.closest('form')?.querySelector('[name="qty"]') as HTMLInputElement;
      const updateQuantity = action === 'add' ? getCurrentQuantity + 1 : getCurrentQuantity - 1;
      quantityField.value = updateQuantity.toString();
    };

    const updateProductQuantity = (e: Event): void => {
      const target = e.target as HTMLButtonElement;
      const quantityField = target.closest('form')?.querySelector('[name="qty"]') as HTMLInputElement;
      quantityField.value = target.value;
    };

    const onInitialized = (e: Event) => {
      const target = e.target as HTMLDivElement;
      const comp = target.closest('.product-recommendations') as HTMLDivElement;
      const wrapper = comp?.parentElement as HTMLDivElement;
      const page = wrapper?.dataset['page'];
      const reponsiveItems = mq.matches ? items : 1;

      itemList.forEach((item: HTMLDivElement): void => {
        item.style.width = `${itemWidth / reponsiveItems - 32}px`;
        item.querySelectorAll('.js-qtyBtn').forEach((qtyBtn): void => qtyBtn.addEventListener('click', qtyBtnHandler));
        item.querySelector('.js-productQtyInput')?.addEventListener('change', updateProductQuantity);
      });

      page === 'checkoutPage' && mq.matches && setCheckoutColumn(wrapper, comp);

      removeSkeletonLoader(target);
    };

    $(element).owlCarousel({
      loop: false,
      nav: true,
      center: itemList.length === 1,
      navText: [
        "<i class='icon icon-chevron-left carousel-nav carousel-nav--left'></i>",
        "<i class='icon icon-chevron-right carousel-nav carousel-nav--right'></i>"
      ],
      responsive: {
        0: {
          stagePadding: 50,
          items: 1,
          margin: 20
        },
        768: {
          items,
          dots
        }
      },
      onInitialized
    });
  });
};
