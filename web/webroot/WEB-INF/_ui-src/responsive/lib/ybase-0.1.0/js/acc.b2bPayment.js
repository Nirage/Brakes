const b2bPayment = {
  _autoload: [
    ['bindReplaceAllCards', $('.js-replaceAllCards').length != 0],
    'bindCloseReplacePopUpBox',
    'bindPaymentCardDelete',
    'bindCloseDeletePopUpBox',
    'bindAddCardPaymentBtn',
    'bindReplaceAllCardSubmit',
    'showPaymentErrorModal',
    'handleBannerSubmit'
  ],
  $replaceAllCardSection: $('.js-replaceAllCardSection'),
  $deletePaymentCardSection: $('.js-deletePaymentCardSection'),

  handleBannerSubmit: function () {
    if (ACC.config.mydetails) {
      var currentUrl = window.location.href;
      if (currentUrl.indexOf('scrollTo') != -1) {
        ACC.global.scrollToElement('.js-paymentForm', null, 200);
      }
    }

    $(document).on('click', '.js-bannerSumbmitBtn', function (e) {
      if ($('.js-bannerSumbmitBtn').attr('data-action') === 'ADDED') {
        e.preventDefault();
        $(this).parents('.js-paymentBanner').addClass('hide');
      }
      var $btnAction = $(e.currentTarget).attr('data-btnAction');
      ACC.b2bPayment.gaDataTrack($btnAction);
    });
  },

  bindReplaceAllCards: function () {
    $(document).on('click', '.js-replaceAllCards', function () {
      ACC.b2bPayment.$replaceAllCardSection.removeClass('hide');
      ACC.b2bPayment.bindClickOutside(ACC.b2bPayment.$replaceAllCardSection);
    });
  },
  bindReplaceAllCardSubmit: function () {
    $(document).on('click', '.js-paymentSubmit', function (e) {
      e.preventDefault();
      ACC.b2bPayment.$replaceAllCardSection.addClass('hide');
      ACC.b2bPayment.addCardShowModal(true);
    });
  },

  bindCloseReplacePopUpBox: function () {
    $(document).on('click', '.js-removeAllCard__close', function () {
      ACC.b2bPayment.$replaceAllCardSection.addClass('hide');
    });
  },
  bindPaymentCardDelete: function () {
    $(document).on('click', '.js-paymentDeleteBtn', function () {
      var $btnAction = 'Delete payment card';
      ACC.gtmDataLayer.trackAddPaymentCard($btnAction);
      ACC.b2bPayment.$deletePaymentCardSection.removeClass('hide');
      ACC.b2bPayment.bindClickOutside(ACC.b2bPayment.$deletePaymentCardSection);
    });
  },
  bindCloseDeletePopUpBox: function () {
    $(document).on('click', '.js-deletePaymentCard__close', function () {
      ACC.b2bPayment.$deletePaymentCardSection.addClass('hide');
    });
  },

  bindClickOutside: function (container) {
    $(document).mouseup(function (e) {
      if (!container.is(e.target) && container.has(e.target).length === 0) {
        container.addClass('hide');
      }
    });
  },

  bindAddCardPaymentBtn: function () {
    $(document).on('click', '.js-addPaymentCardBtn', function () {
      var $btnAction = $(this).attr('data-action');
      ACC.b2bPayment.gaDataTrack($btnAction);
      ACC.b2bPayment.addCardShowModal(false);
    });
  },

  showPaymentErrorModal: function () {
    if ($('.js-showPaymetErrorPopup').val() === 'true') {
      $('#paymentErrorModal').modal('show');
    }
  },

  addCardShowModal: function ($addAllAccount) {
    var $paymentForm = $('.js-paymentForm');
    $paymentForm.find('.js-addToAllAccount').val($addAllAccount);
    var $selectedAccount = $paymentForm.find('.js-paymentDropDownActive').attr('data-id');
    $.ajax({
      type: 'POST',
      url: '/payment/add-card-iframe',
      data: {
        selectedAccount: $selectedAccount,
        addToAllAccount: $addAllAccount
      },

      success: function (data) {
        var $addPaymentCardModal = $('#addPaymentCardModal');
        $addPaymentCardModal.modal('show');
        $('#paymentIframe').attr('src', data);
      },
      error: function () {
        console.error('Error retriving products list');
      }
    });
  },
  gaDataTrack: function ($btnAction) {
    ACC.gtmDataLayer.trackAddPaymentCard($btnAction);
  }
};

export default b2bPayment;
