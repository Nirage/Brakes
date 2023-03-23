const asm = document.getElementById('_asm') as HTMLButtonElement;

const stickyASM = {
  _autoload: [['init', asm]],
  init(): void {
    const setHeaderPaddingTop = (): void => {
      const stickyHeader = asm.closest('.js-stickyHeader') as HTMLElement;
      const siteSearch = stickyHeader.querySelector('.site-search') as HTMLElement;
      const middleHeader = stickyHeader.querySelector('.js-navigation--middle') as HTMLElement;
      const nonStickyContent = document.querySelector('.js-nonStickyContent') as HTMLElement;
      const searchBarHeight: number = middleHeader.classList.contains('search-open') ? siteSearch.offsetHeight : 0;
      nonStickyContent.style.paddingTop = `${stickyHeader?.offsetHeight - searchBarHeight}px`;
    };

    setTimeout(setHeaderPaddingTop, 0);

    asm.addEventListener('click', setHeaderPaddingTop);
  }
};

export default stickyASM;
