const stickyMiniCart = {
  offset: 0,
  stickyElement: '',
  stickyParent: '',
  activeAttr: 'sticky-active',
  boundary: '',
  initialoffset: '',
  isScrolling: false,
  topNonStickyContentHeight: 0,

  /**
   * [init description]
   * @param  {string} stickyElementID    id of the element that needs to be sticky
   * @param  {string} stickyBoundaryID  id of the element that is bottom boundary
   * @param  {integer} stickyOffset      offset is number of pixels from the top of the viewport,
   *                                     where element becomes sticky
   * @return {void}
   */
  init: function (stickyElementID, stickyBoundaryID, offset) {
    this.offset = offset;
    this.initialoffset = offset;
    this.stickyElement = document.getElementById(stickyElementID);
    this.stickyParent = document.getElementById('js-miniBasketComponent');
    if (stickyBoundaryID !== null) {
      this.boundary = document.getElementById(stickyBoundaryID);
    }

    document.addEventListener('scroll', this.onScroll);
  },

  updateInitialOffset: function (newOffset) {
    this.initialoffset = newOffset;
  },

  // work is based on article: https://www.sitepoint.com/building-box-sticks-scroll/
  // please read for detail explanations
  onScroll: function () {
    var edge;
    var boundaryTop;
    //edge is where the current sticky should not persist beyond
    if (ACC.stickyMiniCart.boundary) {
      edge = ACC.stickyMiniCart.boundary.getBoundingClientRect().bottom;
      boundaryTop = ACC.stickyMiniCart.boundary.getBoundingClientRect().top;
    }

    //Each sticky, when scrolled beyond it's natural position, is moved
    //into a placeholder and the placeholder takes the place of the
    //sticky in the DOM so we know where to move it back when we're done.

    var rect = ACC.stickyMiniCart.stickyParent.getBoundingClientRect();
    var height = rect.height + ACC.stickyMiniCart.offset;

    if (rect.top < ACC.stickyMiniCart.offset) {
      if (edge > height) {
        $(ACC.stickyMiniCart.stickyParent).addClass('is-sticky');
        $(ACC.stickyMiniCart.stickyElement).css('top', ACC.stickyMiniCart.offset);
        $(ACC.stickyMiniCart.stickyParent).removeClass('is-scrolling');
      } else {
        $(ACC.stickyMiniCart.stickyParent).removeClass('is-sticky');
        $(ACC.stickyMiniCart.stickyParent).addClass('is-scrolling');
        ACC.stickyMiniCart.isScrolling = true;

        $(ACC.stickyMiniCart.stickyParent).css(
          'top',
          -(boundaryTop - edge + height + ACC.stickyMiniCart.topNonStickyContentHeight - ACC.stickyMiniCart.initialoffset)
        );
        ACC.stickyMiniCart.stickyElement.removeAttribute('style');
      }
    } else {
      $(ACC.stickyMiniCart.stickyParent).removeClass('is-scrolling');
      $(ACC.stickyMiniCart.stickyParent).removeClass('is-sticky');
      ACC.stickyMiniCart.stickyParent.removeAttribute('style');
      ACC.stickyMiniCart.stickyElement.removeAttribute('style');
      if (ACC.stickyMiniCart.isScrolling) {
        $(ACC.stickyMiniCart.stickyParent).addClass('is-sticky');
        $(ACC.stickyMiniCart.stickyElement).css('top', ACC.stickyMiniCart.offset);
        $(ACC.stickyMiniCart.stickyParent).removeClass('is-scrolling');
      }
      ACC.stickyMiniCart.isScrolling = false;
    }
  },

  destroy: function () {
    document.removeEventListener('scroll', ACC.stickyMiniCart.onScroll);
  },

  updateOffset: function (offset, topNonStickyContentHeight) {
    topNonStickyContentHeight = topNonStickyContentHeight || 0;
    this.offset = offset - topNonStickyContentHeight;
    this.topNonStickyContentHeight = topNonStickyContentHeight;
    if (this.stickyParent) {
      $(this.stickyParent).removeClass('.is-sticky');
    }
    if (this.stickyElement) {
      this.stickyElement.removeAttribute('style');
      this.onScroll();
    }
  }
};

export default stickyMiniCart;
