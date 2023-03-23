const promo = {
  _autoload: [
    ['initComplexPromoInfo', $('.js-triggerComplexPromo').length],
    ['getProductPromos', document.body.querySelectorAll('.js-productPromoIcon').length]
  ],
  readMore: '.js-promoComplexMsgMore',
  msgPart2: '.js-promoComplexMsgPart2',
  readLess: '.js-promoComplexMsgLess',
  ellipses: '.js-promoComplexMsgEllipses',
  $complexModal: $('#promoComplexInfoModal'),
  $complexPromoTrigger: $('.js-triggerComplexPromo'),

  getProductPromos: function () {
    var getPromos = false;
    if ((ACC.config.search || ACC.config.plp || ACC.config.pdp) && ACC.config.authenticated) {
      getPromos = true;
    } else if ($('.js-PromoEnabledList').length > 0) {
      // add this class to a product list to turn on promos for a page
      getPromos = true;
    }
    getPromos && this.loadProductPromos();
  },

  loadProductPromos: function () {
    var products = document.body.querySelectorAll('.js-productPromoIcon');
    var getProductCodes = this.getPromoProductList(products);

    $.ajax({
      url: ACC.config.productPromoUrl,
      data: JSON.stringify(getProductCodes),
      contentType: 'application/json',
      cache: false,
      type: 'POST',
      success: function (response) {
        if ($.isEmptyObject(response)) {
          ACC.promo.handleEmptyPromosResponse(products);
        } else {
          ACC.promo.handlePromosResponse(response);
        }
      },
      error: function () {
        console.error('...error loading promotions');
      }
    });
  },

  getPromoProductList: function (products) {
    var productCodes = [];
    products.length &&
      products.forEach(function (product) {
        var code = product.dataset['code'];
        code && productCodes.push(code);
      });
    // Make sure to request unique ID
    return window.array_unique(productCodes);
  },

  handleEmptyPromosResponse: function (products) {
    products.forEach(function (promoIcon) {
      promoIcon.classList.remove('js-productPromoIcon');
    });
  },

  handlePromosResponse: function (response) {
    response.map(function (product) {
      var body = document.body;
      var dataCode = "[data-code='" + product.code + "']";
      var promoIcon = body.querySelector('.js-productPromoIcon' + dataCode);
      var promoParent = promoIcon.closest('.js-productItemBorder' + dataCode);
      var promoTab = body.querySelector('.js-productPromoTab' + dataCode);
      if (product.hasPotentialPromo || promoIcon.classList.contains('js-wasPrice')) {
        // turn on the promo roundel
        promoIcon.classList.remove('hidden');
        promoParent && promoParent.classList.add('product-item--promotion-border', 'overflow-hide');
        promoTab && promoTab.classList.remove('hidden');
      } else {
        promoIcon.classList.add('hidden');
        promoParent && promoParent.classList.remove('product-item--promotion-border', 'overflow-hide');
        promoTab && promoTab.classList.add('hidden');
      }
      promoIcon.classList.remove('js-productPromoIcon');
      promoParent && promoParent.classList.remove('js-productItemBorder');
      promoTab && promoTab.classList.remove('js-productPromoTab');
    });
  },

  initComplexPromoInfo: function () {
    this.initReadMore();

    enquire.register('screen and (max-width:' + ACC.breakpoints.screenXsMax + ')', {
      match: function () {
        ACC.promo.initComplexPromoModal();
      },
      unmatch: function () {
        ACC.promo.initComplexPromoPopovers();
        ACC.promo.terminateComplexPromoModal();
      }
    });

    enquire.register('screen and (min-width:' + ACC.breakpoints.screenSmMin + ')', {
      match: function () {
        ACC.promo.initComplexPromoPopovers();
      },
      unmatch: function () {
        ACC.promo.initComplexPromoModal();
        ACC.promo.terminateComplexPromoPopovers();
      }
    });
  },

  initReadMore: function () {
    $(document).on('click', ACC.promo.readMore, ACC.promo.toggleMoreLessContent);
    $(document).on('click', ACC.promo.readLess, ACC.promo.toggleMoreLessContent);
  },

  toggleMoreLessContent: function (e) {
    var wrapper = $(e.target).parent();
    wrapper.find(ACC.promo.readMore).toggleClass('hide');
    wrapper.find(ACC.promo.ellipses).toggleClass('hide');
    wrapper.find(ACC.promo.msgPart2).toggleClass('hide');
    wrapper.find(ACC.promo.readLess).toggleClass('hide');
  },

  initComplexPromoPopovers: function () {
    var commonContent = ACC.promo.$complexModal.find('.modal-body').html();
    var customTemplate =
      '<div class="popover js-promoComplexPopover" role="tooltip"><div class="arrow"></div><div class="popover__header"><div class="js-complexPromoTitleDest promo__offer-title"></div><button class="icon icon--sm icon-close popover-close js-popoverClose"></button></div><div class="popover-content"></div></div>';

    ACC.promo.$complexPromoTrigger.popover({
      html: true,
      content: function () {
        return commonContent;
      },
      template: customTemplate,
      trigger: 'manual'
    });

    $(document).on('mouseenter touchstart', '.js-triggerComplexPromo', ACC.promo.popoverShow);
    $(document).on('click', '.js-popoverClose', function () {
      $(this).parents('.popover').popover('hide');
    });
  },

  terminateComplexPromoPopovers: function () {
    $(document).off('mouseenter touchstart', '.js-triggerComplexPromo', ACC.promo.popoverShow);
    ACC.promo.$complexPromoTrigger.popover('hide');
  },

  initComplexPromoModal: function () {
    $('.js-triggerComplexPromo').on('click', ACC.promo.showComplexPromoModal);
  },

  terminateComplexPromoModal: function () {
    ACC.promo.hideComplexPromoModal();
    ACC.promo.$complexPromoTrigger.off('click', ACC.promo.showComplexPromoModal);
  },

  showComplexPromoModal: function () {
    var title = $(this).parent().find('.js-complexPromoTitleSrc').html();
    ACC.promo.$complexModal.one('show.bs.modal', function () {
      var $promoTitleDest = $(this).find('.js-complexPromoTitleDest');
      if (title) {
        $promoTitleDest.html(title);
        $promoTitleDest.removeClass('hide');
      } else {
        $promoTitleDest.addClass('hide');
      }
    });
    ACC.promo.$complexModal.modal('show');
  },

  hideComplexPromoModal: function () {
    ACC.promo.$complexModal.modal('hide');
  },

  popoverShow: function () {
    var title = $(this).parent().find('.js-complexPromoTitleSrc').html();
    $(this).one('inserted.bs.popover', function () {
      var $promoTitleDest = $(this).parent().find('.js-complexPromoTitleDest');
      if (title) {
        $promoTitleDest.html(title);
      } else {
        $promoTitleDest.remove();
      }
    });

    $(this).popover('show');
  }
};

export default promo;
