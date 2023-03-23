const register = {
  _autoload: [
    'registerFunc',
    'saveAndExitHandler',
    'saveAndExitSubmit',
    'exitHandler',
    'bindMarketingConsent',
    'bindTermsCheckConsent',
    'bindPrivacyPolicyConsent',
    'preventCopyPaste',
    'bindBusinessAddress',
    'showBusinessAddressFields',
    ['initRegistrationForm', $('.js-registrationForm').length !== 0],
    ['setRegisterBtnTextOnLoad', $('.js-registerCheckbox').length !== 0],
    ['initMultiStepRegistrationForm', $('.js-multiStepRegistrationForm').length !== 0]
  ],
  sector: '',
  subsector: '',
  accountsCounter: 1,
  accountsMaxAllowed: 1,
  $registerButton: $('.js-registerButton'),
  $registerCheckbox: $('.js-registerCheckbox'),
  $registerButtonOnline: $('.js-registerButtonOnline'),

  setRegisterBtnTextOnLoad: function () {
    ACC.register.$registerCheckbox.each(function (index, elem) {
      ACC.register.displayRegisterButtonText($(elem));
    });
  },
  saveAndExitHandler: function () {
    $(document).on('click', '.js-saveAndExit', function () {
      var $saveAndExitModal = $('#saveAndExit');
      $saveAndExitModal.modal('show');
    });
  },
  preventCopyPaste: function () {
    $('.js-emailField').bind('cut copy paste', function (e) {
      e.preventDefault();
    });
  },
  bindMarketingConsent: function () {
    var val = $('.js-marketingConsentVal').val();
    if (val === 'true') {
      $('.js-marketingConsent').prop('checked', true);
      $('.js-marketingConsent').val(true);
    }
  },
  bindTermsCheckConsent: function () {
    var val = $('.js-termsCheckConsentVal').val();
    if (val === 'true') {
      $('.js-termsCheckConsent').prop('checked', true);
      $('.js-termsCheckConsent').val(true);
    }
  },
  bindPrivacyPolicyConsent: function () {
    var val = $('.js-privacyPolicyConsentVal').val();
    if (val === 'true') {
      $('.js-privacyPolicyConsent').prop('checked', true);
      $('.js-privacyPolicyConsent').val(true);
    }
  },
  bindBusinessAddress: function () {
    $('input:radio[name=businessAddressDifferent]').click(function () {
      var val = $(this).val();
      var $addressSection = $('.js-businessAdreessFieldSection');
      if (val === 'Yes') {
        $addressSection.removeClass('hide');
      } else {
        ACC.register.clearFormFields($addressSection);
        $addressSection.addClass('hide');
      }
    });
  },

  showBusinessAddressFields: function () {
    var $addressSection = $('.js-businessAdreessFieldSection');
    var businessAddressRadioVal = $('input:radio[name=businessAddressDifferent]:checked').val();

    if (businessAddressRadioVal == 'Yes') {
      $addressSection.removeClass('hide');
    }
  },
  saveAndExitSubmit: function () {
    $(document).on('click', '.js-SaveEXitSubmit', function () {
      var $form = $('#registerForm');
      var url = $form.find('.js-saveExitSubmitUrl').val();
      $form.attr('data-noValidation', true);
      var listOfErrorField = $form.find('.' + ACC.validation.HAS_ERROR);
      $(listOfErrorField).each(function () {
        $(this).find('.js-formField').val('');
      });
      $form.attr('action', url);

      $form.submit();
    });
  },
  exitHandler: function () {
    $(document).on('click', '.js-saveExitBtn', function () {
      var $saveAndExitModal = $('#saveAndExit');
      $saveAndExitModal.modal('hide');
      window.location.href = '/';
    });
  },
  bindLeadSourceChange: function () {
    $(document).on('change', '.js-leadSource', function (e, ignoreReset) {
      var $leadFreeText = $('.js-leadSourceFreeText');
      var $leadFreeTextLbl = $('.js-leadSourceFreeTextLbl');
      var $leadFreeTextArea = $('.js-leadSourceFreeTextArea');
      $leadFreeText.addClass('hide');
      if (!ignoreReset) {
        $leadFreeTextArea.val('');
      }

      $leadFreeTextArea.next('.js-errorMsg').addClass('hide');
      $leadFreeText.find('.js-formGroup').removeClass('has-error');
      var selectedVal = $(this).val();
      switch (selectedVal) {
        case 'I_HAVE_USED_BRAKES_IN_THE_PAST':
          $leadFreeText.removeClass('hide');
          $leadFreeTextLbl.text(ACC.config.registerBrakesInPast);
          break;
        case 'GOOGLE_OR_OTHER_SEARCH_ENGINE':
          $leadFreeText.removeClass('hide');
          $leadFreeTextLbl.text(ACC.config.registerGoogle);
          break;
        case 'OTHER':
          $leadFreeText.removeClass('hide');
          $leadFreeTextLbl.text(ACC.config.registerOther);
          break;
      }
    });
  },
  registerFunc: function () {
    ACC.register.$registerCheckbox.click(function () {
      ACC.register.displayRegisterButtonText($(this));
    });
  },

  displayRegisterButtonText: function ($elem) {
    if ($elem.is(':checked')) {
      if ($elem.val() === 'yes') {
        ACC.register.$registerButton.addClass('hide');
        ACC.register.$registerButtonOnline.removeClass('hide');
      } else {
        ACC.register.$registerButton.removeClass('hide');
        ACC.register.$registerButtonOnline.addClass('hide');
      }
    }
  },
  initMultiStepRegistrationForm: function () {
    ACC.global.initTooltips();
    this.bindNextSection();
    this.bindSectionClick();
    this.bindCompanyTypeChange();
    this.bindSelectChange();
    this.bindPostCodeEntry();
    this.bindRadioGroupChange();
    this.enterAddressManually();
    ACC.postcodeLookup.init();
    this.checkSectorValue();
    this.bindAddAnotherAccount();
    this.bindLeadSourceChange();
    this.currentSupplier('registrationCurrentSupplier');
    ACC.validation.bindMultiStepFormSubmit();
  },
  initRegistrationForm: function () {
    ACC.global.initTooltips();
    this.bindNextSection();
    this.bindSectionClick();
    this.bindCompanyTypeChange();
    this.bindSelectChange();
    this.bindPostCodeEntry();
    this.bindRadioGroupChange();
    this.enterAddressManually();
    ACC.postcodeLookup.init();
    this.checkSectorValue();
    this.bindAddAnotherAccount();
    this.bindLeadSourceChange();
  },
  bindSectionClick: function () {
    $(document).on('click', '.js-formHeader', function () {
      // Allow only sections that were already opened in the past
      var $this = $(this);
      var IS_ACTIVE = 'is-active';
      var $parentSection = $this.parents('.js-formSection');
      var $allSections = $('.js-formSection');
      var isPristine = $parentSection.hasClass('pristine');
      var isActive = $parentSection.hasClass(IS_ACTIVE);
      if (!isPristine) {
        if (isActive) {
          $allSections.removeClass(IS_ACTIVE);
        } else {
          $allSections.removeClass(IS_ACTIVE);
          $parentSection.addClass(IS_ACTIVE);
        }
      }
    });
  },
  bindNextSection: function () {
    var _this = this;
    $(document).on('click', '.js-formNextBtn', function () {
      var $this = $(this);
      var currentSection = $this.data('parent');
      var nextSection = $this.data('goto');
      _this.openNextSection(currentSection, nextSection);
    });
  },
  /**
   * @param {string} currentSection
   * @param {string} nextSection
   */
  openNextSection: function (currentSection, nextSection) {
    var IS_ACTIVE = 'is-active';
    var IS_COMPLETED = 'is-completed';

    var $currentSection = $(".js-formSection[data-section='" + currentSection + "']");
    var $nextSection = $(".js-formSection[data-section='" + nextSection + "']");

    try {
      $currentSection.removeClass(IS_ACTIVE).addClass(IS_COMPLETED);
      ACC.global.scrollToElement($nextSection, 1000);
      $nextSection.addClass(IS_ACTIVE).removeClass('pristine');
    } catch (e) {
      console.warn(e);
    }
  },
  bindCompanyTypeChange: function () {
    var _this = this;
    var companiesTypes = ['PVT_LTD_COMPANY', 'PUBLIC_LTD_COMPANY', 'LLP', 'Private Limited Company', 'Public Limited Company', 'LLP'];
    $(document).on('change', '.js-companyType', function () {
      var selectedType = $(this).val();
      var toggleInputs = false;

      companiesTypes.filter(function (company) {
        if (company.toLowerCase() === selectedType.toLowerCase()) {
          toggleInputs = true;
        }
      });
      _this.toggleCompanyInputs(toggleInputs);
    });
  },
  toggleCompanyInputs: function (enableInputs) {
    var $companyRegDetails = $('.js-companyRegDetails');
    var $companyRegDetailsLabels = $('.js-companyRegDetailsLabel');
    var $formGroup = $companyRegDetailsLabels.parents('.js-formGroup');
    var $errorMsg = $formGroup.find('.js-errorMsg');
    var IS_DISABLED = 'is-disabled';

    if (enableInputs) {
      $companyRegDetailsLabels.removeClass(IS_DISABLED);
      $companyRegDetails.attr('disabled', false);
    } else {
      $companyRegDetailsLabels.addClass(IS_DISABLED);
      $companyRegDetails.attr('disabled', true).val('');
      $formGroup.removeClass('has-error is-valid');
      $errorMsg.addClass('hide');
    }
  },
  bindRadioGroupChange: function () {
    $(document).on('change', '.js-radioButtonGroup', function () {
      var $this = $(this);
      var groupName = $this.attr('name');
      var thisValue = $this.val();
      var $form = $this.parents('form');

      var $inputField = $("input[data-name='" + groupName + "']");
      var $formGroup = $inputField.parents('.js-formGroup');
      var $label = $formGroup.find('.js-siteFormLabel');

      var $errorMsg = $formGroup.find('.js-errorMsg');

      var enableInput = false;

      if (thisValue.toLowerCase() == 'yes' && groupName != 'legalOwner') {
        enableInput = true;
      }
      if (thisValue.toLowerCase() == 'no' && groupName == 'legalOwner') {
        enableInput = true;
      }

      $formGroup.removeClass('has-error').removeClass('is-valid');
      $errorMsg.addClass('hide');

      if (enableInput) {
        $inputField.attr('disabled', false);
        $label.removeClass('is-disabled');
      } else {
        $inputField.attr('disabled', true);
        $label.addClass('is-disabled');
      }

      ACC.validation.validateForm($form);
    });
  },
  bindSelectChange: function () {
    var _this = this;
    $(document).on('change', '.js-sectorSelect', function () {
      var $this = $(this);
      var subSelect = $this.data('sub-select');
      var sectorName = $this.val().toUpperCase();
      var endpoint = $this.data('endpoint');
      _this.toggleSubSelect(subSelect, sectorName, endpoint);

      _this.sector = sectorName;
    });
  },
  toggleSubSelect: function (subSelect, sectorName, endpoint) {
    var _this = this;
    var IS_DISABLED = 'is-disabled';
    var $subSelectContainer = $('.js-subSector[data-select="' + subSelect + '"]');
    var $subSelectLabel = $subSelectContainer.find('.js-subSectorLabel');
    var $subSelect = $subSelectContainer.find('#subSector');
    var $errorMsg = $subSelectContainer.find('.js-errorMsg');
    var isSet = $subSelect.val() != '';

    if (sectorName != _this.sector) {
      isSet = false;
      _this.subsector = ' ';
    } else if (sectorName == 'OTHER') {
      _this.subsector = $subSelect.val();
    }

    $subSelectContainer.removeClass('has-error is-valid');
    $errorMsg.addClass('hide');
    if (sectorName == '' || sectorName == 'BRAKES_STAFF_ACCOUNT') {
      $subSelectLabel.addClass(IS_DISABLED);
      $subSelect.attr('disabled', true);
    } else if (sectorName == 'OTHER') {
      ACC.global.renderHandlebarsTemplate(
        {
          type: 'input',
          value: _this.subsector
        },
        'jsSubSector',
        'sub-sector-template'
      );
      if (_this.subsector != ' ') {
        $('#subSector').trigger('change');
      }
      $subSelectLabel.removeClass(IS_DISABLED);

      //if value is empty - show error
      var cleanEmptyVal = function () {
        var $val = $('#subSector').val().trim();
        if ($val.length === 0) {
          $('#subSector').val($val);
          $('#subSector').attr('value', $val);
        }
        return $val;
      };

      cleanEmptyVal();

      $('#subSector').on('blur', function () {
        if (cleanEmptyVal().length === 0) {
          $(this).trigger('change');
        }
      });
    } else {
      // Prevent Ajax call on form submit as it would reset sub sector dropdown
      if (isSet) {
        return;
      }
      $.ajax({
        url: endpoint,
        method: 'GET',
        data: {
          sector: sectorName
        },
        dataType: 'JSON',
        success: function (response) {
          var listType = 'list';
          if (!response.length) {
            listType = 'disabled';
          }
          ACC.global.renderHandlebarsTemplate(
            {
              data: response,
              type: listType,
              value: _this.subsector
            },
            'jsSubSector',
            'sub-sector-template'
          );
          // On AJAX response we should re validate field in order to display error message
          if (_this.subsector != ' ') {
            $('#subSector').trigger('change');
          }
          _this.revalidateField('#subSector');
        },
        fail: function () {
          console.log('Failed retriving sub sectors');
        }
      });
    }
  },
  revalidateField: function (fieldSelector) {
    var $field = $(fieldSelector);
    if ($field.parents('.js-formGroup').hasClass('has-error')) {
      $field.trigger('change');
    }
  },
  bindPostCodeEntry: function () {
    $('.js-postcodeInput').on('change', function () {
      if ($(this).attr('data-validation-type') === 'any') {
        $(this).attr('data-validation-type', 'postcode');
      }
    });
  },
  currentSupplier: function (id) {
    var currentSupplier = document.getElementById(id);
    if (currentSupplier) {
      var supplierTextArea = currentSupplier.nextElementSibling;
      this.hideShowTextArea(currentSupplier, supplierTextArea);
      currentSupplier.querySelector('select').addEventListener('change', function () {
        ACC.register.hideShowTextArea(currentSupplier, supplierTextArea);
      });
      supplierTextArea &&
        supplierTextArea.querySelector('textarea').addEventListener('blur', function (e) {
          var target = e.target;
          !target.value.length && target.parentElement.classList.add('has-error');
        });
    }
  },
  hideShowTextArea: function (target, textArea) {
    var selectDropdown = target.querySelector('select');
    var selectedValue = selectDropdown.options[selectDropdown.selectedIndex].value;
    var textAreaClassList = textArea.classList;
    if (selectedValue && selectedValue.toLowerCase().includes('other')) {
      textAreaClassList.remove('hide');
    } else {
      textAreaClassList.add('hide');
      textArea.querySelector('.js-formGroup').classList.remove('has-error');
      ACC.validation.validateAllRequired(textArea.id);
    }
  },
  enterAddressManually: function () {
    var _this = this;
    $(document).on('click', '.js-enterAddressManually', function () {
      var $this = $(this);
      var $form = $this.parents('form');

      var $formSection = $(this).parents('.js-formGroup');
      var $postCodeInput = $formSection.find('.js-postcodeInput');

      //var $postCodeInput = $(".js-postcodeInput");

      var $addressSelect;
      var $addressFields;
      if ($(this).attr('data-selectAddress')) {
        $addressSelect = $('#jsBusinessSelectAddress').find('.js-addressSelect');
        $addressFields = $form.find('.js-businessAddressFields');
      } else {
        $addressSelect = $('#jsSelectAddress').find('.js-addressSelect');
        $addressFields = $form.find('.js-addressFields');
      }
      var $addressSelectParents = $addressSelect.parents('.js-formGroup');
      // var $addressFields = $form.find(".js-addressFields");
      // Reset Dropdown to first option
      $addressSelectParents.removeClass('has-error');
      $addressSelectParents.find('.js-errorMsg').addClass('hide');
      $addressSelect.removeClass('is-required').val($('.js-addressSelect option:first').val());
      $postCodeInput.attr('data-validation-type', 'any');
      $addressFields.removeClass('hide');
      _this.clearFormFields($addressFields);
    });
  },

  /**
   * @param {$fieldsContainer} - jQuery object - required
   */
  clearFormFields: function ($fieldsContainer) {
    var $inputFields = $fieldsContainer.find('.js-formField');

    $inputFields.each(function () {
      var $this = $(this);
      var $formGroup = $this.parents('.js-formGroup');
      // Remove values
      $this.val('');

      // Remove validation errors
      $formGroup.removeClass('is-valid has-error');
      // Hide error messages
      $formGroup.find('.js-errorMsg').addClass('hide');
    });
  },

  checkSectorValue: function () {
    var _this = this;
    _this.sector = $('#jsRegistrationSector').val();
    _this.subsector = $('#jsRegistrationSubSector').val();

    // On page load check if sector is not empty
    if (_this.sector != '') {
      // If it's not empty trigger change to make Ajax call.
      // See bindSelectChange method
      $('.js-sectorSelect').trigger('change');
    }
  },

  bindAddAnotherAccount: function () {
    var _this = this;
    var newAccountField = '';
    _this.accountsMaxAllowed = $('#jsMaxAccountsAllowed').val();
    $('.js-addAnotherAccount').on('click', function () {
      var $this = $(this);
      newAccountField = ACC.global.renderHandlebarsTemplate(
        {
          counter: _this.accountsCounter
        },
        'noTargetEl',
        'another-account-template'
      );
      $('#jsAccountsList').append(newAccountField);
      _this.accountsCounter += 1;

      if (_this.accountsCounter >= _this.accountsMaxAllowed) {
        $this.attr('disabled', true);
      }
    });
  },
  /**
   * @param {accountNumbers}
   * @param {accountNumberSelector}
   */
  collectAccountsList: function (accountNumbersInput, accountNumberSelector) {
    var $accountNumbers = $(accountNumbersInput);
    var $allAccountNumbers = $(accountNumberSelector);
    var accountNumbersList = [];

    $allAccountNumbers.each(function () {
      var accountNumberVal = $(this).val();

      accountNumbersList.push(accountNumberVal);
    });

    $accountNumbers.val(accountNumbersList.join());
  }
};

export default register;
