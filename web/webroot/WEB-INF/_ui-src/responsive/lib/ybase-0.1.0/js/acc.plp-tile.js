const plptile = {
  _autoload: [['initProductTile', $('.js-productItemTile').length]],
  productElements: $('.js-productItemTile'),
  productElementsTotal: $('.js-productItemTile').length,
  itemsPerPage: parseInt($('.js-productItemTilePerPage').val(), 10),
  initProductTile: function () {
    $(document).on('click', '.js-plpTileLoadMore', this.loadMoreTiles);
    ACC.plptile.initLoadMoreButton($('.js-productItemTile:not(.hide)').length);
  },
  loadMoreTiles: function () {
    $('.js_spinner').show();
    var elementsShowing = $('.js-productItemTile:not(.hide)').length;
    var lastItem =
      elementsShowing + ACC.plptile.itemsPerPage <= ACC.plptile.productElementsTotal
        ? elementsShowing + ACC.plptile.itemsPerPage
        : ACC.plptile.productElementsTotal;

    for (var elementCount = elementsShowing + 1; elementCount <= lastItem; elementCount++) {
      var targetElement = ACC.plptile.productElements[elementCount - 1];
      targetElement.classList.remove('hide');
    }
    ACC.plptile.initLoadMoreButton(lastItem);

    ACC.promo.getProductPromos();

    $('.js_spinner').hide();
  },
  initLoadMoreButton: function (elementsShowing) {
    if (ACC.plptile.productElementsTotal > elementsShowing) {
      $('.js-plpTileLoadMore').show();
    } else {
      $('.js-plpTileLoadMore').hide();
    }
  }
};

export default plptile;
