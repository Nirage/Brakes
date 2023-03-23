const minicart = {
  _autoload: [
    ['bindMiniCartStickyComponent', $('#js-stickyMiniBasket').length],
    ['bindMiniCartHeader', $('.js-miniCartHeader').length != 0]
  ],
  $miniBasketBoundary: {},
  $spinner: {},
  miniBasketDetailsUrl: '',
  $miniBasketDetails: {},
  stickyHeader: document.querySelector('.js-stickyHeader'),
  stickyHeaderHeight: document.querySelector('.js-stickyHeader') ? document.querySelector('.js-stickyHeader').getBoundingClientRect().height : 0,
  isMiniCartComponentExpanded: false,
  subComponentsInitialized: false,
  bindMiniCartStickyComponent: function () {
    ACC.minicart.$miniBasketBoundary = $('#js-stickyMiniBasketBoundary');
    ACC.minicart.$spinner = $('.js-miniBasketSpinner');
    ACC.minicart.miniBasketDetailsUrl = $('#js-miniBasketComponent').data('mini-basket-details-url');
    ACC.minicart.$miniBasketDetails = $('.js-miniBasketDetails');

    enquire.register('screen and (min-width:' + ACC.breakpoints.screenMdMin + ')', {
      match: function () {
        var initialOffset = ACC.minicart.stickyHeaderHeight;
        $(document).on('click', '.js-miniBasketExpand', ACC.minicart.handleMiniCartComponentExpand);
        $(document).on('click', '.js-miniBasketDetailsCollaps', ACC.minicart.handleMiniCartComponentCollaps);
        $(document).on('cookieBannerClosed', function () {
          var topNonStickyContentHeight;
          ACC.minicart.stickyHeaderHeight = ACC.minicart.stickyHeader.getBoundingClientRect().height;
          if (sessionStorage.getItem('isMiniCartComponentExpanded') === 'false') {
            ACC.stickyMiniCart.init('js-stickyMiniBasket', 'js-stickyMiniBasketBoundary', ACC.minicart.stickyHeaderHeight);
          } else {
            topNonStickyContentHeight = $('.js-miniBasketDetailsTop').height();
            ACC.stickyMiniCart.updateInitialOffset(ACC.minicart.stickyHeaderHeight);
            ACC.stickyMiniCart.updateOffset(ACC.minicart.stickyHeaderHeight, topNonStickyContentHeight);
          }
        });

        ACC.stickyMiniCart.init('js-stickyMiniBasket', 'js-stickyMiniBasketBoundary', initialOffset);

        ACC.cart.bindSavedCarts();
        ACC.product.bindRemoveItemMiniBasket();

        if (sessionStorage.getItem('isMiniCartComponentExpanded') === 'true') {
          ACC.minicart.handleMiniCartComponentExpand();
        }
      },

      unmatch: function () {
        $(document).off('click', '#js-stickyMiniBasket', ACC.minicart.handleMinicartComponentOnClick);
        $(document).off('click', '.js-miniBasketDetailsCollaps', ACC.minicart.handleMiniCartComponentCollaps);

        ACC.stickyMiniCart.destroy();
      }
    });
  },
  // Apply new grid only for desktop view
  updateGridClasses: function (applyNewGrid) {
    var $container = $('.js-productsGridContainer');

    $container.each(function () {
      var _$container = $(this);
      var newGrid = _$container.data('new-grid');
      var oldGrid = _$container.data('old-grid');

      _$container.removeClass(newGrid + ' ' + oldGrid);

      if (applyNewGrid) {
        _$container.addClass(newGrid);
      } else {
        _$container.addClass(oldGrid);
      }
    });
  },

  handleMiniCartComponentExpand: function () {
    ACC.minicart.$miniBasketBoundary.addClass('is-mb-active');
    ACC.minicart.updateGridClasses(true);
    sessionStorage.setItem('isMiniCartComponentExpanded', true);
    ACC.minicart.isMiniCartComponentExpanded = true;

    ACC.minicart.getMiniBasketContent();
    ACC.minicart.expandSimilarProductsCarousel('mbCarousel');
  },

  handleMiniCartComponentCollaps: function () {
    ACC.minicart.removeMiniBasketContent();
    ACC.minicart.$miniBasketBoundary.removeClass('is-mb-active');
    ACC.minicart.updateGridClasses(false);
    sessionStorage.setItem('isMiniCartComponentExpanded', false);
    ACC.minicart.isMiniCartComponentExpanded = false;
    ACC.stickyMiniCart.updateOffset(ACC.minicart.stickyHeaderHeight);
    ACC.cartactions.unbindEventListeners();
    ACC.minicart.collapsSimilarProductsCarousel('productCarousel');
  },

  expandSimilarProductsCarousel: function () {
    ACC.plp.refreshSimilarSection('similar-products-mb');
  },
  collapsSimilarProductsCarousel: function () {
    ACC.plp.refreshSimilarSection('similar-products');
  },
  getMiniBasketContent: function () {
    var url = ACC.minicart.miniBasketDetailsUrl;
    var callback = ACC.minicart.getContent;
    ACC.global.checkLoginStatus(callback, url);
  },

  getContent: function (url) {
    ACC.cartactions.unbindEventListeners();
    if (ACC.minicart.isMiniCartComponentExpanded) {
      ACC.minicart.$spinner.removeClass('hide');
      $.ajax({
        url: url,
        cache: false,
        type: 'GET',
        dataType: 'html',
        success: function (response) {
          ACC.minicart.showMiniCartGlobalMsg(response);
          ACC.global.initPopoversCollapsable();
          ACC.minicart.updateMiniBasketWithContent(response);
          ACC.cart.bindProductUnavailableModal();
          if (!ACC.minicart.subComponentsInitialized) {
            ACC.quickAdd.initQuickAdd();
            ACC.minicart.bindPrintCart();
            $(document).on('click', '.js-toggleMiniBasketQtyPicker', ACC.minicart.toggleQuantityPicker);
            ACC.minicart.subComponentsInitialized = true;
          }
        }
      });
    }
  },

  bindMiniCartHeader: function () {
    $(document).on('click keypress', '.js-miniCartHeader', function (e) {
      e.preventDefault();
      if (!ACC.global.keyPressCheck(e)) {
        return false;
      }
      ACC.global.checkLoginStatus(function () {
        var url = $(e.target).attr('href');
        window.location.href = encodeURI(url);
      });
    });
  },

  bindPrintCart: function () {
    $(document).on('click', '.js-miniCartPrint', function () {
      $('body').addClass('is-printing-basket');
      var $miniCartPrintHolder = $('.js-miniCartPrintHolder');
      $miniCartPrintHolder.html($('.js-miniCartPrintWrapper').html());
      window.print();
    });
  },

  updateMiniBasketWithContent: function (response) {
    var topNonStickyContentHeight;
    ACC.minicart.$spinner.addClass('hide');

    ACC.minicart.$miniBasketDetails.html(response);

    ACC.cartactions.initHeaderMenu();
    topNonStickyContentHeight = $('.js-miniBasketDetailsTop').height();
    ACC.stickyMiniCart.updateOffset(ACC.minicart.stickyHeaderHeight, topNonStickyContentHeight);
    if (window.quickAddQtyExceeds) {
      $('#quantityMaximumPopup').modal('show');
    }
  },

  removeMiniBasketContent: function () {
    ACC.minicart.$miniBasketDetails.html('');
  },

  /**
   * Method used to update Mini Cart Display in Header
   * @param {Boolean} updateMiniCartContent true when content of minicart needs to be updated
   * when false, only minicart component counter is updated
   */
  updateHeaderMiniCart: function (updateMiniCartContent) {
    var $miniCartHeader = $('.js-miniCartHeader');
    var miniCartRefreshUrl = $miniCartHeader.data('miniCartRefreshUrl');
    $.ajax({
      url: miniCartRefreshUrl,
      cache: false,
      type: 'GET',
      dataType: 'json',
      success: function (jsonData) {
        var $numberItem = $('<span>').addClass('nav-items-total').text(jsonData.miniCartCount);
        $miniCartHeader.find('.js-miniCartCount').empty();
        $miniCartHeader.find('.js-miniCartCount').append($numberItem);
        $miniCartHeader.find('.js-miniCartPrice').text(jsonData.miniCartPrice);
        ACC.minicart.updateMiniCartComponent(jsonData.miniCartCount, updateMiniCartContent);
        ACC.minicart.toggleCheckoutBtn(jsonData.miniCartCount);
      }
    });
  },
  toggleCheckoutBtn: function (itemsCount) {
    var HAS_CLASS = 'has-items';
    var $btn = $('.js-btnCheckoutHeader');
    if (itemsCount > 0) {
      $btn.addClass(HAS_CLASS);
    } else {
      $btn.removeClass(HAS_CLASS);
    }
  },
  updateMiniCartComponent: function (miniCartCount, updateMiniCartContent) {
    $('.js-miniBasketTotal').text(miniCartCount);
    if (ACC.minicart.isMiniCartComponentExpanded && updateMiniCartContent) {
      ACC.minicart.getMiniBasketContent();
    }
  },

  toggleQuantityPicker: function () {
    $(this).parents('.mini-basket-product').find('.js-miniBasketQtyPicker').toggleClass('hide');
  },

  showMiniCartGlobalMsg: function (response) {
    var globalMessage = $(response).find('.js-miniCartGlobalMessages').html();
    if (globalMessage.length > 0) {
      if (globalMessage.trim() !== '') {
        $('.js-miniCartGlobalMessagesHolder').html(globalMessage);
      }
    }
  }
};

export default minicart;
