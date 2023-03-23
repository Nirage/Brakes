const quickAdd = {
  _autoload: [['initQuickAdd', $('.js-quickAddForm').length]],
  maxQty: 0,
  largeQty: 0,
  allowSubmit: false,
  FORM_SELECTOR: '.js-quickAddForm',
  FORM_ACTION_CLASS: '.js-quickAddChangeQuantity',
  FORM_INPUT: '.js-quickAddInput',
  FORM_INPUT_PRODUCTCODE: '.js-quickAddProductCode',
  FORM_QUANTITY_CLASS: '.js-quickAddQty',
  CART_INPUT_QUANTITY_CLASS: '.js-productCartQtyInput',
  ADDTOCART_INPUT_QUANTITY_CLASS: '.js-productQtyInput',
  ADDTOCART_QUANTITY_CLASS: '.js-productCartQty',
  FORM_BUTTON: '.js-quickAddSubmitButton',
  ACTIVE_CLASS: 'is-active',
  HIDE_CLASS: 'hide',
  MINI_CART_DATA: 'quickadd-minicart',
  $allForms: {},
  EMPTY_INPUT_SUFFIX: '-empty',
  quickAddInitialized: false,
  initialQuantity: undefined,
  initQuickAdd: function () {
    if (ACC.quickAdd.quickAddInitialized) {
      return;
    }
    ACC.quickAdd.quickAddInitialized = true;
    this.setMaxQty();
    this.bindQuickAddFormSubmit();
    this.bindInputsValidation();
    this.bindQuickAddModalActions();
    this.bindExceedsError();
    this.onPageLoad();
    ACC.quickAdd.$allForms = $(ACC.quickAdd.FORM_SELECTOR);
    $(document).on('keypress', ACC.quickAdd.FORM_INPUT_PRODUCTCODE, ACC.quickAdd.handleInputKepress);
    $(document).on('keypress', ACC.quickAdd.FORM_QUANTITY_CLASS, ACC.quickAdd.handleSubmit);
    $(document).on('focus', ACC.quickAdd.FORM_QUANTITY_CLASS, ACC.quickAdd.focusQtyField);
  },

  bindExceedsError: function () {
    if (window.quickAddQtyExceeds) {
      $('#quantityMaximumPopup').modal('show');
    }
  },
  focusQtyField: function (e) {
    var $qtyField = $(e.currentTarget);
    var $productCode = $qtyField.prev('.js-quickAddProductCode');
    if ($productCode.val()) {
      var $form = $qtyField.parents('form');
      var validationType = $qtyField.data('validation-type');
      var $submitButton = $form.find('.js-submitBtn');

      if (!$qtyField.val()) {
        $qtyField.val(1);
      }
      $qtyField.select();
      ACC.quickAdd.toggleError($form, $qtyField, true, validationType + ACC.quickAdd.EMPTY_INPUT_SUFFIX);
      var isFormValid = ACC.quickAdd.validateForm($form);
      ACC.quickAdd.toggleSubmitButton(isFormValid, $submitButton);
    }
  },
  handleSubmit: function (e) {
    var keyCode = e.keyCode || e.which;
    if (keyCode == 13) {
      var $qtyField = $(e.currentTarget);
      if (ACC.global.keyPressCheck(e)) {
        var $form = $qtyField.parents('form');
        if (!ACC.quickAdd.allowSubmit) {
          e.preventDefault();
          ACC.global.checkLoginStatus(ACC.quickAdd.onFormSubmit, $form);
        }
      }
      return false;
    }
  },
  handleInputKepress: function (e) {
    var keyCode = e.keyCode || e.which;
    if (keyCode == 13) {
      var $qtyField = $(e.currentTarget).next('.js-quickAddQty');
      if (ACC.global.keyPressCheck(e)) {
        $qtyField.focus();
      }
      return false;
    }
  },
  onPageLoad: function () {
    this.focusInputField();
  },
  focusInputField: function () {
    var $quickAddError = $('.js-quickAddBackendError');
    var $input;
    if ($quickAddError.length > 0) {
      $input = $quickAddError.parents(ACC.quickAdd.FORM_SELECTOR).find(ACC.quickAdd.FORM_INPUT_PRODUCTCODE);
    } else if (sessionStorage.getItem('quickAddActive') === 'true') {
      $input = $(ACC.quickAdd.FORM_INPUT_PRODUCTCODE);
    }
    if (typeof $input != 'undefined') {
      $input.select();
      $input.focus();
    }

    sessionStorage.setItem('quickAddActive', false);
  },
  setMaxQty: function () {
    var $form = $(ACC.quickAdd.FORM_SELECTOR);
    var maxQty = $form.data('max-qty');
    var largeQty = $form.data('large-qty');
    ACC.quickAdd.maxQty = parseInt(maxQty);
    ACC.quickAdd.largeQty = parseInt(largeQty);
  },

  setActionName: function (actionName) {
    $(ACC.quickAdd.FORM_ACTION_CLASS).val(actionName);
  },

  bindQuickAddFormSubmit: function () {
    $(document).on('submit', ACC.quickAdd.FORM_SELECTOR, function (e) {
      if (!ACC.quickAdd.allowSubmit) {
        e.preventDefault();
        ACC.global.checkLoginStatus(ACC.quickAdd.onFormSubmit, $(this));
      }
    });
  },

  onFormSubmit: function ($form) {
    var isMiniCartForm = $form.data(ACC.quickAdd.MINI_CART_DATA);
    var isFormValid = ACC.quickAdd.validateForm($form);
    var $submitButton = $form.find('.js-submitBtn');
    var $cartItemsList;

    if (ACC.config.amendOrderPage && $form.hasClass('js-orderQuickAddForm')) {
      $cartItemsList = $('.js-orderItemList').find('.js-orderItemCode');
    } else {
      $cartItemsList = $('.js-cartItemsList').find('.js-cartItemCode');
    }

    var productCode = $form.find(ACC.quickAdd.FORM_INPUT_PRODUCTCODE).val();
    var isProductInCart = ACC.quickAdd.checkIfProductExists(productCode, $cartItemsList);

    ACC.quickAdd.$allForms.removeClass(ACC.quickAdd.ACTIVE_CLASS);

    $form.addClass(ACC.quickAdd.ACTIVE_CLASS);

    if (!ACC.quickAdd.allowSubmit) {
      ACC.quickAdd.setActionName(''); // reset value
    }

    ACC.quickAdd.toggleSubmitButton(isFormValid, $submitButton);

    if (isFormValid) {
      if (!ACC.quickAdd.allowSubmit) {
        ACC.quickAdd.qtyChanged($form, isMiniCartForm, isProductInCart, productCode);
      }
    }
    sessionStorage.setItem('quickAddActive', isFormValid);
    return isFormValid;
  },

  handleGTMUpdates: function (formElement) {
    var cartData = ACC.quickAdd.processCartData();
    if (cartData) {
      if (cartData.quantityAdded > 0) {
        ACC.product.initialQuantity = cartData.quantity - cartData.quantityAdded;
        ACC.product.updateGTMDataLayer('add', cartData.entry, formElement);
      } else if (cartData.quantityAdded < 0) {
        ACC.product.initialQuantity = cartData.quantity + cartData.quantityAdded;
        ACC.product.updateGTMDataLayer('remove', cartData.entry, formElement);
      }
    }
  },

  processCartData: function () {
    var cartModificationString = $('#cartModificationJson').html();
    var fixedCartData = cartModificationString.replace(/(\r\n|\n|\r| )/gm, '');
    try {
      var cartData = JSON.parse(fixedCartData);
      return cartData;
    } catch (e) {
      console.error('Failed to parse Cart Data JSON.');
      return null;
    }
  },

  checkIfProductExists: function (quickAddProd, $itemsList) {
    var productExists = false;
    $itemsList.each(function () {
      var productCode = $(this).data('code');
      var isFreeItem = ACC.quickAdd.checkIsFreeItem($(this));

      if (productCode == quickAddProd && !isFreeItem) {
        productExists = true;
        return false; // Exit early
      }
    });
    return productExists;
  },

  checkIsFreeItem: function ($this) {
    return $this.parents('.js-cartItem').find('.js-displayingFreeForZero').length > 0;
  },

  bindQuickAddModalActions: function () {
    $(document).on('click', '.js-quickAddReplace', function () {
      ACC.quickAdd.doReplaceAction();
    });
    $(document).on('click', '.js-quickAddUpdate', function () {
      ACC.quickAdd.doUpdateAction();
    });
    $(document).on('click', '.js-largeQtyPopupAdd', function () {
      ACC.quickAdd.doReplaceAction();
    });
    $(document).on('click', '.js-largeQtyPopupCancel', function () {
      ACC.quickAdd.resetQtyInputField(ACC.quickAdd.FORM_SELECTOR, ACC.quickAdd.ACTIVE_CLASS);
    });
  },

  qtyChanged: function ($form, isMiniCartForm, isProductInCart, productCode) {
    var value = $form.find(ACC.quickAdd.FORM_QUANTITY_CLASS).val();
    var largeQuantityShown = ACC.product.checkShownLargePopup(productCode);
    if (parseInt(value) > ACC.quickAdd.maxQty) {
      ACC.quickAdd.showMaxQuantityPopup(isMiniCartForm);
    } else if (parseInt(value) > ACC.quickAdd.largeQty && largeQuantityShown == false) {
      ACC.quickAdd.showLargeQuantityPopup(value, isMiniCartForm, isProductInCart, productCode);
    } else {
      if (isProductInCart) {
        ACC.quickAdd.showOrderQuantityModal(isMiniCartForm, isProductInCart);
      } else {
        ACC.quickAdd.doUpdateAction();
      }
    }
  },

  doUpdateAction: function () {
    ACC.quickAdd.setActionName('update');
    ACC.quickAdd.allowSubmit = true;
    ACC.quickAdd.submitActiveForm(ACC.quickAdd.ACTIVE_CLASS, 'update');
  },

  doReplaceAction: function () {
    ACC.quickAdd.setActionName('replace');
    ACC.quickAdd.allowSubmit = true;
    ACC.quickAdd.submitActiveForm(ACC.quickAdd.ACTIVE_CLASS, 'replace');
  },

  showMaxQuantityPopup: function (isMiniCartForm) {
    var $modal = ACC.config.amendOrderPage && !isMiniCartForm ? $('#orderQuantityMaximumPopup') : $('#quantityMaximumPopup');
    $modal.one('hidden.bs.modal', ACC.quickAdd.focusQuickAddInputField);
    $modal.modal('show');
  },

  showLargeQuantityPopup: function (value, isMiniCartForm, isProductInCart, productCode) {
    var $modal;
    $('.js-cartQtyPopupLarge').html(value);
    if (ACC.config.amendOrderPage && !isMiniCartForm) {
      if (isProductInCart) {
        $modal = $('#orderQuantityLargeReplacePopupQuickAdd');
      } else {
        $modal = $('#orderQuantityLargePopupQuickAdd');
      }
    } else {
      if (isProductInCart) {
        $modal = $('#quantityLargePopupReplaceQuickAdd');
      } else {
        $modal = $('#quantityLargePopupQuickAdd');
      }
    }

    $modal.one('hidden.bs.modal', ACC.quickAdd.focusQuickAddInputField);
    $modal.one('show.bs.modal', function () {
      ACC.product.setlargeQtyShown(productCode);
    });
    $modal.modal('show');
  },

  showOrderQuantityModal: function (isMiniCartForm, isProductInCart) {
    var $modal;
    if (ACC.config.amendOrderPage && !isMiniCartForm) {
      if (isProductInCart) {
        $modal = $('#orderQuickAddUpdateReplaceQtyModal');
      } else {
        $modal = $('#orderQuickAddUpdateQtyModal');
      }
    } else {
      if (isProductInCart) {
        $modal = $('#quickAddUpdateReplaceQtyModal');
      } else {
        $modal = $('#quickAddUpdateQtyModal');
      }
    }
    $modal.one('hidden.bs.modal', ACC.quickAdd.focusQuickAddInputField);
    $modal.modal('show');
  },

  showProductUnavailablePopup: function () {
    var $modal = $('#cartProductUnavailableModal');
    $modal.one('hidden.bs.modal', ACC.quickAdd.focusQuickAddInputField);
    $modal.modal('show');
  },

  focusQuickAddInputField: function () {
    ACC.quickAdd.allowSubmit = false;
    if ($('.js-unavailableActiveError').length > 0) {
      var $amendOrderForm = $('.js-unavailableActiveError').parents('form');
      $amendOrderForm.find(ACC.quickAdd.FORM_INPUT_PRODUCTCODE).select();
      $amendOrderForm.find(ACC.quickAdd.FORM_INPUT_PRODUCTCODE).focus();
    } else {
      $(ACC.quickAdd.FORM_INPUT_PRODUCTCODE).select();
      $(ACC.quickAdd.FORM_INPUT_PRODUCTCODE).focus();
    }
  },

  bindInputsValidation: function () {
    $(document).on('change keyup', ACC.quickAdd.FORM_INPUT, ACC.quickAdd.onFormInputChange);

    $(document).on('keypress', ACC.quickAdd.FORM_INPUT, function (e) {
      // Only numbers allowed
      if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
        return false;
      }
    });
  },

  onFormInputChange: function () {
    var $this = $(this);
    var $form = $(this).parents('form');
    var $submitButton = $form.find('.js-submitBtn');
    var value = $this.val();
    var validationType = $this.data('validation-type');
    var isValid = ACC.quickAdd.validateField(value, validationType, $this);
    var isFormValid = false;

    if (value === '') {
      //We are showing error for empty field, and hiding invalid field value
      ACC.quickAdd.toggleError($form, $this, false, validationType + ACC.quickAdd.EMPTY_INPUT_SUFFIX);
      ACC.quickAdd.toggleError($form, $this, true, validationType);
    } else {
      //We are hiding error about empty field, and showing invalid field value based on validateField result
      ACC.quickAdd.toggleError($form, $this, true, validationType + ACC.quickAdd.EMPTY_INPUT_SUFFIX);
      ACC.quickAdd.toggleError($form, $this, isValid, validationType);
    }

    isFormValid = ACC.quickAdd.validateForm($form);
    ACC.quickAdd.toggleSubmitButton(isFormValid, $submitButton);
    $('.js-quickAddBackendError').addClass(ACC.quickAdd.HIDE_CLASS);
  },

  toggleSubmitButton: function (isFormValid, $submitButton) {
    if (isFormValid) {
      $submitButton.attr('disabled', false);
    } else {
      $submitButton.attr('disabled', true);
    }
  },
  // quickAddAction(update or replace)  is used on the Amend Order Page,
  // where we need to do calculation of new quantity in the FE
  submitActiveForm: function (activeClassName, quickAddAction) {
    // Since there might be more then quick add forms on the page
    // We should submit only one which was last edited
    var $allForms = $(ACC.quickAdd.FORM_SELECTOR);
    $allForms.each(function () {
      var $form = $(this);
      var isMiniCartForm = $form.data(ACC.quickAdd.MINI_CART_DATA);
      if ($form.hasClass(activeClassName)) {
        if (ACC.quickAdd.calculateNewQty($form, isMiniCartForm, quickAddAction)) {
          if (isMiniCartForm) {
            ACC.quickAdd.getMinicart($form);
          } else {
            $form.submit();
          }
        }
      }
    });
  },

  checkLargeQuantity: function ($form) {
    if (parseInt($form.find(ACC.quickAdd.FORM_QUANTITY_CLASS).val()) < ACC.quickAdd.largeQty) {
      ACC.product.clearLargeQtyShown($form.find(ACC.quickAdd.FORM_INPUT_PRODUCTCODE).val());
    }
  },

  //On the Amend Order Page, FE is calculating and setting new qty for updating product by quick add
  calculateNewQty: function ($form, isMiniCartForm, quickAddAction) {
    var productCode = $form.find(ACC.quickAdd.FORM_INPUT_PRODUCTCODE).val();

    var $addToCartForm = $(".js-addToCartForm[data-id='" + productCode + "']");

    if (isMiniCartForm) {
      ACC.quickAdd.initialQuantity = $addToCartForm.find(ACC.quickAdd.ADDTOCART_QUANTITY_CLASS).val();
    } else {
      ACC.quickAdd.initialQuantity = $addToCartForm.find(ACC.quickAdd.CART_INPUT_QUANTITY_CLASS).val();
    }

    var qtyToAdd = $form.find(ACC.quickAdd.FORM_QUANTITY_CLASS).val();

    if (!ACC.quickAdd.initialQuantity) {
      ACC.quickAdd.initialQuantity = ACC.quickAdd.getRemovedEntryCurrentQty(productCode);
    }

    $form.find(ACC.quickAdd.FORM_ACTION_CLASS).val(quickAddAction);

    if (quickAddAction === 'update') {
      return ACC.quickAdd.calcQuickAddUpdate($form, isMiniCartForm, productCode, qtyToAdd);
    } else if (quickAddAction === 'replace') {
      return ACC.quickAdd.calcQuickAddReplace($form, $addToCartForm, qtyToAdd);
    }
  },

  calcQuickAddUpdate: function ($form, isMiniCartForm, productCode, qtyToAdd) {
    var newQty = parseInt(qtyToAdd) + parseInt(ACC.quickAdd.initialQuantity);
    var largeQuantityShown = ACC.product.checkShownLargePopup(productCode);

    if (newQty > ACC.quickAdd.maxQty) {
      $('.modal').modal(ACC.quickAdd.HIDE_CLASS);
      $('.spinnner').removeClass(ACC.quickAdd.HIDE_CLASS);
      ACC.quickAdd.showMaxQuantityPopup($form);
      return false;
    } else if (newQty > ACC.quickAdd.largeQty && largeQuantityShown == false) {
      $('.modal').modal(ACC.quickAdd.HIDE_CLASS);
      $('.spinnner').removeClass(ACC.quickAdd.HIDE_CLASS);
      ACC.quickAdd.updateQuickAddQuantity($form, newQty);
      // show large Quantity as though product is not in cart
      ACC.quickAdd.showLargeQuantityPopup(newQty, isMiniCartForm, false, productCode);
      return false;
    } else {
      if (!isNaN(newQty)) {
        if (ACC.config.amendOrderPage) {
          // amend Order Page endpoint for update is requiring FE calculation
          ACC.quickAdd.updateQuickAddQuantity($form, newQty);
        }
        return true;
      }
      return false;
    }
  },

  calcQuickAddReplace: function ($form, $addToCartForm, qtyToAdd) {
    ACC.quickAdd.updateQuickAddQuantity($form, qtyToAdd);
    ACC.quickAdd.checkLargeQuantity($form);
    $addToCartForm.find(ACC.quickAdd.ADDTOCART_QUANTITY_CLASS).val(qtyToAdd);
    return true;
  },

  updateQuickAddQuantity: function ($form, value) {
    $form.find(ACC.quickAdd.FORM_QUANTITY_CLASS).val(value);
  },

  getRemovedEntryCurrentQty: function (productToUpdateCode) {
    var $removedEntry = $('[data-removed-code=' + productToUpdateCode + ']');
    if ($removedEntry.length > 0) {
      return $removedEntry.data('qty');
    } else {
      return 0;
    }
  },

  getMinicart: function ($form) {
    ACC.cartactions.unbindEventListeners();
    ACC.minicart.$spinner.removeClass('hide');
    var endpoint = $form.attr('action');
    $.ajax({
      type: 'POST',
      url: endpoint,
      data: $form.serialize(), // serializes the form's elements.
      success: function (response) {
        ACC.quickAdd.allowSubmit = false;
        ACC.quickAdd.getMinicartSuccess(response, $form);
      },
      error: function () {
        ACC.global.checkLoginStatus();
      }
    });
  },

  getMinicartSuccess: function (response, $form) {
    ACC.minicart.showMiniCartGlobalMsg(response);
    ACC.minicart.updateMiniBasketWithContent(response);
    ACC.minicart.$miniBasketDetails.find(ACC.quickAdd.FORM_INPUT_PRODUCTCODE).focus();
    var $error = $(response).find('.quick-add__error');
    var hasError = false;
    var outOfStockError = false;
    $error.each(function () {
      if (!$(this).hasClass(ACC.quickAdd.HIDE_CLASS)) {
        hasError = true;
        if ($(this).text().indexOf('Product out of stock.') > -1) {
          outOfStockError = true;
        }
      }
    });

    if (hasError) {
      if (outOfStockError) {
        $('.quick-add__error').addClass(ACC.quickAdd.HIDE_CLASS);
        ACC.quickAdd.showProductUnavailablePopup();
      }
      return;
    } else {
      ACC.quickAdd.doMinicartUpdates($form);
    }
  },

  doMinicartUpdates: function ($form) {
    ACC.minicart.updateHeaderMiniCart(false);
    ACC.quickAdd.updateProductOnPLP($form);
    ACC.quickAdd.bindQuickAddFormSubmit();
    ACC.quickAdd.handleGTMUpdates($form);
    // hide all modals
    $('.modal').modal(ACC.quickAdd.HIDE_CLASS);
  },

  updateProductOnPLP: function ($form) {
    var productCode = $form.find(ACC.quickAdd.FORM_INPUT_PRODUCTCODE).val();
    var entryNumber = $(".js-cartItemsList .js-addToCartForm[data-id='" + productCode + "']")
      .find("[name='entryNumber']")
      .val();
    var qty = parseInt($form.find(ACC.quickAdd.FORM_QUANTITY_CLASS).val());
    var action = $form.find(ACC.quickAdd.FORM_ACTION_CLASS).val();
    var $plpForm = $('#addToCartForm' + productCode);
    if ($plpForm.length == 0) {
      return;
    }

    var newVal;
    if (action == 'update') {
      newVal = parseInt(
        $(".mini-basket-qty-picker__form.js-addToCartForm[data-id='" + productCode + "']")
          .find(ACC.quickAdd.ADDTOCART_QUANTITY_CLASS)
          .val()
      );
    } else {
      newVal = qty;
    }

    $plpForm.attr('action', ACC.config.updateCartUrl);
    $plpForm.find(ACC.quickAdd.ADDTOCART_INPUT_QUANTITY_CLASS).val(newVal);
    $plpForm.find(ACC.quickAdd.ADDTOCART_QUANTITY_CLASS).val(newVal);
    entryNumber !== null ? $plpForm.find("[name='entryNumber']").val(entryNumber) : false;

    ACC.product.updateQtyOverlayValue(newVal, $plpForm);
    ACC.product.toggleQtyOverlay(newVal, $plpForm);
    ACC.product.toggleProductQtyUpdate('show', $plpForm);
  },

  validateForm: function ($form) {
    var HAS_ERROR = '.has-error';

    var $inputFields = $form.find(ACC.quickAdd.FORM_INPUT);
    var errorCount = $form.find(HAS_ERROR).length;
    var isValid = false;

    if (errorCount) {
      isValid = false;
    } else {
      isValid = true;
    }
    $inputFields.each(function () {
      var $this = $(this);
      var validationType = $this.data('validation-type');
      if ($this.val() == '') {
        isValid = false;
        ACC.quickAdd.toggleError($form, $this, isValid, validationType + ACC.quickAdd.EMPTY_INPUT_SUFFIX);
      }
    });
    return isValid;
  },
  toggleError: function ($form, $field, isValid, errorType) {
    var HAS_ERROR = 'has-error';
    ACC.quickAdd.$allForms.removeClass(ACC.quickAdd.ACTIVE_CLASS);
    $form.addClass(ACC.quickAdd.ACTIVE_CLASS);
    var $errorMsg = $form.find(".js-quickAddError[data-error-type='" + errorType + "']");
    if (isValid) {
      $field.removeClass(HAS_ERROR);
      $errorMsg.addClass(ACC.quickAdd.HIDE_CLASS);
    } else {
      $field.addClass(HAS_ERROR);
      $errorMsg.removeClass(ACC.quickAdd.HIDE_CLASS);
    }
  },
  resetQtyInputField: function (formSelector, activeClassName) {
    var $activeForm = $(formSelector + '.' + activeClassName);
    var $qtyInput = $activeForm.find('.js-quickAddInput[data-validation-type="qty"]');
    var productCode = $activeForm.data('id');
    ACC.product.clearLargeQtyShown(productCode);
    $qtyInput.val('');
    ACC.quickAdd.focusQuickAddInputField();
  },
  validateField: function (value, validationType, $field) {
    var isValid = false;
    var numericRegex = new RegExp('^[0-9]*$', 'g');
    var isNum = numericRegex.test(value);
    var isMiniCart = false;
    if ($field.parents(ACC.quickAdd.FORM_SELECTOR).data(ACC.quickAdd.MINI_CART_DATA)) {
      isMiniCart = true;
    }

    if (value == '') {
      return false;
    }

    if (isNum) {
      isValid = true;
    } else {
      return false;
    }
    if (validationType == 'qty') {
      if (parseInt(value) > ACC.quickAdd.maxQty) {
        isValid = false;
      } else {
        isValid = true;
      }
    }

    return isValid;
  }
};

export default quickAdd;
