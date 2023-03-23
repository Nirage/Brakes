const postcodeLookup = {
  isEnabled: false,
  apiKey: '',
  findUrl: '',
  retrieveByIdUrl: '',
  forms: [],
  postcodeInput: '.js-postcodeInput',
  findButton: '.js-findPostcode',
  /**
   * Itnialize postcode Lookup service
   */
  init: function () {
    if (window.loqate && window.loqate.hasOwnProperty('hybris')) {
      this.setLoqate(window.loqate.hybris);
      this.getAddresseDetails();
      this.bindFindButtons();
    } else {
      return false;
    }
  },
  setLoqate: function (loqate) {
    this.apiKey = ACC.config.pcaApiKey;
    this.findUrl = ACC.config.pcaFindURL;
    this.retrieveByIdUrl = ACC.config.pcaRetrieveURL;
    this.forms = loqate.forms;
    this.isEnabled = true;
  },
  bindFindButtons: function () {
    var _this = this;
    _this.forms.forEach(function (form) {
      var $form = $('#' + form.formId);
      var $findButton = $form.find(_this.findButton);
      var $postcodeInput = $form.find(_this.postcodeInput);
      //var $parent = $findButton.parents(".js-formGroup");
      var searchedVal = '';
      $findButton.on('click keypress', function (e) {
        if (ACC.global.keyPressCheck(e)) {
          var $formSection = $(e.currentTarget).parents('.js-formGroup');
          var addressListName = $formSection.attr('data-selectAddress');
          var addressListId = 'business.adddress';
          if (!addressListName) {
            addressListName = 'jsSelectAddress';
            addressListId = 'select.adddress';
          }
          var addressList = {
            elemName: addressListName,
            id: addressListId
          };
          var $postcodeInputSection = $formSection.find('.js-postcodeInput');
          searchedVal = $postcodeInputSection.val();
          if (!$formSection.hasClass('has-error') && searchedVal.length) {
            _this.getAddressesList(searchedVal, form.formId, addressList);
            $(e.currentTarget).next('.js-enterAddressManually').removeClass('hide');
          }
          if (!searchedVal.length) {
            $postcodeInputSection.trigger('change'); // To revalidate field
          }
        }
      });
      $postcodeInput.on('focusout', function (e) {
        var $formGroup = $(e.currentTarget).parents('.js-formGroup');
        var addressListName = $formGroup.attr('data-selectAddress');
        if (!addressListName) {
          addressListName = 'jsSelectAddress';
        }
        if ($formGroup.hasClass('is-valid') && !$(e.relatedTarget).hasClass('js-findPostcode')) {
          if (
            $('#' + addressListName)
              .html()
              .trim().length === 0
          ) {
            $formGroup.find('.js-findPostcode').trigger('click');
          }
        }
      });
    });
  },
  findMatchingForm: function (formsList, searchedForm) {
    var form = formsList.filter(function (form) {
      return form.formId == searchedForm;
    });
    return form[0];
  },
  populateFormFields: function (response, formId, addressFields) {
    var allForms = this.forms;
    var form = this.findMatchingForm(allForms, formId);
    var fieldstr = addressFields.fieldName;
    var formFields = form[fieldstr];
    var fieldsData = response[0];
    var $fieldsContainer = $(addressFields.elem); //$('[id="' + formId + '"]').find(".js-addressFields");

    for (var key in formFields) {
      var $field = $('[id="' + formFields[key] + '"]');
      var isRequired = $field.hasClass('is-required');
      $field.val(fieldsData[key]);
      if (isRequired || $field.val() != '') {
        $field.trigger('change');
      }
    }
    // Display form after fields were populated
    $fieldsContainer.removeClass('hide');
  },
  getAddresseDetails: function () {
    var _this = this;
    $(document).on('change', '.js-addressSelect', function () {
      var $this = $(this);
      var addressId = $this.val();
      var formId = $this.data('parent-form');
      var addressFields;
      if ($(this).parents('#jsBusinessSelectAddress').length > 0) {
        addressFields = {
          elem: '.js-businessAddressFields',
          fieldName: 'businessfields'
        };
      } else {
        addressFields = {
          elem: '.js-addressFields',
          fieldName: 'fields'
        };
      }
      if (addressId) {
        $.post(
          _this.retrieveByIdUrl,
          {
            Key: _this.apiKey,
            Id: addressId
          },
          function (data) {
            _this.populateFormFields(data.Items, formId, addressFields);
            // Display enter address manually after first Postcode Lookup
            $('.js-enterAddressManually').addClass('hide');
          }
        );
      }
    });
  },

  /**
   * Loqate https://www.loqate.com/resources/support/apis/Capture/Interactive/Find/1.1/
   * @param {query} - string - required
   * @param {formId} - string - required
   */
  getAddressesList: function (query, formId, addressList) {
    var _this = this;
    $.post(
      _this.findUrl,
      {
        Key: _this.apiKey,
        Text: query,
        Countries: 'GB'
      },
      function (data) {
        // Test for an error
        if (data.Items.length == 1 && typeof data.Items[0].Error != 'undefined') {
          // Show the error message
          console.warn(data.Items[0].Description);
        } else {
          // Check if there were any items found
          if (data.Items.length == 0) {
          } else {
            _this.renderListOfAddresses(formId, data.Items, addressList);
          }
        }
      }
    );
  },
  renderListOfAddresses: function (formId, items, addressList) {
    var _this = this;
    var postcodeItem = items[0];
    var config = {
      Key: _this.apiKey,
      Text: postcodeItem.Text,
      Countries: 'GB',
      Method: 'Match',
      Container: postcodeItem.Id
    };
    $.post(_this.findUrl, config, function (data) {
      // Test for an error
      if (data.Items.length == 1 && typeof data.Items[0].Error != 'undefined') {
        // Show the error message
        console.warn(data.Items[0].Description);
      } else {
        // Check if there were any items found
        if (data.Items.length == 0) {
        } else {
          ACC.global.renderHandlebarsTemplate(
            {
              formId: formId,
              items: data.Items,
              selectId: addressList.id
            },
            addressList.elemName,
            'select-address-template'
          );
        }
      }
    });
  }
};

export default postcodeLookup;
