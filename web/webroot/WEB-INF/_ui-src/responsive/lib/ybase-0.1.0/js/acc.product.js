const product = {
  _autoload: [
    'init',
    'bindToAddToCartForm',
    'enableStorePickupButton',
    'enableVariantSelectors',
    ['bindAddToQuantity', $('#addToQuantity').length > 0 && !ACC.config.cartPage],
    ['bindReplaceQuantity', $('#replaceQuantity').length > 0 && !ACC.config.cartPage],
    ['bindConfirmLargeQuantity', $('#confirmLargeQuantity').length > 0 && !ACC.config.cartPage],
    ['confirmZeroQuantity', $('#confirmZeroQuantity').length > 0 && !ACC.config.cartPage],
    ['productDetailsDescription', $('.js-productDetailsDescText').length > 0]
  ],

  cartMaxQty: parseInt($('#cartMaximumQuantity').val()),
  cartLargeQty: parseInt($('#cartLargeQuantity').val()),
  initialQuantity: 0,
  $modals: $('.js-cartModal'),
  $cartQtyPopupLarge: $('.js-cartQtyPopupLarge'),
  changeValueViaModal: false,
  isZeroModal: false,
  currentProductForm: {},
  minicartForm: '',
  ADDTOCART_QTY_INPUT: '.js-productQtyInput',
  PRODUCT_CART_QTY: '.js-productCartQty',
  INCREMENT_VAL: 1,
  HIDE_CLASS: 'hide',
  init: function () {
    window.$ajaxCallEvent = true;
    this.enableAddToCartButton();
    // should be set to TRUE, however until BE is fixe dwe use FALSE
    ACC.product.bindQtyButtons();
    if (ACC.config.authenticated) {
      ACC.product.bindQtyManualChange();
    }
  },

  enableAddToCartButton: function () {
    $('.js-enable-btn').each(function () {
      if ($(this).attr('data-action') === 'update') {
        $(this).prop('disabled', true);
      } else if (!($(this).hasClass('outOfStock') || $(this).hasClass('out-of-stock')) && !$(this).hasClass('priceUnavailable')) {
        $(this).prop('disabled', false);
      }
    });
  },

  enableVariantSelectors: function () {
    $('.variant-select').prop('disabled', false);
  },

  bindToAddToCartForm: function () {
    $(document).on('submit', '.js-addToCartForm:not(.js-addQuantityForm)', function (e) {
      e.preventDefault(); // avoid to execute the actual submit of the form.
      ACC.global.checkLoginStatus(ACC.product.submitAddToCartForm, $(this));
    });
  },

  submitAddToCartForm: function ($form) {
    var endpoint = $form.attr('action');
    var method = $form.attr('method');
    $.ajax({
      type: method,
      url: endpoint,
      data: $form.serialize(), // serializes the form's elements.
      success: function (data) {
        ACC.product.handleFormSubmitSucces($form, data);
      },
      error: function (err) {
        if (err.status === 403) {
          ACC.product.genericErrorHandlerPopup();
        }
      }
    });
    setTimeout(function () {
      window.$ajaxCallEvent = true;
    }, 2000);
  },

  handleFormSubmitSucces: function ($form, data) {
    if (data.entryNumber === null) {
      ACC.product.displayAlert();
    }
    if (data.promoGroupNumber > -1 && $('.js-cartViewPromotion').val()) {
      ACC.product.currentProductForm.addClass('js-cartItemPromoGroup');
    }

    ACC.product.changeValueViaModal = false;
    ACC.product.isZeroModal = false;

    ACC.product.updateQtyOverlayValue(data.quantity, $form);
    ACC.product.toggleQtyOverlay(data.quantity, $form);

    if (ACC.product.initialQuantity == 0) {
      ACC.product.updateQty(ACC.product.initialQuantity, data.quantity, $form);
      ACC.product.toggleProductQtyUpdate('show', $form);
    }

    ACC.product.onUpdateToCart(data, $form);

    $('.js_spinner').hide();
  },

  showRequest: function () {
    if (window.$ajaxCallEvent) {
      window.$ajaxCallEvent = false;
      return true;
    }
    return false;
  },

  bindRemoveItemMiniBasket: function () {
    $(document).on('click', '.js-removeItemMiniBasket', function () {
      var $this = $(this);
      ACC.product.currentProductForm = $this.parents('.js-miniBasketQtyPicker').find('.js-addToCartForm');
      var isPromoItem = ACC.product.currentProductForm.hasClass('js-cartItemPromoGroup');
      var newVal = 0;
      var currentVal = parseInt(ACC.product.currentProductForm.find(ACC.product.PRODUCT_CART_QTY).val());
      ACC.product.initialQuantity = currentVal;
      ACC.product.onValueChange(currentVal, newVal, ACC.product.currentProductForm, isPromoItem);
    });
  },

  bindToAddToCartStorePickUpForm: function () {
    var addToCartStorePickUpForm = $('#colorbox #add_to_cart_storepickup_form');
    addToCartStorePickUpForm.ajaxForm({ success: ACC.product.onUpdateToCart });
  },

  enableStorePickupButton: function () {
    $('.js-pickup-in-store-button').prop('disabled', false);
  },

  onUpdateToCart: function (cartResult, formElement) {
    window.$ajaxCallEvent = true;
    $('#addToCartLayer').remove();
    if (typeof ACC.minicart.updateHeaderMiniCart == 'function') {
      ACC.minicart.updateHeaderMiniCart(true);
    }

    var productCode = formElement.find('[name=productCodePost]').val();
    formElement.find('[name=entryNumber]').val(cartResult.entryNumber);

    ACC.product.updateMiniCartAnalyticsData(cartResult, productCode, cartResult.quantity);

    if (cartResult.quantity === null || cartResult.entryNumber === null) {
      ACC.product.updateGTMDataLayer('clear', cartResult, formElement);
    } else if (ACC.product.initialQuantity < cartResult.quantity) {
      ACC.product.updateGTMDataLayer('add', cartResult, formElement);
    } else if (ACC.product.initialQuantity > cartResult.quantity) {
      ACC.product.updateGTMDataLayer('remove', cartResult, formElement);
    }
    ACC.monetate.updateCart(cartResult);
  },

  updateMiniCartAnalyticsData: function (cartResult, productCode, quantity) {
    var cartAnalyticsData = cartResult.cartAnalyticsData;

    var cartData = {
      productCode: productCode,
      quantity: quantity,
      cartCode: cartAnalyticsData ? cartAnalyticsData.cartCode : '',
      productPrice: cartAnalyticsData ? cartAnalyticsData.productPostPrice : '',
      productName: cartAnalyticsData ? cartAnalyticsData.productName : ''
    };

    if (ACC.product.initialQuantity < quantity) {
      ACC.track.trackAddToCart(productCode, quantity, cartData);
    } else if (ACC.product.initialQuantity > quantity) {
      ACC.track.trackRemoveFromCart(productCode, ACC.product.initialQuantity);
    }
  },

  updateGTMDataLayer: function (action, cartResult, formElement) {
    var trackQuantity;
    var formSource = ACC.gtmDataLayer.getPageSource(formElement);
    switch (action) {
      case 'add':
        trackQuantity = cartResult.quantity - ACC.product.initialQuantity === 1 ? 1 : cartResult.quantity - ACC.product.initialQuantity;
        break;
      case 'remove':
        trackQuantity = ACC.product.initialQuantity - cartResult.quantity === 1 ? 1 : Math.abs(ACC.product.initialQuantity - cartResult.quantity);
        break;
      case 'clear':
        trackQuantity = ACC.product.initialQuantity;
        break;
    }

    ACC.gtmDataLayer.trackProductCart(cartResult, formSource, trackQuantity, action);
  },

  bindQtyButtons: function () {
    $(document).on('focusin', ACC.product.ADDTOCART_QTY_INPUT, function () {
      this.select();
    });
    $(document).on('click', '.js-qtyBtn', function () {
      ACC.product.changeInputVal($(this));
    });
    $(document).on('input', '.js-productQtyInput', function () {
      ACC.product.enableUpdate($(this));
    });
    $(document).on('click', '.js-qtyChangeBtn', function () {
      var newVal = $(this).prev('.js-productQtyUpdate').find('.js-productQtyInput').val();
      if (newVal == 0 && $(this).attr('data-action') != 'add' && ACC.config.authenticated) {
        ACC.product.currentProductForm = $(this).parents('.js-addToCartForm');

        var isPromoItem = ACC.product.isPromoItem();
        ACC.product.quantityZeroPopup(isPromoItem);
      } else {
        ACC.global.checkLoginStatus(ACC.product.handleQtyButtonAction, $(this));
      }
    });
  },

  enableUpdate: function ($this) {
    var $btn = $this.parents('.js-productQtyUpdate').next('.js-qtyChangeBtn');
    var inputVal = $this.val();
    if ($btn.attr('data-action') == 'update') {
      $btn.attr('disabled', false);
    } else if (inputVal == 0 || !inputVal) {
      $btn.attr('disabled', true);
    } else {
      $btn.attr('disabled', false);
    }
  },

  bindQtyManualChange: function () {
    $(document).on('keypress', ACC.product.ADDTOCART_QTY_INPUT, ACC.product.handleInputKepress);
  },

  handleInputKepress: function (e) {
    var keyCode = e.keyCode || e.which;
    if (keyCode == 13) {
      if (ACC.global.keyPressCheck(e)) {
        ACC.product.handleInputChange($(this), true);
      }

      return false;
    } else if (keyCode != 8 && keyCode != 0 && (keyCode < 48 || keyCode > 57)) {
      // Only numbers allowed
      return false;
    }
  },
  changeInputVal: function ($btn) {
    var btnAction = $btn.data('action');
    ACC.product.currentProductForm = $btn.parents('.js-addToCartForm');
    var $addToCartButton = ACC.product.currentProductForm.find('.js-addToCartBtn');
    ACC.product.initialQuantity = parseInt(ACC.product.currentProductForm.find(ACC.product.PRODUCT_CART_QTY).val());
    var currentVal;
    var newVal;
    if (!($addToCartButton.hasClass('outOfStock') || $addToCartButton.hasClass('out-of-stock')) && !$addToCartButton.hasClass('priceUnavailable')) {
      $addToCartButton.attr('disabled', false);
    }

    switch (btnAction) {
      case 'add':
        currentVal = parseInt($btn.prev('.js-productQtyInput').val());
        newVal = currentVal + ACC.product.INCREMENT_VAL;
        $btn.prev('.js-productQtyInput').val(newVal);
        break;
      case 'remove':
        currentVal = parseInt($btn.next('.js-productQtyInput').val());
        if (currentVal != 0) {
          newVal = currentVal - ACC.product.INCREMENT_VAL;
        } else if (currentVal == 0) {
          newVal = currentVal;
        }
        if (newVal == 0) {
          $addToCartButton.attr('disabled', true);
        }
        $btn.next('.js-productQtyInput').val(newVal);
        if (newVal == 0 && $addToCartButton.attr('data-action') != 'add' && ACC.config.authenticated) {
          $addToCartButton.attr('disabled', false);
        }
    }
  },

  handleInputChange: function ($this, noPopUp) {
    ACC.product.currentProductForm = $this.parents('.js-addToCartForm');
    var newVal = $this.val();
    var currentVal = parseInt(ACC.product.currentProductForm.find(ACC.product.PRODUCT_CART_QTY).val());
    ACC.product.initialQuantity = currentVal;
    ACC.product.onValueChange(currentVal, newVal, ACC.product.currentProductForm, ACC.product.isPromoItem(), noPopUp);
  },

  handleQtyButtonAction: function ($btn) {
    var btnAction = $btn.data('action');
    ACC.product.currentProductForm = $btn.parents('.js-addToCartForm');
    var productCode = ACC.product.currentProductForm.find("[name='productCodePost']").val();
    var currentVal = parseInt(ACC.product.currentProductForm.find(ACC.product.PRODUCT_CART_QTY).val());
    var inputVal;
    var newVal;
    var qtyBtn = ACC.product.currentProductForm.find('.js-productQtyUpdate').find('.js-qtyBtn');
    if (qtyBtn.length) {
      inputVal = parseInt(ACC.product.currentProductForm.find('.js-productQtyUpdate').find('.js-productQtyInput').val());
      $btn.attr('disabled', true);
    }
    if (inputVal != 0 && qtyBtn.length) {
      newVal = inputVal;
    } else {
      newVal = ACC.product.changeProductQty(currentVal, btnAction);
    }

    ACC.product.initialQuantity = currentVal;
    if (newVal < ACC.product.cartLargeQty) {
      ACC.product.clearLargeQtyShown(productCode);
    }

    if (newVal == 1 && currentVal == 0) {
      ACC.product.proceedWithSubmit(newVal, ACC.product.currentProductForm);
    } else {
      ACC.product.onValueChange(currentVal, newVal, ACC.product.currentProductForm, ACC.product.isPromoItem(), btnAction);
    }
  },

  onValueChange: function (currentVal, newVal, $productForm, isPromoItem, btnAction, noPopUp) {
    if ($productForm.data('type') === 'minibasket' && !ACC.config.amendOrderPage) {
      //if triggered from minibasket, check if product exists in plp
      //if yes, set $productForm to plp form and continue as it change is made from plp
      ACC.product.minicartForm = $productForm;
      var productID = $productForm.data('id');
      var $plpForm = $('#addToCartForm' + productID);

      if ($plpForm.length) {
        $productForm = $plpForm;
        ACC.product.currentProductForm = $plpForm;
      }
    }

    var $productUpdate = $productForm.find('.js-productQtyUpdate');
    var qtyBtn = $productUpdate.find('.js-qtyBtn');
    ACC.product.updateQty(currentVal, newVal, $productForm);

    if (!ACC.product.changeValueViaModal) {
      if (currentVal == newVal) {
        return false;
      }
      if (newVal > ACC.product.cartMaxQty) {
        ACC.product.maxQuantityPopup();
      } else if (newVal >= ACC.product.cartLargeQty) {
        if (currentVal < newVal && btnAction != 'remove') {
          ACC.product.largeQuantityPopup(newVal, $productForm, false, qtyBtn);
        } else {
          if (!btnAction) {
            ACC.product.quantityAddPopup();
          } else if (noPopUp) {
            ACC.product.proceedWithSubmit(newVal, $productForm);
          } else {
            ACC.product.proceedWithSubmit(newVal, $productForm);
          }
        }
      } else if (newVal == 0) {
        ACC.product.quantityZeroPopup(isPromoItem);
      } else if (!btnAction) {
        ACC.product.quantityAddPopup();
      } else {
        ACC.product.proceedWithSubmit(newVal, $productForm);
      }
    } else {
      ACC.product.proceedWithSubmit(newVal, $productForm);
    }
  },

  checkShownLargePopup: function (productCode) {
    var gotSessionItem = sessionStorage.getItem('largeQtyShown');
    if (gotSessionItem && gotSessionItem != '') {
      return gotSessionItem.indexOf(productCode.toString()) > -1;
    } else {
      return false;
    }
  },

  setlargeQtyShown: function (productCode) {
    var gotSessionItem = sessionStorage.getItem('largeQtyShown');
    if (gotSessionItem && gotSessionItem !== '') {
      if (gotSessionItem.indexOf(productCode.toString()) == -1) {
        gotSessionItem += ':' + productCode;
        sessionStorage.setItem('largeQtyShown', gotSessionItem);
      }
    } else {
      sessionStorage.setItem('largeQtyShown', productCode.toString());
    }
  },

  clearLargeQtyShown: function (productCode) {
    var gotSessionItem = sessionStorage.getItem('largeQtyShown');
    if (gotSessionItem && gotSessionItem != '') {
      var shownItemsArray = gotSessionItem.split(':');
      var shownItemIndex = shownItemsArray.indexOf(productCode.toString());
      if (shownItemIndex > -1) {
        shownItemsArray.splice(shownItemIndex, 1);
        sessionStorage.setItem('largeQtyShown', shownItemsArray.join(':'));
      }
    } else {
      sessionStorage.removeItem('largeQtyShown');
    }
  },

  proceedWithSubmit: function (newVal, $productForm) {
    $('.js_spinner').show();

    ACC.product.submitWithQuantity(newVal, $productForm);
  },

  submitWithQuantity: function (newVal, $productForm) {
    // After form submit update form action
    if (parseInt($productForm.find(ACC.product.PRODUCT_CART_QTY).val()) == 0) {
      $productForm.attr('action', ACC.config.addToCartUrl);
    } else {
      $productForm.attr('action', ACC.config.updateCartUrl);
    }
    $productForm.find(ACC.product.PRODUCT_CART_QTY).val(newVal);
    $productForm.submit();
  },

  genericErrorHandlerPopup: function () {
    var $modal = $('#cartProductUnavailableGenericModal');
    $modal.one('show.bs.modal', function () {
      $('.js_spinner').hide();
    });

    $modal.modal('show');
  },

  quantityZeroPopup: function (isPromoItem) {
    var $quantityModal;

    if (isPromoItem) {
      $quantityModal = $('#promoQuantityZeroModal');
    } else {
      $quantityModal = $('#quantityZeroModal');
    }
    ACC.product.isZeroModal = true;
    ACC.product.showModal($quantityModal);
  },

  largeQuantityPopup: function (newVal, $productForm, isReplacement) {
    var $quantityModal;

    $quantityModal = isReplacement ? $('#quantityLargeReplacePopup') : $('#quantityLargePopupPlp');

    ACC.product.$cartQtyPopupLarge.text(newVal);
    ACC.product.setlargeQtyShown($productForm.data('id'));
    ACC.product.showModal($quantityModal);
  },

  maxQuantityPopup: function () {
    var $quantityModal = $('#quantityMaximumPopup');
    ACC.product.showModal($quantityModal);
  },

  showModal: function ($quantityModal) {
    $quantityModal.modal('show');

    $quantityModal.off('hidden.bs.modal', ACC.product.handleQuanityModalHide).on('hidden.bs.modal', ACC.product.handleQuanityModalHide);
  },

  handleQuanityModalHide: function () {
    var $productForm = ACC.product.currentProductForm;
    $productForm.find('.js-addToCartBtn').attr('disabled', false);

    if (!ACC.product.changeValueViaModal) {
      // CANCEL actions for modals

      if (ACC.product.minicartForm) {
        ACC.product.minicartForm.find(ACC.product.ADDTOCART_QTY_INPUT).val(ACC.product.initialQuantity);
        ACC.product.minicartForm.find(ACC.product.PRODUCT_CART_QTY).val(ACC.product.initialQuantity);
        ACC.product.minicartForm.find(ACC.product.ADDTOCART_QTY_INPUT).focus();
      } else {
        $productForm.find(ACC.product.ADDTOCART_QTY_INPUT).focus();
      }

      if (ACC.product.isZeroModal) {
        if (parseInt($productForm.find(ACC.product.PRODUCT_CART_QTY).val()) == 0) {
          $productForm.find(ACC.product.ADDTOCART_QTY_INPUT).val(1);
        } else {
          var val = parseInt($productForm.find(ACC.product.PRODUCT_CART_QTY).val());
          $productForm.find(ACC.product.ADDTOCART_QTY_INPUT).val(val);
        }
        //$productForm.find(ACC.product.PRODUCT_CART_QTY).val(ACC.product.initialQuantity);
        ACC.product.toggleProductQtyUpdate('show', $productForm);
        ACC.product.isZeroModal = false;
        $productForm.find('.js-addToCartBtn').attr('disabled', true);
      }
      if ($productForm.find(ACC.product.PRODUCT_CART_QTY).val() < ACC.product.cartLargeQty) {
        ACC.product.clearLargeQtyShown($productForm.data('id'));
      }
    }
  },

  confirmZeroQuantity: function () {
    $(document).on('click', '#confirmZeroQuantity', function () {
      var newVal = 0;
      var $productForm = ACC.product.currentProductForm;

      ACC.product.changeValueViaModal = true;
      ACC.product.$modals.modal(ACC.product.HIDE_CLASS);

      ACC.product.clearLargeQtyShown($productForm.data('id'));

      ACC.product.proceedWithSubmit(newVal, $productForm);
    });
  },

  bindConfirmLargeQuantity: function () {
    $(document).on('click', '#confirmLargeQuantity', function () {
      var $productForm = ACC.product.currentProductForm;
      var $parentModal = $(this).parents('.js-cartModal');
      var currentVal = parseInt($productForm.find(ACC.product.PRODUCT_CART_QTY).val());
      var newVal = parseInt($productForm.find(ACC.product.ADDTOCART_QTY_INPUT).val());
      ACC.product.bindModalApprovalResponse($productForm, $parentModal, currentVal, newVal);
    });
  },

  bindReplaceQuantity: function () {
    $(document).on('click', '#replaceQuantity', function () {
      var $productForm = ACC.product.currentProductForm;
      var $parentModal = $(this).parents('.js-cartModal');
      var currentVal = parseInt($productForm.find(ACC.product.PRODUCT_CART_QTY).val());
      var newVal = parseInt($productForm.find(ACC.product.ADDTOCART_QTY_INPUT).val());
      if (newVal < ACC.product.cartLargeQty) {
        ACC.product.clearLargeQtyShown($productForm.data('id'));
      }

      ACC.product.bindModalApprovalResponse($productForm, $parentModal, currentVal, newVal);
    });
  },

  bindAddToQuantity: function () {
    $(document).on('click', '#addToQuantity', function () {
      var $productForm = ACC.product.currentProductForm;
      var $parentModal = $(this).parents('.js-cartModal');
      var currentVal = parseInt($productForm.find(ACC.product.PRODUCT_CART_QTY).val());
      var newVal = currentVal + parseInt($productForm.find(ACC.product.ADDTOCART_QTY_INPUT).val());
      $productForm.find(ACC.product.ADDTOCART_QTY_INPUT).val(newVal);
      if (newVal > ACC.product.cartMaxQty) {
        $parentModal.one('hidden.bs.modal', function () {
          ACC.product.maxQuantityPopup(currentVal, $productForm);
        });
        $parentModal.modal(ACC.product.HIDE_CLASS);
      } else if (
        newVal >= ACC.product.cartLargeQty &&
        ($parentModal.attr('id') != 'quantityLargePopup' || $parentModal.attr('id') != 'quantityLargePopupPlp')
      ) {
        $parentModal.off('hidden.bs.modal', ACC.product.handleQuanityModalHide);
        $parentModal.one('hidden.bs.modal', function () {
          ACC.product.largeQuantityPopup(newVal, $productForm, true);
        });
        $parentModal.modal(ACC.product.HIDE_CLASS);
      } else {
        ACC.product.bindModalApprovalResponse($productForm, $parentModal, currentVal, newVal);
      }
    });
  },

  bindModalApprovalResponse: function ($productForm, $parentModal, currentVal, newVal) {
    ACC.product.updateQty(currentVal, newVal, $productForm);
    ACC.product.changeValueViaModal = true;

    $parentModal.one('hidden.bs.modal', function () {
      ACC.product.onValueChange(currentVal, newVal, $productForm);
    });
    $parentModal.modal(ACC.product.HIDE_CLASS);
  },

  displayAlert: function () {
    var $deleteAlert = $('.js-productDeletedAlert');
    $deleteAlert.removeClass(ACC.product.HIDE_CLASS);
    setTimeout(function () {
      $deleteAlert.addClass(ACC.product.HIDE_CLASS);
    }, 5000);
  },

  updateQtyOverlayValue: function (itemCartQty, $productForm) {
    var $productItem = $productForm.parents('.js-productItem');
    var $qtyOverlay = $productItem.find('.js-qtyOverlayValue');
    $qtyOverlay.html(itemCartQty);
  },

  toggleQtyOverlay: function (itemCartQty, $productForm) {
    var $productItem = $productForm.parents('.js-productItem');
    var IS_ADDED = 'is-added';
    if (itemCartQty > 0) {
      $productItem.addClass(IS_ADDED);
    } else {
      $productItem.removeClass(IS_ADDED);
    }
  },

  toggleProductQtyUpdate: function (toggleVal, $productFormObj) {
    //if change is triggered from miniBasket skip toggle
    if ($productFormObj.data('type') === 'minibasket') {
      return;
    }
    var $productUpdate = $productFormObj.find('.js-productQtyUpdate');
    var $addToCartBtn = $productFormObj.find('.js-addToCartBtn');
    var inputVal = $productFormObj.find('.js-productQtyUpdate').find('.js-productQtyInput').val();
    var qtyBtn = $productUpdate.find('.js-qtyBtn');
    if (qtyBtn.length) {
      ACC.product.addToCartButtonUpdate(toggleVal, $addToCartBtn, inputVal);
    } else {
      if (toggleVal == ACC.product.HIDE_CLASS) {
        $addToCartBtn.removeClass(ACC.product.HIDE_CLASS);
        $productUpdate.addClass(ACC.product.HIDE_CLASS);
      } else {
        $addToCartBtn.addClass(ACC.product.HIDE_CLASS);
        $productUpdate.removeClass(ACC.product.HIDE_CLASS);
      }
    }
  },

  addToCartButtonUpdate: function (toggleVal, $addToCartBtn, inputVal) {
    if (toggleVal == ACC.product.HIDE_CLASS) {
      $addToCartBtn.text('Add');
      $addToCartBtn.attr('data-action', 'add');
    } else if (inputVal > 0) {
      $addToCartBtn.text('Update');
      $addToCartBtn.attr('disabled', true);
      $addToCartBtn.attr('data-action', 'update');
    } else {
      $addToCartBtn.text('Add');
      $addToCartBtn.attr('data-action', 'add');
    }
  },

  updateQty: function (currentVal, newVal, $productFormObj) {
    // update only if both values are different
    var setNewValue = newVal;
    if (setNewValue === '') {
      setNewValue = 0;
    }
    if (newVal == 0 && $productFormObj.find('.js-addToCartBtn').attr('data-action') == 'add') {
      $productFormObj.find('.js-addToCartBtn').attr('disabled', false);
      $productFormObj.find('.js-productQtyInput').val(1);
    } else if (newVal != 0 && $productFormObj.find('.js-addToCartBtn').attr('data-action') == 'update') {
      $productFormObj.find('.js-addToCartBtn').attr('disabled', true);
    }
    if (currentVal != setNewValue) {
      $productFormObj.find(ACC.product.ADDTOCART_QTY_INPUT).val(setNewValue);

      // set minibasket form input balue
      var productCode = $productFormObj.find("[name='productCodePost']").val();
      if ($('.js-cartItemsList').find("form[data-id='" + productCode + "']").length > 0 && !ACC.config.amendOrderPage) {
        $('.js-cartItemsList')
          .find("form[data-id='" + productCode + "']")
          .find(ACC.product.ADDTOCART_QTY_INPUT)
          .val(setNewValue);
      }
    }
  },

  changeProductQty: function (currentVal, actionName) {
    var newVal;
    if (actionName == 'add') {
      newVal = currentVal + ACC.product.INCREMENT_VAL;
    } else {
      newVal = currentVal - ACC.product.INCREMENT_VAL;
    }
    return newVal;
  },

  //This info is used to determine what modal should be displayed on product removal
  //(regular qty zero modal or modal warning user that promotion will be removed)
  isPromoItem: function () {
    return ACC.product.currentProductForm.hasClass('js-cartItemPromoGroup');
  },

  quantityAddPopup: function () {
    var $quantityModal = $('#quantityCartModal');
    ACC.product.showModal($quantityModal);
  },

  productDetailsDescriptionExpand: function () {
    $('.js-prodMoreText').removeClass(ACC.product.HIDE_CLASS);
    $('.js-prodMoreEllipses').addClass(ACC.product.HIDE_CLASS);
    $('.js-expandProdDesc').addClass(ACC.product.HIDE_CLASS);
    $('.js-collapseProdDesc').removeClass(ACC.product.HIDE_CLASS);
  },
  productDetailsDescriptionCollapse: function () {
    $('.js-prodMoreText').addClass(ACC.product.HIDE_CLASS);
    $('.js-prodMoreEllipses').removeClass(ACC.product.HIDE_CLASS);
    $('.js-expandProdDesc').removeClass(ACC.product.HIDE_CLASS);
    $('.js-collapseProdDesc').addClass(ACC.product.HIDE_CLASS);
  },
  initProductReadMore: function () {
    $(document).on('click', '.js-expandProdDesc', this.productDetailsDescriptionExpand);
    $(document).on('click', '.js-collapseProdDesc', this.productDetailsDescriptionCollapse);
  },
  productDetailsDescription: function () {
    var $prodDesc = $('.js-productDetailsDescText');
    var originalProdDescText = $prodDesc.html();
    var mobileLengthMax = ACC.config.productDesc.mobileLength;
    var tabletLengthMax = ACC.config.productDesc.tabletLength;
    var desktopLengthMax = ACC.config.productDesc.desktopLength;
    var breakTagsLength = (originalProdDescText.match(/<br>/g) || []).length;
    var prodDescTextLength = originalProdDescText.length - breakTagsLength * 4;

    var editedText = {
      part1: '',
      part2: '',
      showReadMore: false
    };

    enquire.register('screen and (max-width:' + ACC.breakpoints.screenXsMax + ')', function () {
      editedText.part1 = originalProdDescText.substring(0, mobileLengthMax);
      editedText.part2 = originalProdDescText.substring(mobileLengthMax);
      editedText.showReadMore = prodDescTextLength > mobileLengthMax ? true : false;
      ACC.global.renderHandlebarsTemplate(editedText, 'jsProductDetailsDesc', 'product-desc-template');
    });
    enquire.register('screen and (min-width:' + ACC.breakpoints.screenSmMin + ') and (max-width:' + ACC.breakpoints.screenSmMax + ')', function () {
      editedText.part1 = originalProdDescText.substring(0, tabletLengthMax);
      editedText.part2 = originalProdDescText.substring(tabletLengthMax);
      editedText.showReadMore = prodDescTextLength > tabletLengthMax ? true : false;
      ACC.global.renderHandlebarsTemplate(editedText, 'jsProductDetailsDesc', 'product-desc-template');
    });
    enquire.register('screen and (min-width:' + ACC.breakpoints.screenMdMin + ')', function () {
      editedText.part1 = originalProdDescText.substring(0, desktopLengthMax);
      editedText.part2 = originalProdDescText.substring(desktopLengthMax);
      editedText.showReadMore = prodDescTextLength > desktopLengthMax ? true : false;
      ACC.global.renderHandlebarsTemplate(editedText, 'jsProductDetailsDesc', 'product-desc-template');
    });

    this.initProductReadMore();
  }
};

export default product;
