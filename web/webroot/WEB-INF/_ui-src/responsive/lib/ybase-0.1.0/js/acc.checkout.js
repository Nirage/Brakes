const checkout = {
  _autoload: [
    'bindCheckO',
    'bindForms',
    'bindSavedPayments',
    'initiatePayment',
    ['bindDeliveryCalender', ACC.config.checkoutPage],
    ['loadMoreOrderItems', $('.js-loadMoreOrderItems').length != 0],
    ['bindContinueCheckout', $('.js-continue-checkout-button').length != 0 && ACC.config.checkoutPage]
  ],

  bindForms: function () {
    $(document).on('click keypress', '#addressSubmit', function (e) {
      e.preventDefault();
      if (ACC.global.keyPressCheck(e)) {
        ACC.global.checkLoginStatus(ACC.global.doSubmitForm, $('#addressForm'));
      }
    });

    $(document).on('click keypress', '#deliveryMethodSubmit', function (e) {
      e.preventDefault();
      if (ACC.global.keyPressCheck(e)) {
        ACC.global.checkLoginStatus(ACC.global.doSubmitForm, $('#selectDeliveryMethodForm'));
      }
    });
  },

  bindDeliveryCalender: function () {
    if (typeof window.deliveryCalendarConfig != 'undefined') {
      var deliveryDate = $('.jsDeliveryDate').val();
      if (window.deliveryCalendarConfig.bankHolidays.indexOf(deliveryDate) !== -1) {
        var $dateConfirmationModal = $('#checkoutDeliveryDateConfirmationModal');
        ACC.product.showModal($dateConfirmationModal);
        ACC.checkout.showDeliveryCalender();
      }
    }
  },

  showDeliveryCalender: function () {
    $('.jsDeliveryDateConfirmation').on('click', function () {
      var dropDownId = $(this).data('id');
      ACC.accountdropdown.toggleAccountDropdown(dropDownId);
      ACC.accountdropdown.calcAccountDropdownHeight();
    });
  },

  $loadMoreBtn: $('.js-loadMoreOrderItems'),

  loadMoreOrderItems: function () {
    ACC.checkout.$loadMoreBtn.on('click keypress', function (e) {
      if (ACC.global.keyPressCheck(e)) {
        ACC.checkout.loadMore();
      }
    });
  },

  loadMore: function () {
    var nextBlockId = ACC.checkout.$loadMoreBtn.data('id-next');
    var maxBlocks = ACC.checkout.$loadMoreBtn.data('max');

    if (nextBlockId === maxBlocks) {
      ACC.checkout.$loadMoreBtn.remove();
      $('#id-' + nextBlockId).removeClass('hide');
    } else {
      ACC.checkout.$loadMoreBtn.data('id-next', nextBlockId + 1);
      $('#id-' + nextBlockId).removeClass('hide');
    }
  },

  bindSavedPayments: function () {
    $(document).on('click', '.js-saved-payments', function (e) {
      e.preventDefault();

      var title = $('#savedpaymentstitle').html();

      $.colorbox({
        href: '#savedpaymentsbody',
        inline: true,
        maxWidth: '100%',
        opacity: 0.7,
        //width:"320px",
        title: title,
        close: '<span class="glyphicon glyphicon-remove"></span>',
        onComplete: function () {}
      });
    });
  },

  bindCheckO: function () {
    // Alternative checkout flows options
    $('.doFlowSelectedChange').change(function () {
      if ('multistep-pci' == $('#selectAltCheckoutFlow').val()) {
        $('#selectPciOption').show();
      } else {
        $('#selectPciOption').hide();
      }
    });

    $(document).on('click keypress', '.js-continue-shopping-button', function (e) {
      e.preventDefault();
      var checkoutUrl = $(this).data('continue-shopping-url');
      if (ACC.global.keyPressCheck(e)) {
        ACC.global.checkLoginStatus(function () {
          window.location = encodeURI(checkoutUrl);
        });
      }
    });

    $(document).on('click', '.js-create-quote-button', function () {
      $(this).prop('disabled', true);
      var createQuoteUrl = $(this).data('createQuoteUrl');
      window.location = createQuoteUrl;
    });

    $(document).on('click', '.expressCheckoutButton', function () {
      document.getElementById('expressCheckoutCheckbox').checked = true;
    });

    $(document).on('input', '.confirmGuestEmail,.guestEmail', function () {
      var orginalEmail = $('.guestEmail').val();
      var confirmationEmail = $('.confirmGuestEmail').val();

      if (orginalEmail === confirmationEmail) {
        $('.guestCheckoutBtn').removeAttr('disabled');
      } else {
        $('.guestCheckoutBtn').attr('disabled', 'disabled');
      }
    });
  },

  bindCheckoutButton: function () {
    $(document).on('click keypress', '.js-continue-checkout-button', function (e) {
      if (ACC.global.keyPressCheck(e)) {
        ACC.global.checkLoginStatus(ACC.checkout.handleCheckoutButtonClick, e);
      }
    });
  },

  handleCheckoutButtonClick: function (e) {
    var cartEntriesError = false;
    var checkoutUrl = $(e.target).data('checkoutUrl');
    cartEntriesError = ACC.pickupinstore.validatePickupinStoreCartEntires();

    if (!cartEntriesError) {
      var expressCheckoutObject = $('.express-checkout-checkbox');
      if (expressCheckoutObject.is(':checked')) {
        window.location = expressCheckoutObject.data('expressCheckoutUrl');
      } else {
        var flow = $('#selectAltCheckoutFlow').val();
        if (flow == undefined || flow == '' || flow == 'select-checkout') {
          // No alternate flow specified, fallback to default behaviour
          window.location = checkoutUrl;
        } else {
          // Fix multistep-pci flow
          if ('multistep-pci' == flow) {
            flow = 'multistep';
          }
          var pci = $('#selectPciOption').val();

          // Build up the redirect URL
          var redirectUrl = checkoutUrl + '/select-flow?flow=' + flow + '&pci=' + pci;
          window.location = redirectUrl;
        }
      }
    }
    return false;
  },

  initiatePayment: function () {
    $(document).on('click', '#payButton1', function (e) {
      e.preventDefault();
      var iframe = $('#paymentIframe');
      $.ajax({
        url: '/checkout/payment',
        cache: false,
        type: 'GET',
        success: function (response) {
          iframe.attr('src', response);
          iframe.show();
        },
        error: function () {
          //
        }
      });
    });
  }
};

export default checkout;
