const validation = {
  _autoload: [['initValidation', $('.js-formField').length != 0]],
  formsToValidate: '.js-formValidation',
  IS_REQUIRED: 'is-required',
  HAS_ERROR: 'has-error',
  IS_VALID: 'is-valid',
  IS_OPTIONAL: 'is-optional',
  HIDE: 'hide',
  ERROR_INVALID: 'data-error-invalid',
  ERROR_MAXLENGTH: 'data-error-maxlength',
  LOADING_CLASS: 'is-loading',
  ERROR_EMPTY: 'data-error-empty',
  formField: '.js-formField',
  formPasswordField: '.js-formFieldPassword',
  formEmailField: '.js-formFieldEmail',
  formConfirmEmailField: '.js-formFieldConfirmEmail',
  isConfirmEmail: 'is-valid',
  formTextareaField: '.js-formTextarea',
  submitButton: '.js-submitBtn',
  $submitButtonMultiStep: $('.js-submitRegistrationForm'),
  nextButton: '.js-formNextBtn',
  loadingClass: 'js-showLoading',
  dwellChatEnabled: true,
  regex: {
    printablecharacters: '^(?!\\s*$)[a-zA-Z0-9!@#$%^&*(),.":;\\[\\]\\|/£=+-_~{}\\s]+$',
    all: '.',
    alphanumeric: '^[A-Za-z0-9 ]*$',
    numeric: '^[0-9 ]*$',
    address: "^[a-zA-Z0-9 ,.'!-]*$",
    phone: '^[0-9+ ]*$',
    landline: '^0[1238][0-9 ]*$',
    mobilephone: '^(07){1}[0-9]{9}$',
    company: '^(SC|SO|SL|OC|LP)?[0-9]+$',
    password: '^(?=.*[A-Za-z])(?=.*[0-9])',
    email: '(^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$)',
    postcode:
      '^([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z]))))\\s?[0-9][A-Za-z]{2})$',
    shortpostcode:
      '^([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z])))))$',
    postcodepostfix: '^([0-9][A-Za-z]{2})$',
    // Customer Tools
    price: '^£?\\d{0,9}(.\\d{1,2})?$',
    margin: '^[0-9 ]*%?$',
    date: '^(([0-2]\\d|[3][0-1])\\/([0]\\d|[1][0-2])\\/[2][0]\\d{2})$|^(([0-2]\\d|[3][0-1])\\/([0]\\d|[1][0-2])\\/[2][0]\\d{2}\\s([0-1]\\d|[2][0-3]))$',
    allDate: '^[0-3][0-9]/[0-3][0-9]/(?:[0-9][0-9])?[0-9][0-9]$',
    numericWithoutSpace: '^[0-9]*$'
  },
  rules: {
    name: {
      min: 2,
      max: 23,
      regexType: 'all'
    },
    printablecharacters: {
      min: 0,
      max: 170,
      regexType: 'printablecharacters'
    },
    phone: {
      min: 11,
      max: 14,
      regexType: 'phone'
    },
    landline: {
      min: 10,
      max: 11,
      regexType: 'landline'
    },
    mobilephone: {
      min: 11,
      max: 11,
      regexType: 'mobilephone'
    },
    postcode: {
      min: 3,
      max: 10,
      regexType: 'postcode'
    },
    address: {
      min: 2,
      max: 50,
      regexType: 'address'
    },
    flatnumber: {
      min: 1,
      max: 35,
      regexType: 'address'
    },
    housename: {
      min: 2,
      max: 35,
      regexType: 'address'
    },
    housenumber: {
      min: 1,
      max: 10,
      regexType: 'address'
    },
    nectarcardnumber: {
      min: 11,
      max: 11,
      regexType: 'numericWithoutSpace'
    },
    city: {
      min: 2,
      max: 25,
      regexType: 'address'
    },
    email: {
      min: 3,
      max: 80,
      regexType: 'email'
    },
    confirmEmail: {
      min: 3,
      max: 80,
      regexType: 'email'
    },
    password: {
      min: 8,
      max: 12,
      regexType: 'password'
    },
    textarea: {
      min: 0,
      regexType: 'all'
    },
    any: {
      min: 0,
      regexType: 'all'
    },
    note: {
      min: 0,
      max: 80,
      regexType: 'all'
    },
    accountnumber: {
      min: 1,
      max: 10,
      regexType: 'numeric'
    },
    companyregnumber: {
      min: 8,
      max: 8,
      regexType: 'company'
    },
    // Customer Tools
    unitPrice: {
      min: 0,
      regexType: 'price'
    },
    marginRequired: {
      min: 0,
      regexType: 'margin'
    },
    numeric: {
      min: 1,
      max: 5,
      regexType: 'numeric'
    },
    date: {
      min: 2,
      regexType: 'date'
    },
    allDate: {
      min: 2,
      regexType: 'allDate'
    },
    quickaddinput: {
      min: 1,
      max: 10,
      regexType: 'numeric'
    }
  },
  displayErrorMessage: function (errorMessage, formGroup, errorContainer) {
    formGroup.classList.remove(this.IS_VALID);
    formGroup.classList.add(this.HAS_ERROR);
    if (errorContainer) {
      errorContainer.innerHTML = errorMessage;
      errorContainer.classList.remove(this.HIDE);
    }
  },
  displaySuccessMessage: function (formGroup, errorContainer, isDisabled) {
    formGroup.classList.remove(this.HAS_ERROR);
    if (!isDisabled) formGroup.classList.add(this.IS_VALID);
    if (errorContainer) {
      errorContainer.innerHTML = '';
      errorContainer.classList.add(this.HIDE);
    }
  },
  /**
   * Check if required field is not empty.
   * Display error message based on errorType
   * If errorType was not privided hide error messages for this particular field
   * @param  {string} id
   * @param  {string} errorType
   * @param  {boolean} isDisabled
   * @return {void}
   */
  toggleError: function (id, errorType, isDisabled) {
    var label = document.querySelector('label[for="' + id + '"]');

    if (label) {
      var formGroup = label.closest('.js-formGroup');
      var errorContainer = formGroup.querySelector('.js-errorMsg');

      if (errorType) {
        var errorMessage = label.getAttribute(errorType);
        this.displayErrorMessage(errorMessage, formGroup, errorContainer);
      } else {
        this.displaySuccessMessage(formGroup, errorContainer, isDisabled);
      }
    }
  },
  /**
   * Check if filed is valid based on type and set of rules ACC.validation.rules
   * @param  {string} id    required
   * @param  {string} value required
   * @param  {string} type  required
   * @return {void}
   */
  validateField: function (id, value, type, isDisabled) {
    if (!type) {
      return;
    }

    var rules = this.rules || {};
    var fieldRules = rules[type];
    var maxlength;
    var regextType = fieldRules.regexType;
    var regex = unescape(this.regex[regextType]);
    var isLengthValid = this.checkLength(value, fieldRules);
    var valueLength = value.length;
    var isRegexValid;

    if (type === 'textarea') {
      maxlength = $("[id='" + id + "']").data('maxlength');
      fieldRules.max = parseInt(maxlength);
    }
    if (type === 'allDate') value = value.split('-').reverse().join('/');
    var modifier = type === 'address' ? 'g' : '';

    isRegexValid = this.checkRegex(value, regex, modifier);

    if (type === 'confirmEmail') {
      if (isRegexValid) isRegexValid = this.isConfirmEmail === 'is-valid';
    }
    if (!valueLength) {
      this.toggleError(id, this.ERROR_EMPTY, isDisabled);
    } else if (!isRegexValid) {
      this.toggleError(id, this.ERROR_INVALID, isDisabled);
    } else if (!isLengthValid) {
      var printableCharacters = type === 'printablecharacters' ? this.ERROR_MAXLENGTH : this.ERROR_INVALID;
      this.toggleError(id, printableCharacters, isDisabled);
    } else if (type === 'nectarcardnumber' && valueLength && isLengthValid) {
      this.nectarCardExist(value, id);
    } else {
      this.toggleError(id, null, isDisabled);
    }
  },
  enableLookupBtn: function (id) {
    var $thisInput = $("input[id='" + id + "']");
    var $parents = $thisInput.parents('.js-formGroup');
    var $lookupButton = $parents.find('.js-findPostcode');
    $lookupButton.prop('disabled', false);
  },
  forceLookup: function (id, errorType) {
    var $thisInput = $("input[id='" + id + "']");
    var $parents = $thisInput.parents('.js-formGroup');
    var $label = $('label[for="' + id + '"]');
    var errorMsg = $label.attr(errorType);
    var $errorMsgContainer = $parents.find('.js-errorMsg');
    var $lookupButton = $parents.find('.js-findPostcode');
    var wasClicked = !$lookupButton.hasClass('isPristine');
    var forceLookup = $thisInput.hasClass('force-lookup');
    if (forceLookup && !wasClicked) {
      $parents.addClass('has-error').removeClass('is-valid');
      $errorMsgContainer.html(errorMsg).removeClass('hide');
    }
  },
  confirmPassword: function (id, value) {
    var password = $(this.formPasswordField).val();
    if (password !== value) {
      this.toggleError(id, this.ERROR_INVALID);
    } else {
      this.toggleError(id);
    }
  },
  confirmEmail: function () {
    var confirmEmailvalue = $(this.formConfirmEmailField).val();
    var email = $(this.formEmailField).val();

    if (email !== confirmEmailvalue) {
      this.isConfirmEmail = 'is-invalid';
    } else {
      this.isConfirmEmail = 'is-valid';
    }
  },
  /**
   * Formats postcode: with space (if needed), and uppercase
   * @param  {[type]} id    [description]
   * @param  {[type]} value [description]
   */
  formatPostcode: function (id, value) {
    var formattedPostcode;
    // Check if the postcode already has a space, and add one if not
    if (value.indexOf(' ') > 0) {
      formattedPostcode = value;
    } else {
      formattedPostcode = value.replace(/(\d{1})(?!.*\d{1})/g, ' $1');
    }

    // Convert to uppercase
    formattedPostcode = formattedPostcode.toUpperCase();
    // Inject it back in the form
    var $label = $('label[for="' + id + '"]');
    var $formGroup = $label.parents('.js-formGroup');
    $formGroup.find('input[id="' + id + '"]').val(formattedPostcode);
  },

  /**
   * Validate field's length
   * @param  {string} value
   * @param  {object} fieldRules
   * @return {boolean}
   */
  checkLength: function (value, fieldRules) {
    var inputValue = value.replace(/ /g, '');
    if (inputValue.length < fieldRules.min) {
      return false;
    }
    if (inputValue.length > fieldRules.max) {
      return false;
    }
    return true;
  },
  /**
   * Validate field's regex
   * @param  {string} value
   * @param  {string} regexValue
   * @return {boolean}
   */
  checkRegex: function (value, regexValue, modifier) {
    var regex = new RegExp(regexValue, modifier);
    return regex.test(value);
  },
  onFieldChange: function (el) {
    var $el = $(el);
    var validationType = $el.attr('data-validation-type');
    var isRequired = $el.hasClass(this.IS_REQUIRED);
    var isOptional = $el.hasClass(this.IS_OPTIONAL);
    var isShowError = $el.attr('data-showError');
    var isDisabled = typeof $el.attr('disabled') != 'undefined';
    var value;

    if (validationType === 'select') {
      value = $el.find('option:selected').val();
    } else if (validationType === 'checkbox') {
      value = $el.is(':checked');
    } else if (validationType === 'radio') {
      var name = $el.attr('name');
      var radioVal = $('input:radio[name=' + name + ']:checked').val();
      value = radioVal;
    } else if (validationType === 'companyregnumber') {
      const companyregnumberValue = el.value;
      el.value = companyregnumberValue.toUpperCase();
      value = el.value;
    } else {
      value = $el.val();
    }

    var id = $el.attr('id');
    if (isRequired && !isDisabled) {
      if (value) {
        // Hide empty warning and validate field
        if (isShowError) {
          var idKey = $('#Yes').parents('.js-formGroup').next('.js-formGroup').find('#No').attr('id');
          this.toggleError(idKey);
        }
        this.toggleError(id);
        if (validationType === 'confirmPassword') {
          this.confirmPassword(id, value);
        } else if (validationType === 'confirmEmail' || (validationType === 'email' && $el.hasClass('js-formFieldEmail'))) {
          this.confirmEmail();
          this.validateField(id, value, validationType, isDisabled);
          var element;
          var nameNew;
          if ($('#collectNectar\\.confirmEmail').length > 0) {
            element = $('#collectNectar\\.confirmEmail');
            nameNew = 'collectNectar.confirmEmail';
          } else if ($('#register\\.confirmEmail').length > 0) {
            element = $('#register\\.confirmEmail');
            nameNew = 'register.confirmEmail';
          }
          var confirmEmailVal = element.val();
          if (validationType === 'email' && $el.hasClass('js-formFieldEmail') && confirmEmailVal) {
            this.validateField(nameNew, confirmEmailVal, 'confirmEmail', isDisabled);
          }
        } else if (validationType !== 'select' && validationType !== 'checkbox' && validationType !== 'radio') {
          this.validateField(id, value, validationType, isDisabled);
        }
      } else {
        // Required fields can't be empty
        if (!isShowError) this.toggleError(id, this.ERROR_EMPTY, isDisabled);
      }
    } else {
      // If field is not required but has some value then validate it
      if (value.length && validationType !== 'select') {
        this.validateField(id, value, validationType, isDisabled);
      } else {
        // Otherwise remove error
        if (!isOptional) {
          // If is not optional field show error via toggle
          this.toggleError(id, null, isDisabled);
        } else {
          // If is optional field hide errors
          var $formGroup = $el.parents('.js-formGroup');
          $formGroup.removeClass(this.HAS_ERROR);
          $formGroup.removeClass(this.IS_VALID);
        }
      }
    }
  },
  /**
   * @param  {object} $form jQuery object
   * @return {boolean}
   */
  isFormValid: function ($form) {
    var errors = $form.find('.' + ACC.validation.HAS_ERROR);
    return errors.length ? false : true;
  },
  /**
   * In case form is valid display loading icon and disable button to avoid multiple form submissions
   * @param  {object} $form - jQuery object
   * @param  {Boolean} isValid - is main form valid
   */
  toggleLoadingState: function ($form, isValid) {
    var $submitButton = $form.find(this.submitButton);
    var $nextButton = $form.find(this.nextButton);
    var showLoading = $submitButton.hasClass(this.loadingClass);
    if (isValid && showLoading) {
      this.toggleDisableSubmit($form, false);
      $submitButton.addClass(this.LOADING_CLASS);
      $nextButton.addClass(this.LOADING_CLASS);
    } else {
      $submitButton.removeClass(this.LOADING_CLASS);
      $nextButton.removeClass(this.LOADING_CLASS);
    }
  },
  nectarCardExist: function (cardNumber, id) {
    var _this = this;
    var inputField = document.getElementById(id).parentElement;
    var label = inputField.previousElementSibling;
    var formGroup = label.closest('.js-formGroup');
    var errorContainer = formGroup.querySelector('.js-errorMsg');
    var createLoaderElement = document.createElement('i');

    formGroup.classList.remove(this.HAS_ERROR);
    errorContainer.classList.add(this.HIDE);
    createLoaderElement.classList.add('loader');
    inputField.appendChild(createLoaderElement);

    var loaderElement = inputField.querySelector('.loader');

    $.ajax({
      url: '/nectar-points/validate-card-exists?cardNumber=' + cardNumber,
      success: function (response) {
        loaderElement && loaderElement.parentElement.removeChild(loaderElement);

        if (response) {
          var errorMessage = inputField.closest('.custom-txtbox').previousElementSibling.value;
          _this.displayErrorMessage(errorMessage, label, formGroup, errorContainer);
        } else {
          _this.displaySuccessMessage(formGroup, errorContainer);
        }
      },
      error: function () {
        var errorMessage = document.querySelector('.js-nectar-card-status-error').value;

        loaderElement && loaderElement.parentElement.removeChild(loaderElement);
        _this.displayErrorMessage(errorMessage, label, formGroup, errorContainer);
      }
    });
  },
  toggleDisableSubmit: function (form, valid) {
    var $form = $(form);
    var $submitButton = $form.find(this.submitButton);
    var $submitButtonMultiStep = this.$submitButtonMultiStep;
    var $nextButton = $form.find(this.nextButton);

    if (valid) {
      $submitButton.removeClass('disabled');
      $submitButtonMultiStep.removeClass('disabled');
    } else {
      $submitButton.addClass('disabled');
      $submitButtonMultiStep.addClass('disabled');
      if (this.dwellChatEnabled) {
        this.checkEntireForm();
      }
    }
    $nextButton.attr('disabled', !valid);
  },
  validateForm: function ($form) {
    if (this.isFormValid($form)) {
      this.toggleDisableSubmit($form, true);
    } else {
      this.toggleDisableSubmit($form, false);
    }
  },
  validateAllRequired: function (formId) {
    var allRequiredFields = $('#' + formId).find('.' + this.IS_REQUIRED);
    allRequiredFields = ACC.validation.removeHiddenFields(allRequiredFields);
    allRequiredFields.each(function () {
      if (this.tagName === 'TEXTAREA' && !this.closest('.custom-textarea').parentElement.classList.contains('hide')) {
        !this.value.length && this.parentElement.classList.add('has-error');
      } else {
        $(this).trigger('change');
      }
    });
  },
  validateAllOptional: function (formId) {
    var allOptionalFields = $('#' + formId).find('.' + this.IS_OPTIONAL);
    allOptionalFields.each(function () {
      $(this).trigger('change', 'ignoreReset');
    });
  },
  removeHiddenFields: function (allRequiredFields) {
    var $addressSection = $('.js-businessAdreessFieldSection');
    var businessAddressRadioVal = $('input:radio[name=businessAddressDifferent]:checked').val();

    if (!$addressSection) {
      allRequiredFields = allRequiredFields;
    } else if (businessAddressRadioVal === 'Yes') {
      allRequiredFields = allRequiredFields;
    } else {
      var $inputFields = $addressSection.find('.js-formField');
      for (var i = allRequiredFields.length - 1; i >= 0; i--) {
        for (var j = 0; j < $inputFields.length; j++) {
          if (allRequiredFields[i] && allRequiredFields[i].name === $inputFields[j].name) {
            allRequiredFields.splice(i, 1);
          }
        }
      }
    }
    return allRequiredFields;
  },
  updateCounter: function (textArea) {
    var $textArea = $(textArea);
    var $formGroup = $textArea.parents('.js-formGroup');
    var hasCounter = $textArea.hasClass('has-counter');
    var maxLength = 0;
    var charsCalc = 0;
    var charsLength = $textArea.val().length;
    var $counter = {};
    if (hasCounter) {
      maxLength = parseInt($textArea.data('maxlength'));
      $counter = $textArea.parents('.custom-textarea').find('.js-textAreaCounter');
      charsCalc = maxLength - charsLength;
      $counter.html(charsCalc);
      this.handleCounterMax($formGroup, charsCalc);
    }
  },
  initValidation: function () {
    $(document).on('click', '.js-findPostcode', function () {
      var $this = $(this);
      var $parents = $this.parents('.js-formGroup');
      var inputVal = $parents.find('.js-postcodeInput').val();
      if (inputVal && $this.hasClass('isPristine')) {
        $this.removeClass('isPristine');
        $parents.removeClass('has-error');
        $parents.find('.js-errorMsg').addClass('hide');
        $this.trigger('click');
      }
    });

    $(document).on('blur input change keyup', this.formField, function (e) {
      var target = e.target;
      var form = target.closest('form');
      ACC.validation.onFieldChange(target);
      ACC.validation.validateForm($(form));
    });

    $(document).on('keyup', this.formTextareaField, function (e) {
      var textArea = e.target;
      var $form = $(textArea).parents('form');
      ACC.validation.onFieldChange(textArea);
      ACC.validation.validateForm($form);
      ACC.validation.updateCounter(textArea);
    });

    $(document).on('submit', 'body:not(".page-sfRegister") .js-formValidation', function () {
      var formId = this.getAttribute('id');
      var noValidation = this.getAttribute('data-noValidation');
      var $form = $('#' + formId);
      var isFormValid = false;
      if (noValidation && noValidation === 'true') {
        var listOfErrorField = $form.find('.' + ACC.validation.HAS_ERROR);
        $(listOfErrorField).each(function () {
          $(this).find('.js-formField').val();
        });
      } else {
        ACC.validation.validateAllRequired(formId);
        isFormValid = ACC.validation.isFormValid($form);
        ACC.validation.toggleLoadingState($form, isFormValid);
        // If form is invalid
        if (!isFormValid) {
          // On mobile open all sections to present error messages
          $('.js-formSection').addClass('is-active').removeClass('pristine');
          // scroll to first errror
          // If form is invalid scroll to first errror.
          ACC.global.scrollToElement('.js-formGroup.has-error');
        } else {
          $('.js_spinner').show();
        }
        if (window.hasAccountsList) {
          ACC.register.collectAccountsList('.js-accountNumbers', '.js-accountNumber');
        }
        return isFormValid;
      }
    });

    // On load check if every form is validation
    $(this.formsToValidate).each(function () {
      ACC.validation.validateForm($(this));
      ACC.validation.validateOnGoBack(this);
    });
  },
  handleCounterMax: function ($field, charCount) {
    var $counterWrap = $field.find('.js-counterWrap');
    var $counterError = $field.find('.js-counterErrorMsg');
    if (charCount === 0) {
      $counterWrap.addClass(ACC.validation.HIDE);
      $counterError.removeClass(ACC.validation.HIDE);
    } else {
      $counterWrap.removeClass(ACC.validation.HIDE);
      $counterError.addClass(ACC.validation.HIDE);
    }
  },

  postRegisterRetarget: function (form) {
    $.ajax({
      url: '/customer-register-retarget/submit',
      type: 'POST',
      data: form.serialize(),
      success: function () {
        console.log('submit customer register retarget');
      }
    });
  },

  bindMultiStepFormSubmit: function () {
    var submitRegistrationForm = document.body.querySelectorAll('.js-submitRegistrationForm');
    submitRegistrationForm.length &&
      submitRegistrationForm.forEach(function (submitButton) {
        submitButton.addEventListener('click', function () {
          var $form = $('#registerForm');
          if ($('.js-step').val() === 'STEP_ONE') {
            $.ajax({
              url: '/csrftoken',
              success: function (response) {
                document.querySelector('input[name="CSRFToken"]').value = response.cSRFToken;

                var emailError = !$('.js-registerEmailSection').find('.' + ACC.validation.HAS_ERROR).length;
                var confirmEmailError = !$('.js-registerConfirmEmailSection').find('.' + ACC.validation.HAS_ERROR).length;
                var marketingError = $('.js-marketingConsent').val() === 'true';
                if (emailError && confirmEmailError && marketingError) {
                  ACC.validation.postRegisterRetarget($form);
                }
              }
            });
          }
          $form.submit();
        });
      });
  },

  checkCharactersCount: function () {
    $(this.formTextareaField).each(function () {
      if ($(this).val().length) {
        ACC.validation.updateCounter($(this));
      }
    });
  },

  validateOnGoBack: function (form) {
    if (window.formPrePopulated) {
      this.checkCharactersCount();
      this.validateAllRequired($(form).attr('id'));
      this.validateAllOptional($(form).attr('id'));
      var $formGroup = $('.js-postcodeInput').parents('.js-formGroup');
      var $postCodeInput = $formGroup.find('.js-postcodeInput');
      $postCodeInput.each(function () {
        var $formGroup = $(this).parents('.js-formGroup');

        var selectAttr = $formGroup.attr('data-selectaddress');
        if (selectAttr) {
          if ($formGroup.hasClass('has-error')) {
            $('.js-businessAddressFields').addClass('hide');
          }
        } else {
          if ($formGroup.hasClass('has-error')) {
            $('.js-addressFields').addClass('hide');
          }
        }
      });
    }
  },
  checkEntireForm: function () {
    var $allRequiredFields = $('.js-multiStepRegistrationForm').find('.' + this.IS_REQUIRED);
    var allFieldsCount = 0;
    var notEmptyRequiredFields = 0;
    var $nextBtn = $('.js-submitRegistrationForm');
    $allRequiredFields.each(function (index, fieldEl) {
      var $field = $(fieldEl);

      if (!$field.attr('disabled')) {
        allFieldsCount += 1;
        if ($field.val() !== '') {
          notEmptyRequiredFields += 1;
        }
      }
    });
    if (allFieldsCount === notEmptyRequiredFields) {
      if ($nextBtn.hasClass('disabled')) {
        ACC.dwellChat.openChat();
      }
    }
  }
};

export default validation;
