const nectar = {
  _autoload: ['bindAddAnotherSection', 'bindAccountNumberChange', 'removeAccountSection', 'ownerDetailsUpdate', 'onSubmission'],
  SECTION_COUNT: 0,
  ACCOUNT_NUMBERS: [],

  bindAddAnotherSection: function () {
    if (!ACC.postcodeLookup.isEnabled) {
      ACC.postcodeLookup.init();
    }
    ACC.register.enterAddressManually();

    $(document).on('click', '.js-add-another-button', function () {
      var $jsAccountSectionParent = $('.js-accountSectionParent');
      var $jsAddAnothersection = $('.js-add-anothersection');

      if (ACC.nectar.SECTION_COUNT < 23) {
        $jsAddAnothersection.clone().appendTo($jsAccountSectionParent).removeClass('hide js-add-anothersection');
        var $jsAccountSection = $('.js-account-section');

        var $appendedEntry = $jsAccountSection.eq($jsAccountSection.length - 1);
        var $accountType = $appendedEntry.find('.js-account-type');
        var $accountNo = $appendedEntry.find('.js-nectar-account-no');

        var $accountTypeLabel = $appendedEntry.find('.js-accountType-custom');
        $appendedEntry.find('.js-accountType-custom');

        var accountTypeId = $accountType.attr('id');
        $accountTypeLabel.attr('for', accountTypeId + ACC.nectar.SECTION_COUNT);

        var accountNoId = $accountNo.attr('id');
        $accountNo.attr('id', accountNoId + ACC.nectar.SECTION_COUNT);

        $accountType.addClass('is-required');
        $accountType.removeClass('is-optional');

        $accountType.attr('id', accountTypeId + ACC.nectar.SECTION_COUNT);
        ACC.nectar.SECTION_COUNT++;
      } else {
        $('.js-exceed-accountinfo').removeClass('hide');
      }
    });
  },
  bindAccountNumberChange: function () {
    $(document).on('blur', '.js-nectar-account-no', function () {
      ACC.nectar.verifyAccountNumber($(this));
    });
  },
  verifyAccountNumber: function (el) {
    var accountNumberVal = el.val();
    var accountNumberId = el.attr('id');
    if (ACC.nectar.ACCOUNT_NUMBERS.length === 0) {
      ACC.nectar.validateAccountNumber(el);
    } else {
      $.each(ACC.nectar.ACCOUNT_NUMBERS, function (i) {
        if (ACC.nectar.ACCOUNT_NUMBERS[i].key == accountNumberId && ACC.nectar.ACCOUNT_NUMBERS[i].val == accountNumberVal) {
          //do nothing
        } else if (ACC.nectar.ACCOUNT_NUMBERS[i].key == accountNumberId && ACC.nectar.ACCOUNT_NUMBERS[i].val != accountNumberVal) {
          ACC.nectar.ACCOUNT_NUMBERS.splice(i, 1);
          ACC.nectar.validateAccountNumber(el);
        } else if (ACC.nectar.ACCOUNT_NUMBERS[i].val == accountNumberVal) {
          ACC.nectar.bindErrorMessage(el);
        } else if (ACC.nectar.ACCOUNT_NUMBERS[i].val != accountNumberVal) {
          ACC.nectar.validateAccountNumber(el);
        }
      });
    }
  },
  bindErrorMessage: function (el) {
    var $inputGroup = el.parents('.js-inputgroup');
    var $errorMsg = $inputGroup.find('.js-errorMsg-custom');
    var $errorIcon = $inputGroup.find('.js-error-icon-custom');
    var $validIcon = $inputGroup.find('.js-valid-icon-custom');
    $inputGroup.addClass('has-error');
    $errorMsg.removeClass('hide');
    $errorIcon.css('display', 'block');
    $errorIcon.removeClass('hide');
    $validIcon.css('display', 'none');
    $validIcon.addClass('hide');
  },

  validateAccountNumber: function (el) {
    var accountNumberVal = el.val().trim();
    el.val(accountNumberVal);
    var $inputGroup = el.parents('.js-inputgroup');
    var $errorMsg = $inputGroup.find('.js-errorMsg-custom');
    var $errorIcon = $inputGroup.find('.js-error-icon-custom');
    var $validIcon = $inputGroup.find('.js-valid-icon-custom');

    $.ajax({
      type: 'GET',
      url: '/nectar-points/validate-account',
      dataType: 'json',
      data: { accountNumber: accountNumberVal },
      success: function (response) {
        if (response == true) {
          $inputGroup.removeClass('has-error');
          $errorMsg.addClass('hide');
          $errorIcon.css('display', 'none');
          $errorIcon.addClass('hide');
          $validIcon.css('display', 'block');
          $validIcon.removeClass('hide');
          ACC.nectar.ACCOUNT_NUMBERS.push({ key: el.attr('id'), val: accountNumberVal });
        } else {
          $inputGroup.addClass('has-error');
          $errorMsg.removeClass('hide');
          $errorIcon.css('display', 'block');
          $errorIcon.removeClass('hide');
          $validIcon.css('display', 'none');
          $validIcon.addClass('hide');
        }
      },
      error: function () {
        console.log('Error retriving B2B Units list');
      }
    });
  },
  removeAccountSection: function () {
    $(document).on('click', '.js-account-section-remove', function () {
      if (ACC.nectar.SECTION_COUNT > 0) {
        $(this).parents('.js-account-section').remove();
        ACC.validation.validateForm($('#collectNectarForm'));

        ACC.nectar.SECTION_COUNT--;
        var i = $(this).attr('id');
        ACC.nectar.ACCOUNT_NUMBERS.splice(i, 1);
      }
    });
  },
  ownerDetailsUpdate: function () {
    $(document).on('change', '.js-radioButtonGroup', function () {
      var selectedId = $('input[name=relationType]:checked').attr('id');
      $('.js-legal-owner-error').addClass('hide');
      var $ownerInfo = $('.js-owner-info');
      var $owner = $('.js-owner');
      var $title = $('.js-title');
      var $firstName = $('.js-firstName');
      var $lastName = $('.js-lastName');
      var $disabledElementList = [];

      if (selectedId == 'An employee') {
        $disabledElementList = [
          'register.title',
          'register.firstName',
          'register.lastName',
          'register.title',
          'register.firstName',
          'register.lastName'
        ];

        $('.js-legal-owner-disclaimer').addClass('hide');
        $ownerInfo.removeClass('disabled');
        $owner.addClass('is-required');
        $title.addClass('is-required');
        $firstName.addClass('is-required');
        $lastName.addClass('is-required');
        $disabledElementList.map(function (singleEle) {
          ACC.validation.toggleError(singleEle, null, true);
        });
      } else {
        $disabledElementList = ['collectNectar.owners.title', 'collectNectar.owners.firstName', 'collectNectar.owners.lastName'];

        $('.js-legal-owner-disclaimer').removeClass('hide');
        $owner.removeClass('is-required');
        $title.addClass('is-required');
        $firstName.addClass('is-required');
        $lastName.addClass('is-required');
        $owner.removeAttr('disabled');
        $ownerInfo.addClass('disabled');
        $disabledElementList.map(function (singleEle) {
          ACC.validation.toggleError(singleEle, null, true);
        });
      }
    });
  },
  onSubmission: function () {
    $(document).on('click', '.js-nectar-points-submit', function () {
      var accountNumberField = $('.js-nectar-account-no');
      $.each(accountNumberField, function () {
        if ($(this).val() == '') {
          if ($(this).parents('.js-add-anothersection').hasClass('hide')) {
            //do nothing
          } else {
            var $inputGroup = $(this).parents('.js-inputgroup');
            var $errorMsg = $inputGroup.find('.js-errorMsg-custom');
            var $errorIcon = $inputGroup.find('.js-error-icon-custom');
            var $validIcon = $inputGroup.find('.js-valid-icon-custom');
            $errorMsg.removeClass('hide');
            $errorIcon.css('display', 'block');
            $errorIcon.removeClass('hide');
            $validIcon.css('display', 'none');
            $validIcon.addClass('hide');
          }
        } else {
          if ($(this).parents('.js-inputgroup').find('.js-valid-icon-custom').hasClass('hide')) {
            ACC.nectar.verifyAccountNumber($(this));
          }
        }
      });
      ACC.nectar.validateForm();
    });
  },
  validateForm: function () {
    var radios = document.getElementsByName('relationType');
    var formValid = false;

    var i = 0;
    while (!formValid && i < radios.length) {
      if (radios[i].checked) formValid = true;
      i++;
    }

    if (!formValid) $('.js-legal-owner-error').removeClass('hide');
  }
};

export default nectar;
