const cartitem = {
  _autoload: ['bindCartItem'],

  init: function () {
    $(document).on('click keypress', '.js-cartItemDetailBtn', function (e) {
      e.stopPropagation();
      if (ACC.global.keyPressCheck(e)) {
        ACC.global.checkLoginStatus(ACC.cartitem.cartItemDetailClick, $(this));
      }
    });
  },
  submitTriggered: false,

  cartItemDetailClick: function ($this) {
    var productFormId = $this.data('form-id');
    $('#editing-row-item').val(productFormId);
    var $productForm = $('#' + productFormId);
    ACC.cart.$currentlyEditedItem.val(productFormId);
    ACC.cart.showQuantityZeroPopup($productForm);
  },

  bindCartItem: function () {
    ACC.cartitem.init();
  },

  handleKeyEvent: function (elementRef, event) {
    var keyCode = event.keyCode || event.which;
    if (keyCode == 13 && !ACC.cartitem.submitTriggered) {
      ACC.cartitem.submitTriggered = ACC.cartitem.handleUpdateQuantity(elementRef, event);
      return false;
    } else {
      // Ignore all key events once submit was triggered
      if (ACC.cartitem.submitTriggered) {
        return false;
      }
    }

    return true;
  },

  handleUpdateQuantity: function (elementRef) {
    var form = $(elementRef).closest('form');

    var productCode = form.find('input[name=productCode]').val();
    var initialCartQuantity = form.find('input[name=initialQuantity]').val();
    var newCartQuantity = form.find('input[name=quantity]').val();

    if (initialCartQuantity != newCartQuantity) {
      ACC.track.trackUpdateCart(productCode, initialCartQuantity, newCartQuantity);
      form.submit();

      return true;
    }

    return false;
  }
};

export default cartitem;
