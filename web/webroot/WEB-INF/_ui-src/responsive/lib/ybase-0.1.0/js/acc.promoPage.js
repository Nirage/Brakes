const promoPage = {
  _autoload: [['initPromoPageSorting', $('.js-promoPageSelect').length]],
  $allProducts: [],
  $sortedProducts: [],
  productsTotal: 0,
  productsVisibleOnLoad: 0,
  productsToLoadCount: 0,
  productsVisible: 0,
  $loadMoreBtn: '',
  loadMoreBtn: '.js-promoLoadMore',
  plpGrid: '.js-plpGrid',
  initPromoPageSorting: function () {
    this.$allProducts = $('.js-productItem');
    this.bindSelectChange('.js-promoPageSelect');
    this.cacheLoadMoreBtn(this.loadMoreBtn);
    this.bindLoadMoreBtn(this.loadMoreBtn);
    this.setLoadMoreValues();
  },
  setLoadMoreValues: function () {
    this.productsTotal = this.$allProducts.length;
    this.productsVisibleOnLoad = parseInt($('.js-initialNumberOfLoadedProducts').val());
    this.productsToLoadCount = parseInt($('.js-loadedMoreProductsCount').val());
    this.productsVisible = this.productsVisibleOnLoad;
  },

  cacheLoadMoreBtn: function (btnSelector) {
    this.$loadMoreBtn = $(btnSelector);
  },
  bindLoadMoreBtn: function (btnSelector) {
    $(document).on('click', btnSelector, this.displayMoreProducts);
  },
  displayMoreProducts: function () {
    var $hiddenProducts = $('.js-productItem.hide');
    $.each($hiddenProducts, function (key) {
      if (key < ACC.promoPage.productsToLoadCount) {
        $(this).removeClass('hide');
        ACC.promoPage.productsVisible += 1;
      }
    });
    if (ACC.promoPage.productsVisible >= ACC.promoPage.productsTotal) {
      ACC.promoPage.removeLoadMoreBtn();
    }
  },

  bindSelectChange: function (selector) {
    var _this = this;
    $(selector).on('change', function () {
      var $this = $(this);
      var value = $this.val();
      if (value) {
        _this.reOrderPage(value);
      }
    });
  },
  reOrderPage: function (orderType) {
    ACC.global.toggleSpinner(true);

    this.sortProducts(orderType, this.$allProducts);
    this.appendProducts(this.$sortedProducts, this.plpGrid);
    this.hideExtraProducts();

    ACC.global.toggleSpinner(false);
  },
  hideExtraProducts: function () {
    var HIDE_CLASS = 'hide';
    if (this.$sortedProducts.length > this.productsVisibleOnLoad) {
      this.productsVisible = this.productsVisibleOnLoad;

      $.each(this.$sortedProducts, function (key) {
        if (key >= ACC.promoPage.productsToLoadCount) {
          $(this).addClass(HIDE_CLASS);
        } else {
          $(this).removeClass(HIDE_CLASS);
        }
      });
      this.appendLoadMoreBtn();
    }
  },
  removeLoadMoreBtn: function () {
    $(ACC.promoPage.loadMoreBtn).remove();
  },

  appendLoadMoreBtn: function () {
    this.removeLoadMoreBtn();
    $(this.plpGrid).after(this.$loadMoreBtn);
  },
  sortProducts: function (sortType, productsList) {
    productsList.sort(function (a, b) {
      var $a = $(a).find('.js-productPrice').data('price');
      var $b = $(b).find('.js-productPrice').data('price');
      if (sortType == 'price-asc') {
        return $a - $b;
      }
      if (sortType == 'price-desc') {
        return $b - $a;
      }
    });
    this.$sortedProducts = productsList;
  },
  appendProducts: function (productsList, dest) {
    $(dest).html(productsList);
  }
};

export default promoPage;
