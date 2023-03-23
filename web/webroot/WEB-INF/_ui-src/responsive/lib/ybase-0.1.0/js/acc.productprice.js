const productprice = {
  _autoload: [
    ['loadPrices', $('.js-loadPrice').length > 0 && ACC.config.ajaxPricingEnabled],
    ['initTradeCalculator', $('.js-tradeCalculatorForm').length],
    ['checkTradeDiscountSession', ACC.config.plp || ACC.config.search || (ACC.config.pdp && !ACC.config.authenticated)]
  ],
  discountVal: 0,
  RECALCULATED_PRICE: 'js-recalculatedPrice',
  RECALCULATED_CLASS: 'recalculated',
  loadPrices: function () {
    var productCodes = ACC.productprice.getProductCodes();
    if (productCodes.length > 0) {
      ACC.productprice.getPrices(productCodes);
    }
  },

  checkTradeDiscountSession: function () {
    var gotSessionItem = sessionStorage.getItem('tradeDiscountCalc');
    if (gotSessionItem && gotSessionItem != '') {
      ACC.productprice.discountVal = parseInt(gotSessionItem);
      $('.js-tradeCalculatorForm').find('.js-tradeCalculatorDiscount').val(ACC.productprice.discountVal);
      // update the view
      ACC.productprice.recalculateProductPrices();
    }
  },

  setTradeDiscountSession: function () {
    sessionStorage.setItem('tradeDiscountCalc', ACC.productprice.discountVal);
  },

  getProductCodes: function () {
    var productCodes = [];
    $('.js-loadPrice').each(function (i, productItem) {
      var isHidden = $(productItem).parent('.js-productItem').hasClass('hide');
      if (!isHidden) {
        productCodes.push(productItem.dataset['productCode']);
      }
    });
    // Make sure to request unique ID
    return window.array_unique(productCodes);
  },

  getPrices: function (productCodes, $parentContainer) {
    $.ajax({
      url: ACC.config.pricingUrl,
      data: JSON.stringify(productCodes),
      contentType: 'application/json',
      cache: false,
      type: 'POST',
      success: function (response) {
        if ($.isEmptyObject(response.prices)) {
          productCodes.forEach(function (productCode) {
            var priceHolderSelector = "div[data-product-code='" + productCode + "']";
            var $priceHolder = $parentContainer ? $parentContainer.find(priceHolderSelector) : $(priceHolderSelector);
            ACC.productprice.priceUnavailable($priceHolder, ACC.productprice.getCartEnableButton($priceHolder));
            $priceHolder.removeClass('js-loadPrice');
          });
          $(document).trigger('getPricesDone');
        } else {
          ACC.productprice.handleGetPricesResponse(response, $parentContainer);
        }
      },
      error: function () {
        console.error('...error loading prices');
        ACC.global.checkLoginStatus();
      }
    });
  },

  handleGetPricesResponse: function (response, $parentContainer) {
    response.prices.forEach(function (priceInfo) {
      var priceHolderSelector = "div[data-product-code='" + priceInfo.productCode + "']:not(.js-editWishlist)";
      var $priceHolder = $parentContainer ? $($parentContainer).find(priceHolderSelector) : $(priceHolderSelector);
      if (priceInfo.price) {
        if (priceInfo.estimatedPrice) {
          ACC.productprice.setWeightedPriceValues($priceHolder, priceInfo);
        } else {
          ACC.productprice.setNormalPriceValues($priceHolder, priceInfo);
        }
        ACC.productprice.setWasPriceValues($priceHolder, priceInfo);
      } else {
        ACC.productprice.priceUnavailable($priceHolder, ACC.productprice.getCartEnableButton($priceHolder));
      }

      $priceHolder.removeClass('js-loadPrice');
    });

    if ($parentContainer) {
      if (!$parentContainer.hasClass('ui-autocomplete')) {
        ACC.gtmDataLayer.updatePriceEngineResponse(response);
      }
    } else {
      ACC.gtmDataLayer.updatePriceEngineResponse(response);
    }

    $(document).trigger('getPricesDone');
  },

  priceUnavailable: function ($priceHolder, $enableBtns) {
    $priceHolder.parents('.js-productItemPrice').removeClass('has-was-price').removeClass('is-weighted-product');
    $priceHolder.find('.js-loadPriceValue').html(ACC.config.priceUnavailable);
    $enableBtns.prop('disabled', 'disabled');
    $enableBtns.addClass('priceUnavailable');
  },

  setNormalPriceValues: function ($priceHolder, priceInfo) {
    var priceDivider = $priceHolder.data('price-per-divider');
    $priceHolder.find('.js-loadPriceValue').html(priceInfo.price.formattedValue);
    $(".js-addToCartForm[data-id='" + parseInt(priceInfo.productCode) + "']")
      .find('[name=productPostPrice]')
      .val(priceInfo.price.value);
    if (priceDivider == 0 || !priceDivider) {
      priceDivider = 1;
    }
    if (priceDivider && priceDivider > 0) {
      var calcPrice = ((priceInfo.price.value / priceDivider) * 100) / 100;
      $priceHolder.find('.js-unitPrice').html(calcPrice.toFixed(2));
      $priceHolder.find('.js-loadPriceEach').removeClass('hidden');
    }
    $priceHolder.find('.js-loadPriceVAT').removeClass('hidden');
  },

  setWeightedPriceValues: function ($priceHolder, priceInfo) {
    $priceHolder.find('.js-loadPriceValue').html($('<span>').text(priceInfo.estimatedPrice.formattedValue)).addClass('is-weighted-product');
    $(".js-addToCartForm[data-id='" + parseInt(priceInfo.productCode) + "']")
      .find('[name=productPostPrice]')
      .val(priceInfo.estimatedPrice.value);
    $priceHolder
      .find('.js-loadPriceEach')
      .addClass('is-weighted-product')
      .html($('<span>').addClass('js-unitPrice').text(priceInfo.price.formattedValue.replace(/\s+/g, '')));
    $priceHolder.find('.js-loadPriceVAT').removeClass('hidden');
    $priceHolder.find('.js-loadPriceEach').removeClass('hidden');
  },

  setWasPriceValues: function ($priceHolder, priceInfo) {
    var HAS_WAS_PRICE = 'has-was-price';
    var $priceHolderParents = $priceHolder.parents('.js-productItemPrice');

    if (priceInfo.estimatedWasPrice != null) {
      $priceHolder.find('.js-loadWasPriceValue').text(priceInfo.estimatedWasPrice.formattedValue);
      $priceHolder.find('.js-loadWasPriceValueEach').text(priceInfo.wasPrice.formattedValue.replace(/\s+/g, ''));
      $priceHolder.find('.js-loadWasPriceValueEach').parent().removeClass('hidden');
      $priceHolderParents.addClass(HAS_WAS_PRICE);
      $priceHolder.find('.js-loadWasPrice').removeClass('hidden');
    } else if (priceInfo.wasPrice != null) {
      ACC.productprice.wasPriceDisplay($priceHolder, priceInfo);
      if (ACC.config.viewPromotion) {
        var $promoIconParent = $priceHolder.parents('.js-productItemBorder');
        var $promoIcon = $priceHolder.parents('.js-productItemBorder').find('.product-item__icons').find('.js-productPromoIcon');
        $promoIcon.addClass('js-wasPrice');
        $promoIcon.removeClass('hidden');
        $promoIconParent.addClass('product-item--promotion-border overflow-hide');
      }
    } else if (priceInfo.wasPrice === null) {
      if ($priceHolderParents.hasClass(HAS_WAS_PRICE)) {
        $priceHolderParents.removeClass(HAS_WAS_PRICE);
      }
    }
  },

  getCartEnableButton: function (priceHolder) {
    if (ACC.config.pdp) {
      return priceHolder.parents('.product-details__price-panel').find('.js-enable-btn');
    } else {
      return priceHolder.parents('.js-productItem').find('.js-enable-btn');
    }
  },

  wasPriceDisplay: function ($priceHolder, priceInfo) {
    if (priceInfo.wasPrice) {
      if (priceInfo.estimatedWasPrice) {
        $priceHolder.find('.js-loadEstimatedWasPriceValue').html(priceInfo.estimatedWasPrice.formattedValue);
      }
      $priceHolder.find('.js-loadWasPriceValue').html(priceInfo.wasPrice.formattedValue);
      $priceHolder.parents('.js-productItemPrice').addClass('has-was-price');
      $priceHolder.find('.js-loadWasPrice').removeClass('hidden');
    } else {
      $priceHolder.parents('.js-productItemPrice').removeClass('has-was-price');
    }
  },

  initTradeCalculator: function () {
    $(document).on('submit', '.js-tradeCalculatorForm', function (e) {
      e.preventDefault();
      ACC.productprice.handleTradeCalculatorSubmit($(this));
    });
  },

  handleTradeCalculatorSubmit: function () {
    var $discount = $('.js-tradeCalculatorDiscount').val();

    var discountVal = parseInt($discount ? $discount : '0');
    ACC.productprice.discountVal = discountVal;

    ACC.productprice.setTradeDiscountSession();
    ACC.productprice.recalculateProductPrices();

    $('#tradeCalculatorModal').modal('hide');
  },

  cleanUpPrice: function (value) {
    if (typeof value == 'string') {
      var firstArrayValue = value.split('/')[0];
      return firstArrayValue.replace('£', '');
    } else if (typeof value == 'undefined') {
      return 0;
    }
    return value;
  },

  // Recalculate product prices - except products with discounts
  recalculateProductPrices: function () {
    $('.js-productPrice').each(function () {
      ACC.productprice.processProductPrice($(this));
    });
  },

  processProductPrice: function ($this) {
    var $parents = $this.parents('.js-productItemPrice');
    var hasWasPrice = $parents.hasClass('has-was-price');
    var currencySymbol = $this.data('currency-symbol') || '£';
    var priceDescriptor = $this.data('price-descriptor') || '';
    var dataPrice = $this.data('price');
    var initialPrice = ACC.productprice.cleanUpPrice(dataPrice);
    var newPrice;
    var formatPrice;
    var hasNetPrice;
    var recalculated = false;
    if ($('.js-netPrice').length > 0) {
      hasNetPrice = $('.js-netPrice').val() === 'true';
    } else {
      hasNetPrice = $parents.siblings('.product-item__info').find("img[alt='icon-E24']").length > 0;
    }
    if (typeof dataPrice != 'undefined') {
      if (!hasNetPrice) {
        if (ACC.productprice.discountVal === 100 && !hasWasPrice) {
          newPrice = 0;
          formatPrice = currencySymbol + newPrice.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') + priceDescriptor;

          recalculated = true;
        } else {
          if (ACC.productprice.discountVal == '' || ACC.productprice.discountVal == 0 || hasWasPrice) {
            newPrice = initialPrice * 1; // Convert to number
          } else {
            newPrice = initialPrice - initialPrice * (ACC.productprice.discountVal / 100);
            recalculated = true;
          }
          formatPrice = newPrice.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');
        }
        $this.html(newPrice == 0 ? formatPrice : currencySymbol + formatPrice + priceDescriptor);
      }
    }
    if (recalculated) {
      $this.addClass(ACC.productprice.RECALCULATED_PRICE);
      $parents.addClass(ACC.productprice.RECALCULATED_CLASS);
    } else {
      $this.removeClass(ACC.productprice.RECALCULATED_PRICE);
      $parents.removeClass(ACC.productprice.RECALCULATED_CLASS);
    }
  }
};

export default productprice;
