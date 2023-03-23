const vouchers = {
  endpoint: '/coupon/enable-coupon-account',
  $formSelector: $('.js-voucherFormAjax'),
  $formInputSelector: $('.js-voucherFormAjaxInput'),
  $voucherContent: $('.js-voucherContent'),
  errorClass: 'checkout-voucher__haserror',
  _autoload: [
    'init',
    ['initVoucherForm', $('.js-voucherFormAjax').length > 0],
    ['initVouchersDropdown', $('.js-vouchersDropdown').length > 0],
    'bindInfoModals'
  ],

  init: function () {
    ACC.vouchers.openVoucherPopup();
    ACC.vouchers.toggleTCVisibility();
  },

  bindInfoModals: function () {
    var isMyDetailsPage = ACC.vouchers.checkPageType('page-update-profile');
    var hideClass = 'hide';
    var $voucherInfoSection = $('.js-VoucherInfoSection');
    var $voucherSaveMoneyInfo = $('.js-voucherSaveMoneyInfo');

    $(document).on('click', '.js-voucherInfo', function () {
      $voucherSaveMoneyInfo.addClass(hideClass);
      $voucherInfoSection.removeClass(hideClass);
    });
    $(document).on('click', '.js-voucherClose', function () {
      $voucherInfoSection.addClass(hideClass);
    });

    $(document).on('click', '.js-saveMoneyInfOpen', function () {
      if (isMyDetailsPage) {
        ACC.vouchers.appendTermsAndCond(this);
      } else {
        $('.js-voucherSaveMoneyInfo .js-hasMoreTc').removeClass('hide');
      }
      $voucherInfoSection.addClass(hideClass);
      $voucherSaveMoneyInfo.removeClass(hideClass);
    });
    $(document).on('click', '.js-voucherSaveMoneyInfoClose', function () {
      $voucherSaveMoneyInfo.addClass(hideClass);
    });
  },

  openVoucherPopup: function () {
    if (window.voucherPopup) {
      $('#saveMoneyModal').modal('show');
    }
  },

  initVoucherForm: function () {
    ACC.vouchers.$formSelector.on('submit', function (e) {
      var voucherCode = ACC.vouchers.$formSelector.find('.js-voucherFormAjaxInput').val();
      var isUnique = ACC.vouchers.isUnique(voucherCode);
      e.preventDefault();
      ACC.vouchers.cleanUpValidationErrors();
      if (isUnique) {
        ACC.vouchers.getVoucherCode();
      } else {
        ACC.vouchers.displayError('EXISTS');
      }
    });
  },

  getVoucherCode: function () {
    $.ajax({
      url: ACC.vouchers.endpoint,
      method: 'POST',
      data: ACC.vouchers.$formSelector.serialize(),
      dataType: 'JSON',
      success: function (response) {
        ACC.vouchers.cleanUpValidationErrors();
        if (response.status === 'ACCEPTED') {
          ACC.vouchers.displaySuccess();
          ACC.vouchers.appendVoucherData(response);
        } else {
          ACC.vouchers.displayError(response.status);
        }
      },
      fail: function () {
        ACC.vouchers.displayError();
      },
      error: function () {
        ACC.vouchers.displayError();
      }
    });
  },

  appendVoucherData: function (data) {
    var voucherItemTemplate = ACC.global.compileHandlebarTemplate('#voucher-item-template');
    var voucherItemHtml = voucherItemTemplate(data);
    $('.js-vouchersList').prepend(voucherItemHtml);
  },

  displayError: function (errorType) {
    var errMsg = ACC.config.invalidVoucher;
    var msgTmpl = '';
    if (errorType === 'EXPIRED') {
      errMsg = ACC.config.expiredVoucher;
    }
    if (errorType === 'REDEEMED') {
      errMsg = ACC.config.redeemedVoucher;
    }
    if (errorType === 'EXISTS') {
      errMsg = ACC.config.voucherExists;
    }
    msgTmpl = "<div class='checkout-voucher__error js-voucherFormErrorMsg'>" + errMsg + '</div>';
    ACC.vouchers.$formSelector.append(msgTmpl);
  },

  displaySuccess: function () {
    var msgTmpl = "<div class='checkout-voucher__sucessText js-voucherFormSuccessMsg'>" + ACC.config.voucherApplySuccess + '</div>';
    ACC.vouchers.$formInputSelector.removeClass(ACC.vouchers.errorClass);
    ACC.vouchers.$formSelector.append(msgTmpl);
  },

  cleanUpValidationErrors: function () {
    ACC.vouchers.$formInputSelector.removeClass(ACC.vouchers.errorClass);
    $('.js-voucherFormErrorMsg').remove();
    $('.js-voucherFormSuccessMsg').remove();
  },

  initVouchersDropdown: function () {
    $('.js-toggleVouchersDropdown').on('click', ACC.vouchers.toggleVouchersDropdown);
    $('.js-vouchersDropdownItem').on('click', ACC.vouchers.setInputValue);
  },

  toggleVouchersDropdown: function () {
    var openClass = 'is-open';
    $('.js-vouchersDropdown').toggleClass(openClass);
    $('.js-toggleVouchersDropdown').toggleClass(openClass);
  },

  setInputValue: function () {
    var code = $(this).data('voucher-code');
    $('.js-voucherInput').val(code);
    ACC.vouchers.toggleVouchersDropdown();
  },

  toggleTCVisibility: function () {
    $('.js-voucherToggleTC').on('click', function () {
      ACC.vouchers.$voucherContent.toggleClass('is-expanded');
    });
  },
  checkPageType: function (classToCheck) {
    return $('body').hasClass(classToCheck);
  },

  appendTermsAndCond: function (el) {
    var tcClass = 'has-tc';
    var $voucherContent = ACC.vouchers.$voucherContent;
    var $parent = $(el).parents('.js-voucherItem');
    if ($parent.data('show-tc')) {
      $voucherContent.addClass(tcClass);
      $voucherContent.find('.js-voucherTC').html($parent.data('tc-text'));
      if ($parent.data('tc-moretext').length) {
        $voucherContent.find('.js-voucherTCMore').html($parent.data('tc-moretext'));
        $voucherContent.find('.js-voucherTCMoreWrap').removeClass('hide');
      }
    } else {
      $voucherContent.find('.js-voucherTC').html(ACC.config.voucherGeneralInfo);
      $voucherContent.removeClass(tcClass);
    }
  },

  isUnique: function (couponCode) {
    var listOfCodes = ACC.vouchers.getListOfCode();
    return listOfCodes.indexOf(couponCode) !== -1 ? false : true;
  },

  getListOfCode: function () {
    var list = [];
    $('.js-voucherItemCode').each(function (index, el) {
      list.push($(el).html());
    });
    return list;
  }
};

export default vouchers;
