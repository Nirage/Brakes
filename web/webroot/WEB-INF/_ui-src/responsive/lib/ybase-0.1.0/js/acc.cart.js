const cart = {
  _autoload: [
    'init',
    ['bindCartQtyButtons', $('.js-cartQtyChangeBtn').length != 0],
    ['bindCartQtyInput', $('.js-productCartQtyInput').length != 0],
    ['bindAddToQuantity', ACC.config.cartPage || ACC.config.amendOrderPage],
    ['confirmZeroQuantityCart', ACC.config.cartPage || ACC.config.amendOrderPage],
    ['bindReplaceQuantity', ACC.config.cartPage || ACC.config.amendOrderPage],
    ['bindConfirmLargeQuantity', ACC.config.cartPage || ACC.config.amendOrderPage],
    ['bindRegisterHelpers', ACC.config.cartPage],
    ['bindContinueCheckout', $('.js-continue-checkout-button').length != 0 && ACC.config.cartPage],
    ['bindContinueCart', $('.js-continue-cart-button').length != 0 && ACC.config.cartPage],
    ['bindCartNewBasket', $('.js-cartSave').length != 0],
    ['bindNavCheckoutButton', $('.js-btnCheckoutHeader').length != 0],
    ['bindViewPotentialPromoProducts', $('.js-viewPotentialPromoProducts').length != 0],
    ['bindApplyVoucher', $('#js-voucher-apply-btn').length != 0],
    ['bindToReleaseVoucher', $('#js-applied-vouchers').length != 0],
    ['bindSavedCarts', $('.js-savedCarts').length],
    ['bindPurchaseOrderForm', $('#purchaseOrderForm').length != 0],
    ['bindPlaceOrderForm', $('.js-placeOrderForm').length != 0],
    ['bindPurchaseOrderNumber', $('.js-purchase-order-number').length != 0],
    'bindHelp',
    'cartRestoration',
    'bindCartPage',
    'confirmClearCart',
    'confirmDeleteCartAndRestore',
    'bindMultiDEntryRemoval',
    'bindMultidCartProduct',
    'bindProductUnavailableModal',
    ['bindViewPotentialPromoProducts', $('.js-viewPotentialPromoProducts').length != 0],
    ['bindApplyVoucher', $('#js-voucher-apply-btn').length != 0],
    ['bindToReleaseVoucher', $('#js-applied-vouchers').length != 0],
    ['bindSavedCarts', $('.js-savedCarts').length],
    ['bindCartPrint', $('.js-cartPrint').length != 0]
  ],

  submitTriggered: false,
  $modals: $('.js-cartModal'),
  $cartQtyPopupLarge: $('.js-cartQtyPopupLarge'),
  $currentlyEditedItem: $('#editing-row-item'),
  CART_INPUT: '.js-quickAddProductCode',
  CART_QTY_INPUT: '.js-productCartQtyInput',
  CART_QTY: '.js-productCartQty',
  PO_FORMAT_REGEX: '',
  cartMaxQty: parseInt($('#cartMaximumQuantity').val()),
  cartLargeQty: parseInt($('#cartLargeQuantity').val()),
  initialCartQuantity: 0,
  changeValueViaModal: false,
  bindProductUnavailableModal: function () {
    if (window.outOfStockError || window.productRemoved) {
      ACC.cart.productUnavailablePopup();
    }
  },
  init: function () {
    ACC.cart.PO_FORMAT_REGEX = new RegExp(ACC.validation.regex.all);
    document.body.classList.contains('page-checkoutPage') && ACC.cart.scrollCartPos();
  },

  scrollCartPos: function () {
    var cartList = document.querySelector('.js-cartItemsList');
    if (!cartList) return;

    var parseCartPosition = parseInt(sessionStorage.getItem('cartWindowScrollTo'));
    if (!parseCartPosition) return;
    window.scrollTo(0, parseCartPosition);
    sessionStorage.removeItem('cartWindowScrollTo');

    var checkoutCartList = !cartList.classList.contains('cart__items-list--checkout');
    if (checkoutCartList) return;
    cartList.scrollTo(0, parseInt(sessionStorage.getItem('checkoutCartScrollTo')));
    sessionStorage.removeItem('checkoutCartScrollTo');
  },

  bindCartQtyButtons: function () {
    $(document).on('click', '.js-cartQtyChangeBtn', function () {
      ACC.global.checkLoginStatus(ACC.cart.handleButtonClick, $(this));
    });
  },

  handleButtonClick: function ($btn) {
    var btnAction = $btn.data('action');
    var $productForm = $btn.parents('.js-addQuantityForm');
    var $productCode = $productForm.find("[name='productCodePost']").val();
    ACC.cart.$currentlyEditedItem.val($productForm.attr('id'));
    var currentVal = parseInt($productForm.find(ACC.cart.CART_QTY).val());
    ACC.cart.initialCartQuantity = currentVal;
    var newVal = ACC.product.changeProductQty(currentVal, btnAction);
    $productForm.find(ACC.cart.CART_QTY_INPUT).val(newVal);

    if (newVal < ACC.cart.cartLargeQty && btnAction == 'remove') {
      ACC.cart.clearLargeQtyShown($productCode);
    }
    ACC.cart.validateQuantity($productForm, newVal, btnAction);
  },

  bindPurchaseOrderForm: function () {
    $('#purchaseOrderForm').on('submit', function (e) {
      e.preventDefault();
    });
  },

  bindPlaceOrderForm: function () {
    $('.js-placeOrderForm').on('submit', function (e) {
      e.preventDefault();
      e.target.querySelector('button').disabled = true;
      ACC.global.checkLoginStatus(ACC.cart.onPlaceOrderFormSubmit);
    });
  },
  bindPurchaseOrderNumber: function () {
    ACC.cart.applyPOFormatting();

    var $poInput = $('.js-purchase-order-number');

    $poInput
      .on('keyup', ACC.cart.onPlaceOrderForm)
      .on('keypress', function (e) {
        var target = e.target;
        //Restrict < and > chars
        if (e.keyCode == 62 || e.keyCode == 60) {
          e.preventDefault();
        }
        setTimeout(function () {
          $poInput.val(target.value.toUpperCase());
        }, 0);
      })
      .on('paste', function () {
        var $this = $(this);
        setTimeout(function () {
          var val = $this.val();
          var set = val.replace(/</g, '');
          set = set.replace(/>/g, '');
          $poInput.val(set.toUpperCase());
        }, 0);
      });
  },
  applyPOFormatting: function () {
    var $poFormat = $('.js-PO-format').val();
    if ($poFormat) {
      ACC.cart.PO_FORMAT_REGEX = new RegExp($poFormat);
    }
  },

  postPoNumber: function (purchasenumber, callback, callbackParam) {
    $.ajax({
      url: '/checkout/setPurchaseOrderNo',
      type: 'POST',
      data: {
        purchaseOrderNumber: purchasenumber
      },
      dataType: 'html',
      success: function () {
        if (typeof callback == 'function') {
          callback(callbackParam);
        }
      },
      error: function () {
        ACC.cart.showPOError(ACC.config.poInvalid);
      }
    });
  },
  /**
   *
   * @param {object} $formId - jQuery object
   */
  placeOrder: function ($form) {
    ACC.global.doSubmitForm($form);
  },

  onPlaceOrderFormSubmit: function () {
    if (ACC.config.isb2cSite) {
      ACC.cart.postPoNumber('', ACC.cart.placeOrder, $('#placeOrderForm'));
    } else {
      var $purchaseOrderInput = $('.js-purchase-order-number');
      var purchasenumber = $purchaseOrderInput.val();
      var isValid = ACC.cart.testPOForm(purchasenumber, $purchaseOrderInput);
      var cardStatus = document.getElementById('cardStatus');

      if (isValid && cardStatus.value === 'false') {
        ACC.cart.postPoNumber(purchasenumber, ACC.cart.placeOrder, $('#placeOrderForm'));
      } else {
        $purchaseOrderInput.focus();
      }
    }
  },

  testPOForm: function (purchasenumber, $purchaseOrderInput) {
    var poRequired = $('#poRequired').length > 0;
    var isValid = true;
    var $validRegex = ACC.cart.PO_FORMAT_REGEX.test(purchasenumber);
    if ($purchaseOrderInput.val().length > 35) {
      ACC.cart.showPOError(ACC.config.purchaseOrder.invalid);
      isValid = false;
    } else if (poRequired) {
      if (!purchasenumber || purchasenumber == '') {
        ACC.cart.showPOError(ACC.config.purchaseOrder.provide);
        isValid = false;
      } else if (!$validRegex) {
        ACC.cart.showPOError(ACC.config.purchaseOrder.incorrect);
        isValid = false;
      }
    }
    return isValid;
  },

  showPOError: function (errorMessage) {
    var $poFormatError = $('.js-poFormatError');
    $poFormatError.text(errorMessage);
    $poFormatError.removeClass('hide');
  },

  onPlaceOrderForm: function () {
    var $poFormatError = $('.js-poFormatError');
    var $poFormatVal = $(this).val();
    var purchasenumber = $poFormatVal != '' ? $(this).val() : null;
    var poRequired = $('#poRequired').val();
    if (poRequired == 'true' && $poFormatVal.trim() == '') {
      $poFormatError.removeClass('hide');
      $poFormatError.text(ACC.config.purchaseOrder.provide);
      return;
    }
    var $validRegex = ACC.cart.PO_FORMAT_REGEX.test(purchasenumber);
    if ($validRegex) {
      $poFormatError.addClass('hide');
      ACC.cart.postPoNumber(purchasenumber);
    } else {
      $poFormatError.removeClass('hide');
      $poFormatError.text('Please provide a correct format purchase order reference for your order');
    }
    const invalidCard = document.getElementById('cardStatus').value === 'true';
    document.querySelector('.js-PlaceOrder').disabled = !$validRegex || invalidCard;
  },

  bindCartPrint: function () {
    $(document).on('click keypress', '.js-cartPrint', function (e) {
      if (ACC.global.keyPressCheck(e)) {
        $('body').addClass('is-printing-basket');
        window.print();
      }
    });
  },

  bindContinueCheckout: function () {
    $(document).on('click keypress', '.js-continue-checkout-button', ACC.global.linkClickIntercept);
  },

  bindContinueCart: function () {
    $(document).on('click keypress', '.js-continue-cart-button', ACC.global.linkClickIntercept);
  },

  bindCartNewBasket: function () {
    $(document).on('click keypress', '.js-cartSave', ACC.global.linkClickIntercept);
  },

  bindNavCheckoutButton: function () {
    $(document).on('click keypress', '.js-btnCheckoutHeader', ACC.global.linkClickIntercept);
  },

  bindCartQtyInput: function () {
    $(document).on('keypress', ACC.cart.CART_QTY_INPUT, function (e) {
      // Only numbers allowed
      if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
        return false;
      }
    });

    $(document).on('change', ACC.cart.CART_QTY_INPUT, ACC.cart.handleQtyChange);
  },

  handleQtyChange: function (e) {
    var $input = $(e.target);
    var $productForm = $input.parents('.js-addQuantityForm');
    ACC.cart.$currentlyEditedItem.val($productForm.attr('id'));
    var currentVal = parseInt($productForm.find(ACC.cart.CART_QTY).val());
    ACC.cart.initialCartQuantity = currentVal;
    var newVal = $input.val();
    if (newVal === '') return $input.val(currentVal);

    ACC.cart.validateQuantity($productForm, parseInt(newVal));
  },

  showQuantityZeroPopup: function ($productForm) {
    var isPromoItem = $productForm.parents('.js-cartItemPromoGroup').length > 0;
    if (isPromoItem) {
      ACC.cart.promoQuantityZeroPopup($productForm);
    } else {
      ACC.cart.quantityZeroPopup($productForm);
    }
  },

  bindAddToQuantity: function () {
    $(document).on('click', '#addToQuantityCart', ACC.cart.handleAddToClick);
  },

  handleAddToClick: function (e) {
    var $productForm = ACC.cart.getProductForm();
    var $modalParent = $(e.target).parents('.js-cartModal');
    var currentVal = parseInt($productForm.find(ACC.cart.CART_QTY).val());
    ACC.cart.initialCartQuantity = currentVal;
    var newVal = currentVal + parseInt($productForm.find(ACC.cart.CART_QTY_INPUT).val());
    $productForm.find(ACC.cart.CART_QTY_INPUT).val(newVal);
    var shownLargeQty = ACC.cart.checkLargeQtyShown($productForm.data('id'));
    if (newVal > ACC.cart.cartMaxQty) {
      // show a max quantity modal
      $modalParent.one('hidden.bs.modal', function () {
        ACC.cart.maxQuantityPopup($productForm);
      });
    } else if (
      !shownLargeQty &&
      newVal >= ACC.cart.cartLargeQty &&
      $modalParent.attr('id') !== 'orderQuantityLargePopup' &&
      $modalParent.attr('id') !== 'quantityLargePopupCart'
    ) {
      // show a replace large quantity modal
      $modalParent.off('hidden.bs.modal', ACC.cart.handleQuantityAddHide);
      $modalParent.one('hidden.bs.modal', function () {
        ACC.cart.largeQuantityReplace(newVal, $productForm);
      });
    } else {
      $productForm.find(ACC.cart.CART_QTY_INPUT).val(newVal);
      ACC.cart.changeValueViaModal = true;
      $modalParent.one('hidden.bs.modal', function () {
        ACC.cart.validateQuantity($productForm, newVal);
      });
    }

    $modalParent.modal('hide');
  },

  bindReplaceQuantity: function () {
    $(document).on('click', '#replaceQuantityCart', ACC.cart.handleReplaceClick);
  },

  handleReplaceClick: function (e) {
    var $productForm = ACC.cart.getProductForm();
    var $modalParent = $(e.target).parents('.js-cartModal');
    var newVal = parseInt($productForm.find(ACC.cart.CART_QTY_INPUT).val());
    $productForm.find(ACC.cart.CART_QTY_INPUT).val(newVal);

    ACC.cart.changeValueViaModal = true;

    var shownLargeQty = ACC.cart.checkLargeQtyShown($productForm.data('id'));
    if (shownLargeQty && newVal < ACC.cart.cartLargeQty) {
      ACC.cart.clearLargeQtyShown($productForm.data('id'));
    }

    $modalParent.one('hidden.bs.modal', function () {
      $productForm.find(ACC.cart.CART_QTY_INPUT).val(newVal);
      ACC.cart.validateQuantity($productForm, newVal);
    });
    $modalParent.modal('hide');
  },

  confirmZeroQuantityCart: function () {
    $(document).on('click keypress', '#confirmZeroQuantityCart', function (e) {
      if (ACC.global.keyPressCheck(e)) {
        var $productForm = ACC.cart.getProductForm();
        ACC.cart.$modals.modal('hide');
        ACC.cart.submitWithQuantity($productForm, 0);
      }
    });
  },

  confirmClearCart: function () {
    $('.js-clearCartItemsForm').on('submit', function (e) {
      e.preventDefault();
      ACC.global.checkLoginStatus(ACC.global.doSubmitForm, $(this));
    });
  },

  confirmDeleteCartAndRestore: function () {
    $('.js-deleteCurrentCartAndRestoreForm').on('submit', function (e) {
      e.preventDefault();
      ACC.global.checkLoginStatus(ACC.global.doSubmitForm, $(this));
    });
  },

  bindConfirmLargeQuantity: function () {
    $(document).on('click', '#confirmLargeQuantityCart', function () {
      var $this = $(this);
      var $modal = $this.parents('.modal-dialog');
      var $productForm = ACC.cart.getProductForm();
      var $qtySelector = $modal.find('.js-cartQtyPopupLarge');
      var newVal;
      if ($qtySelector) {
        newVal = parseInt($qtySelector.text());
      }
      ACC.cart.$modals.modal('hide');
      ACC.cart.submitWithQuantity($productForm, newVal);
    });
  },

  submitWithQuantity: function ($productForm, newVal) {
    if (typeof $productForm == undefined) {
      $productForm = ACC.cart.getProductForm();
    }

    ACC.product.initialQuantity = $productForm.find(ACC.cart.CART_QTY).val();
    $productForm.find(ACC.cart.CART_QTY).val(newVal);
    ACC.global.checkLoginStatus(ACC.cart.loggedInUserHandler, $productForm);
  },

  loggedInUserHandler: function ($productForm) {
    if (ACC.config.amendOrderPage) {
      var orderCode = $productForm.find('[name=orderCode]').val();
      var redirectUrl = ACC.config.contextPath + '/my-account/order/' + orderCode;
      var orderData = {
        orderCode: orderCode,
        redirectUrl: redirectUrl,
        $productForm: $productForm
      };
      ACC.order.checkOrderEligibilityForAmendOnQtyChange(orderData);
    } else {
      var cartList = document.querySelector('.js-cartItemsList');

      if (cartList) {
        var scrollTo = window.pageYOffset || document.documentElement.scrollTop;
        sessionStorage.setItem('cartWindowScrollTo', scrollTo);

        if (cartList.classList.contains('cart__items-list--checkout')) {
          sessionStorage.setItem('checkoutCartScrollTo', cartList.scrollTop);
        }
      }

      $productForm.submit();
    }
  },

  validateQuantity: function ($productForm, newVal, btnAction) {
    if (typeof $productForm == undefined) {
      $productForm = ACC.cart.getProductForm();
    }
    var productCode = $productForm.data('id');

    var hasShownProductLarge = ACC.cart.checkLargeQtyShown(productCode);

    if (!ACC.cart.changeValueViaModal) {
      if (newVal > ACC.cart.cartMaxQty) {
        ACC.cart.$modals.modal('hide');
        ACC.cart.maxQuantityPopup($productForm);
      } else if (newVal >= ACC.cart.cartLargeQty && btnAction != 'remove' && !hasShownProductLarge) {
        ACC.cart.$modals.modal('hide');
        ACC.cart.largeQuantityPopup(parseInt(newVal), $productForm);
      } else if (newVal == 0) {
        ACC.cart.showQuantityZeroPopup($productForm);
      } else if (!btnAction) {
        ACC.cart.quantityAddPopup();
      } else {
        $('.js_spinner').show();
        ACC.cart.submitWithQuantity($productForm, newVal);
      }
    } else {
      $('.js_spinner').show();
      ACC.cart.submitWithQuantity($productForm, newVal);
    }
  },

  getProductForm: function () {
    var formId = ACC.cart.$currentlyEditedItem.val();
    return $('#' + formId);
  },

  quantityAddPopup: function () {
    var $quantityCartModal = ACC.config.amendOrderPage ? $('#quantityOrderModal') : $('#quantityCartModal');

    $quantityCartModal.one('show.bs.modal', function () {
      var $addBtn = $(this).find('#addToQuantity');
      var $replaceBtn = $(this).find('#replaceQuantity');

      $addBtn.attr('id', 'addToQuantityCart');
      $replaceBtn.attr('id', 'replaceQuantityCart');
    });
    $quantityCartModal.on('hidden.bs.modal', ACC.cart.handleQuantityAddHide);
    $quantityCartModal.modal('show');
  },

  handleQuantityAddHide: function () {
    var $productForm = ACC.cart.getProductForm();
    if (!ACC.cart.changeValueViaModal) {
      $productForm.find(ACC.cart.CART_QTY_INPUT).val(ACC.cart.initialCartQuantity);
      var $addBtn = $(this).find('#addToQuantityCart');
      var $replaceBtn = $(this).find('#replaceQuantityCart');

      $addBtn.attr('id', 'addToQuantity');
      $replaceBtn.attr('id', 'replaceQuantity');
    }
  },

  quantityZeroPopup: function ($productForm) {
    var $quantityCartModal = ACC.config.amendOrderPage ? $('#orderQuantityZeroModal') : $('#quantityZeroModal');

    var currentVal = parseInt($productForm.find(ACC.cart.CART_QTY).val());
    $quantityCartModal.one('show.bs.modal', function () {
      var confirmZeroQtyBtn = $(this).find('#confirmZeroQuantity');
      confirmZeroQtyBtn.attr('id', 'confirmZeroQuantityCart');
    });
    $quantityCartModal.one('hidden.bs.modal', function () {
      if (!ACC.cart.changeValueViaModal) {
        $productForm.find(ACC.cart.CART_QTY_INPUT).val(currentVal);
        var confirmZeroQtyBtn = $(this).find('#confirmZeroQuantityCart');
        confirmZeroQtyBtn.attr('id', 'confirmZeroQuantity');
      }
    });
    $quantityCartModal.modal('show');
  },

  promoQuantityZeroPopup: function ($productForm) {
    var $quantityCartModal = $('#promoQuantityZeroModal');

    var currentVal = parseInt($productForm.find(ACC.cart.CART_QTY).val());
    $quantityCartModal.one('show.bs.modal', function () {
      var confirmZeroQtyBtn = $(this).find('#confirmZeroQuantity');
      confirmZeroQtyBtn.attr('id', 'confirmZeroQuantityCart');
    });
    $quantityCartModal.one('hidden.bs.modal', function () {
      if (!ACC.cart.changeValueViaModal) {
        $productForm.find(ACC.cart.CART_QTY_INPUT).val(currentVal);
        var confirmZeroQtyBtn = $(this).find('#confirmZeroQuantityCart');
        confirmZeroQtyBtn.attr('id', 'confirmZeroQuantity');
      }
    });
    $quantityCartModal.modal('show');
  },

  largeQuantityPopup: function (inputValue, $productForm) {
    var $quantityCartModal = ACC.config.amendOrderPage ? $('#orderQuantityLargePopup') : $('#quantityLargePopupCart');
    var productCode = $productForm.data('id');
    var currentVal = parseInt($productForm.find(ACC.cart.CART_QTY).val());

    $quantityCartModal.find('.js-cartQtyPopupLarge').text(inputValue);

    $quantityCartModal.one('show.bs.modal', function () {
      ACC.cart.setlargeQtyShown(productCode);
    });
    $quantityCartModal.one('hidden.bs.modal', function () {
      if (!ACC.cart.changeValueViaModal) {
        $productForm.find(ACC.cart.CART_QTY_INPUT).val(currentVal);
        if (currentVal < ACC.cart.cartLargeQty) {
          ACC.cart.clearLargeQtyShown(productCode);
        }
        var confirmLargeQuantity = $(this).find('#confirmLargeQuantityCart');
        confirmLargeQuantity.attr('id', 'confirmLargeQuantity');
      }
    });
    $quantityCartModal.modal('show');
  },

  largeQuantityReplace: function (inputValue, $productForm) {
    var $quantityCartModal = ACC.config.amendOrderPage ? $('#orderQuantityLargePopupReplace') : $('#quantityLargePopupCartReplace');
    var productCode = $productForm.data('id');
    var currentVal = parseInt($productForm.find(ACC.cart.CART_QTY).val());

    $quantityCartModal.find('.js-cartQtyPopupLarge').text(inputValue);

    $quantityCartModal.one('show.bs.modal', function () {
      ACC.cart.setlargeQtyShown(productCode);
    });
    $quantityCartModal.one('hidden.bs.modal', function () {
      if (!ACC.cart.changeValueViaModal) {
        $productForm.find(ACC.cart.CART_QTY_INPUT).val(currentVal);
        var confirmLargeQuantity = $(this).find('#confirmLargeQuantityCart');
        confirmLargeQuantity.attr('id', 'confirmLargeQuantity');

        if (currentVal < ACC.cart.cartLargeQty) {
          ACC.cart.clearLargeQtyShown(productCode);
        }
      }
    });
    $quantityCartModal.modal('show');
  },

  setlargeQtyShown: function (productCode) {
    var gotSessionItem = sessionStorage.getItem('largeQtyShown');
    if (gotSessionItem && gotSessionItem !== '') {
      if (gotSessionItem.indexOf(productCode) == -1) {
        gotSessionItem += ':' + productCode;
        sessionStorage.setItem('largeQtyShown', gotSessionItem);
      }
    } else {
      sessionStorage.setItem('largeQtyShown', productCode);
    }
  },

  clearLargeQtyShown: function (productCode) {
    var gotSessionItem = sessionStorage.getItem('largeQtyShown');
    if (gotSessionItem && gotSessionItem != '') {
      var sessionItemArray = gotSessionItem.split(':');
      var sessionItemIndex = sessionItemArray.indexOf(productCode.toString());
      if (sessionItemIndex > -1) {
        sessionItemArray.splice(sessionItemIndex, 1);
        sessionStorage.setItem('largeQtyShown', sessionItemArray.join(':'));
      }
    } else {
      sessionStorage.removeItem('largeQtyShown');
    }
  },

  checkLargeQtyShown: function (productCode) {
    var gotSessionItem = sessionStorage.getItem('largeQtyShown');
    if (gotSessionItem && gotSessionItem != '') {
      return gotSessionItem.indexOf(productCode) > -1;
    } else {
      return false;
    }
  },

  maxQuantityPopup: function ($productForm) {
    var $quantityCartModal = ACC.config.amendOrderPage ? $('#orderQuantityMaximumPopup') : $('#quantityMaximumPopup');

    var currentVal = parseInt($productForm.find(ACC.cart.CART_QTY).val());
    $quantityCartModal.modal('show');
    $quantityCartModal.one('hidden.bs.modal', function () {
      if (!ACC.cart.changeValueViaModal) {
        $productForm.find(ACC.cart.CART_QTY_INPUT).val(currentVal);
        $productForm.find(ACC.cart.CART_QTY_INPUT).select();
        $productForm.find(ACC.cart.CART_QTY_INPUT).focus();
      }
    });
  },

  productUnavailablePopup: function () {
    var $modal = $('#cartProductUnavailableModal');
    $modal.one('hidden.bs.modal', ACC.cart.focusQuickAddInputField);
    $modal.modal('show');
  },

  focusQuickAddInputField: function () {
    if ($('.js-unavailableActiveError').length > 0) {
      var $amendOrderForm = $('.js-unavailableActiveError').parents('form');
      $amendOrderForm.find(ACC.cart.CART_INPUT).select();
      $amendOrderForm.find(ACC.cart.CART_INPUT).focus();
    } else {
      $(ACC.cart.CART_INPUT).select();
      $(ACC.cart.CART_INPUT).focus();
    }
  },

  bindHelp: function () {
    $(document).on('click', '.js-cart-help', function (e) {
      e.preventDefault();
      var title = $(this).data('help');
      ACC.colorbox.open(ACC.common.encodeHtml(title), {
        html: $('.js-help-popup-content').text(),
        width: '300px'
      });
    });
  },

  cartRestoration: function () {
    $('.cartRestoration').click(function () {
      var sCartUrl = $(this).data('cartUrl');
      window.location = sCartUrl;
    });
  },

  bindCartPage: function () {
    // link to display the multi-d grid in read-only mode
    $(document).on('click', '.js-show-editable-grid', function (event) {
      ACC.cart.populateAndShowEditableGrid(this, event);
    });
  },

  bindMultiDEntryRemoval: function () {
    $(document).on('click', '.js-submit-remove-product-multi-d', function () {
      var itemIndex = $(this).data('index');
      var $form = $(document).find('#updateCartForm' + itemIndex);
      var initialCartQuantity = $form.find('input[name=initialQuantity]');
      var cartQuantity = $form.find('input[name=quantity]');
      var productCode = $form.find('input[name=productCode]').val();

      cartQuantity.val(0);
      initialCartQuantity.val(0);

      ACC.track.trackRemoveFromCart(productCode, initialCartQuantity, cartQuantity.val());

      var method = $form.attr('method') ? $form.attr('method').toUpperCase() : 'GET';
      $.ajax({
        url: $form.attr('action'),
        data: $form.serialize(),
        type: method,
        dataType: 'text',
        success: function () {
          location.reload();
        },
        error: function (xht, textStatus, ex) {
          console.error('Failed to remove quantity. Error details [' + xht + ', ' + textStatus + ', ' + ex + ']');
        }
      });
    });
  },

  populateAndShowEditableGrid: function (element) {
    var readOnly = $(element).data('readOnlyMultidGrid');
    var itemIndex = $(element).data('index');
    var grid = $(document).find('#ajaxGrid' + itemIndex);

    var gridEntries = $(document).find('#grid' + itemIndex);
    var strSubEntries = gridEntries.data('sub-entries');
    var arrSubEntries = strSubEntries.split(',');
    var firstVariantCode = arrSubEntries[0].split(':')[0];

    $(element).toggleClass('open');

    var targetUrl = gridEntries.data('target-url');

    var mapCodeQuantity = {};
    for (var i = 0; i < arrSubEntries.length; i++) {
      var arrValue = arrSubEntries[i].split(':');
      mapCodeQuantity[arrValue[0]] = arrValue[1];
    }

    if (grid.children('#cartOrderGridForm').length > 0) {
      grid.slideToggle('slow');
    } else {
      var method = 'GET';
      $.ajax({
        url: targetUrl,
        data: {
          productCode: firstVariantCode,
          readOnly: readOnly
        },
        type: method,
        dataType: 'html',
        success: function (data) {
          grid.html(data);
          $('#ajaxGrid').removeAttr('id');
          var $gridContainer = grid.find('.product-grid-container');
          var numGrids = $gridContainer.length;
          for (var i = 0; i < numGrids; i++) {
            ACC.cart.getProductQuantity($gridContainer.eq(i), mapCodeQuantity, i);
          }
          grid.slideDown('slow');
          ACC.cart.coreCartGridTableActions(element, mapCodeQuantity);
          ACC.productorderform.coreTableScrollActions(grid.children('#cartOrderGridForm'));
        },
        error: function (xht, textStatus, ex) {
          console.error('Failed to get variant matrix. Error details [' + xht + ', ' + textStatus + ', ' + ex + ']');
        }
      });
    }
  },

  coreCartGridTableActions: function (element, mapCodeQuantity) {
    ACC.productorderform.bindUpdateFutureStockButton('.update_future_stock_button');
    ACC.productorderform.bindVariantSelect($('.variant-select-btn'), 'cartOrderGridForm');
    var itemIndex = $(element).data('index');
    var skuQuantityClass = '.sku-quantity';

    var quantityBefore = 0;
    var grid = $(document).find('#ajaxGrid' + itemIndex + ' .product-grid-container');

    grid.on('focusin', skuQuantityClass, function () {
      quantityBefore = jQuery.trim(this.value);

      $(this).parents('tr').next('.variant-summary').remove();
      if ($(this).parents('table').data(ACC.productorderform.selectedVariantData)) {
        ACC.productorderform.selectedVariants = $(this).parents('table').data(ACC.productorderform.selectedVariantData);
      } else {
        ACC.productorderform.selectedVariants = [];
      }

      if (quantityBefore == '') {
        quantityBefore = 0;
        this.value = 0;
      }
    });

    grid.on('focusout keypress', skuQuantityClass, function (event) {
      var code = event.keyCode || event.which || event.charCode;

      if (code != 13 && code != undefined) {
        return;
      }

      var quantityAfter = 0;
      var gridLevelTotalPrice = '';

      var indexPattern = '[0-9]+';
      var currentIndex = parseInt($(this).attr('id').match(indexPattern));

      this.value = ACC.productorderform.filterSkuEntry(this.value);

      quantityAfter = jQuery.trim(this.value);
      var variantCode = $(document)
        .find("input[id='cartEntries[" + currentIndex + "].sku']")
        .val();

      if (isNaN(jQuery.trim(this.value))) {
        this.value = 0;
      }

      if (quantityAfter == '') {
        quantityAfter = 0;
        this.value = 0;
      }

      var $gridTotalValue = grid.find('[data-grid-total-id=' + 'total_value_' + currentIndex + ']');
      var currentPrice = $(document)
        .find("input[id='productPrice[" + currentIndex + "]']")
        .val();

      if (quantityAfter > 0) {
        gridLevelTotalPrice = ACC.productorderform.formatTotalsCurrency(parseFloat(currentPrice) * parseInt(quantityAfter));
      }

      $gridTotalValue.text(gridLevelTotalPrice);

      var _this = this;
      var priceSibling = $(this).siblings('.price');
      var propSibling = $(this).siblings('.variant-prop');
      var currentSkuId = $(this).next('.td_stock').data('sku-id');
      var currentBaseTotal = $(this).siblings('.data-grid-total');

      if (this.value != quantityBefore) {
        var newVariant = true;
        ACC.productorderform.selectedVariants.forEach(function (item, index) {
          if (item.id === currentSkuId) {
            newVariant = false;

            if (_this.value === '0' || _this.value === 0) {
              ACC.productorderform.selectedVariants.splice(index, 1);
            } else {
              ACC.productorderform.selectedVariants[index].quantity = _this.value;
              ACC.productorderform.selectedVariants[index].total = ACC.productorderform.updateVariantTotal(
                priceSibling,
                _this.value,
                currentBaseTotal
              );
            }
          }
        });

        if (newVariant && this.value > 0) {
          // update variantData
          ACC.productorderform.selectedVariants.push({
            id: currentSkuId,
            size: propSibling.data('variant-prop'),
            quantity: _this.value,
            total: ACC.productorderform.updateVariantTotal(priceSibling, _this.value, currentBaseTotal)
          });
        }
      }
      ACC.productorderform.showSelectedVariant($(this).parents('table'));
      if (this.value > 0 && this.value != quantityBefore) {
        $(this).parents('table').addClass('selected');
      } else {
        if (ACC.productorderform.selectedVariants.length === 0) {
          $(this).parents('table').removeClass('selected').find('.variant-summary').remove();
        }
      }

      if (quantityBefore != quantityAfter) {
        var method = 'POST';
        $.ajax({
          url: ACC.config.encodedContextPath + '/cart/updateMultiD',
          data: {
            productCode: variantCode,
            quantity: quantityAfter,
            entryNumber: -1
          },
          type: method,
          success: function (data) {
            ACC.cart.refreshCartData(data, -1, quantityAfter, itemIndex);
            mapCodeQuantity[variantCode] = quantityAfter;
          },
          error: function (xhr) {
            var redirectUrl = xhr.getResponseHeader('redirectUrl');
            var connection = xhr.getResponseHeader('Connection');
            // check if error leads to a redirect
            if (redirectUrl !== null) {
              window.location = redirectUrl;
              // check if error is caused by a closed connection
            } else if (connection === 'close') {
              window.location.reload();
            }
          }
        });
      }
    });
  },

  refreshCartData: function (cartData, entryNum, quantity, itemIndex) {
    // if cart is empty, we need to reload the whole page
    if (cartData.entries.length == 0) {
      location.reload();
    } else {
      var form;

      if (entryNum == -1) {
        // grouped item
        form = $(document).find('.js-qty-form' + itemIndex);
        var productCode = form.find('input[name=productCode]').val();

        //var quantity = 0;
        var entryPrice = 0;
        for (var i = 0; i < cartData.entries.length; i++) {
          var entry = cartData.entries[i];
          if (entry.product.code == productCode) {
            quantity = entry.quantity;
            entryPrice = entry.totalPrice;
            ACC.cart.updateEntryNumbersForCartMenuData(entry);
            break;
          }
        }

        if (quantity == 0) {
          location.reload();
        } else {
          form.find('.qtyValue').text(quantity);
          form.parent().parent().find('.js-item-total').text(entryPrice.formattedValue);
        }
      }

      ACC.cart.refreshCartPageWithJSONResponse(cartData);
    }
  },

  refreshCartPageWithJSONResponse: function (cartData) {
    // refresh mini cart
    ACC.minicart.updateHeaderMiniCart(false);
    $('.js-cart-top-totals').text($('#cartTopTotalSectionTemplate').tmpl(cartData));
    $('div .cartpotproline').remove();
    $('div .cartproline').remove();
    $('.js-cart-totals').remove();
    $('#ajaxCartPotentialPromotionSection').text($('#cartPotentialPromotionSectionTemplate').tmpl(cartData));
    $('#ajaxCartPromotionSection').text($('#cartPromotionSectionTemplate').tmpl(cartData));
    $('#ajaxCart').text($('#cartTotalsTemplate').tmpl(cartData));
    ACC.quote.bindQuoteDiscount();
  },

  updateEntryNumbersForCartMenuData: function (entry) {
    var entryNumbers = '';
    $.each(entry.entries, function (index, subEntry) {
      if (index != 0) {
        entryNumbers = entryNumbers + ';';
      }
      entryNumbers = entryNumbers + subEntry.entryNumber;
    });
    $('.js-execute-entry-action-button').data('actionEntryNumbers', entryNumbers);
  },

  getProductQuantity: function (gridContainer, mapData) {
    var tables = gridContainer.find('table');

    $.each(tables, function (currentTable) {
      var skus = jQuery.map($(currentTable).find("input[type='hidden'].sku"), function (o) {
        return o.value;
      });
      var quantities = jQuery.map($(currentTable).find("input[type='textbox'].sku-quantity"), function (o) {
        return o;
      });
      var selectedVariants = [];

      $.each(skus, function (index, skuId) {
        var quantity = mapData[skuId];
        if (quantity != undefined) {
          quantities[index].value = quantity;

          var indexPattern = '[0-9]+';
          var currentIndex = parseInt(quantities[index].id.match(indexPattern));
          var gridTotalValue = gridContainer.find('[data-grid-total-id=' + 'total_value_' + currentIndex + ']');
          var gridLevelTotalPrice = '';
          var currentPrice = $(document)
            .find("input[id='productPrice[" + currentIndex + "]']")
            .val();
          if (quantity > 0) {
            gridLevelTotalPrice = ACC.productorderform.formatTotalsCurrency(parseFloat(currentPrice) * parseInt(quantity));
          }
          gridTotalValue.text(gridLevelTotalPrice);

          selectedVariants.push({
            id: skuId,
            size: $(quantities[index]).siblings('.variant-prop').data('variant-prop'),
            quantity: quantity,
            total: gridLevelTotalPrice
          });
        }
      });

      if (selectedVariants.length != 0) {
        $.tmpl(ACC.productorderform.$variantSummaryTemplate, {
          variants: selectedVariants
        }).appendTo($(currentTable).addClass('selected'));
        $(currentTable).find('.variant-summary .variant-property').text($(currentTable).find('.variant-detail').data('variant-property'));
        $(currentTable).data(ACC.productorderform.selectedVariantData, selectedVariants);
      }
    });
  },

  bindMultidCartProduct: function () {
    // link to display the multi-d grid in read-only mode
    $(document).on('click', '.showQuantityProduct', function (event) {
      ACC.multidgrid.populateAndShowGrid(this, event, true);
    });

    // link to display the multi-d grid in read-only mode
    $(document).on('click', '.showQuantityProductOverlay', function (event) {
      ACC.multidgrid.populateAndShowGridOverlay(this, event);
    });
  },

  bindApplyVoucher: function () {
    $('#js-voucher-apply-btn').on('click', function (e) {
      ACC.cart.handleApplyVoucher(e);
    });

    $('#js-voucher-code-text').on('keypress', function (e) {
      if (ACC.global.keyPressCheck(e)) {
        ACC.cart.handleApplyVoucher(e);
      }
    });
  },

  handleApplyVoucher: function () {
    var voucherCode = $.trim($('#js-voucher-code-text').val());
    if (voucherCode != '' && voucherCode.length > 0) {
      $('#applyVoucherForm').submit();
    }
  },

  bindToReleaseVoucher: function () {
    $('.js-release-voucher-remove-btn').on('click', function () {
      $(this).closest('form').submit();
    });
  },

  bindSavedCarts: function () {
    $(document).on('change', '.js-savedCarts', function () {
      var $selectedOption = $(this).find('option:selected');
      var url = $selectedOption.data('url');
      location.href = location.protocol + '//' + location.host + url;
    });
  },

  bindViewPotentialPromoProducts: function () {
    $(document).on('click', '.js-viewPotentialPromoProducts', function (e) {
      var $btn = $(e.target);
      $btn.prop('disabled', true);
      ACC.global.checkLoginStatus(ACC.cart.getPotentialPromoProducts, $btn);
    });
  },

  getPotentialPromoProducts: function ($btn) {
    var endpoint = $btn.data('url');
    $.ajax({
      url: endpoint,
      type: 'GET',
      dataType: 'json',
      success: function (response) {
        ACC.cart.renderPotentialPromoModal(response);
        $btn.prop('disabled', false);
      },
      error: function (xht, textStatus, ex) {
        console.error('Failed to get potential promotion details. Error details [' + xht + ', ' + textStatus + ', ' + ex + ']');
      }
    });
  },

  renderPotentialPromoModal: function (response) {
    var modalTemplate = ACC.global.compileHandlebarTemplate('#potentialPromoModalTemplate');

    var modalHTML = modalTemplate(response);

    $('.js-potentialPromoModalHolder').html(modalHTML);
    $('#potentialPromoModal').modal('show');
  },

  bindRegisterHelpers: function () {
    var handlebarsPartials = ['imagePartial'];
    ACC.global.registerHandlebarsPartials(handlebarsPartials);
  }
};

export default cart;
