const b2bPaymentDropDown = {
  _autoload: ['bindDropDownSelection'],
  $dropDownActiveSection: $('.js-paymentDropDownActiveSection'),
  $dropDownActive: $('.js-paymentDropDownActive'),
  $dropDownList: $('.js-paymentDropDownList'),

  bindDropDownSelection: function () {
    $(document).on('click', '.js-paymentDropDownList li', function () {
      var defaultSelect = $(this).attr('data-select');
      if (defaultSelect != 'default') {
        var selectedVal = $(this).attr('data-name');
        var $accountId = $(this).attr('data-id');
        ACC.b2bPaymentDropDown.getCardDetails($accountId);
        ACC.b2bPaymentDropDown.$dropDownActive.next('.js-paymentCode').text($accountId);
        ACC.b2bPaymentDropDown.$dropDownActive.text(selectedVal);

        ACC.b2bPaymentDropDown.$dropDownActive.attr('data-id', $accountId);
        ACC.b2bPaymentDropDown.$dropDownList.toggleClass('hide');
        ACC.b2bPaymentDropDown.$dropDownActiveSection.removeClass('is-active');
      }
    });
    $(document).on('click', '.js-paymentDropDownActiveSection', function () {
      ACC.b2bPaymentDropDown.$dropDownList.toggleClass('hide');
      $(this).toggleClass('is-active');
    });
  },
  getCardDetails: function ($accountId) {
    $.ajax({
      type: 'GET',
      url: '/payment/get-payment-info',
      data: {
        accountId: $accountId
      },

      success: function (data) {
        var paymentAccountSection = $('.js-paymentAccountSection');
        ACC.b2bPaymentDropDown.accountTemplate = ACC.global.compileHandlebarTemplate('#payment-account-template');
        var accountSection = ACC.b2bPaymentDropDown.accountTemplate(data);
        paymentAccountSection.empty();
        paymentAccountSection.append(accountSection);
      },
      error: function () {
        console.error('Error retriving products list');
      }
    });
  }
};

export default b2bPaymentDropDown;
