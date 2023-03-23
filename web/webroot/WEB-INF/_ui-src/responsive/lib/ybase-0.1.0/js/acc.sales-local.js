const salesLocal = {
  _autoload: [['bindPostCodeSearch', $('#sales-local-form').length]],
  POSTCODE_INPUT: $('.js-postcode-value'),
  POSTCODE_ERROR: $('.js-sales-postcode-err'),
  POSTCODE_NO_RESULTS: $('.js-sales-postcode-no-results'),
  POSTCODE_LOCAL_DATA: $('#sales-local-data'),
  POSTCODE_VALID_CLASS: 'is-valid',
  SALES_LOCAL_INDICATOR: $('.js_spinner'),
  bindPostCodeSearch: function () {
    ACC.salesLocal.POSTCODE_INPUT.on('change keyup', ACC.salesLocal.handlePostCodeChange);

    $(document).on('submit', '#sales-local-form', function (e) {
      e.preventDefault();
      ACC.global.checkLoginStatus(ACC.salesLocal.handlePostCodeSearch);
    });
  },

  handlePostCodeChange: function () {
    var isPostCodeValid = false;
    var postCodeVal = ACC.salesLocal.POSTCODE_INPUT.val();

    if (postCodeVal.length > 4) {
      postCodeVal = postCodeVal.split(' ').join('');
    }

    if (postCodeVal.length == 6) {
      postCodeVal = postCodeVal.substr(0, 3) + ' ' + postCodeVal.substr(3, 3);
    }

    if (postCodeVal.length > 3) {
      if (postCodeVal.length > 7) {
        ACC.salesLocal.POSTCODE_INPUT.val(postCodeVal.toUpperCase());
        isPostCodeValid = false;
      } else if (postCodeVal.length > 4 && postCodeVal.length <= 7) {
        if (postCodeVal.length === 7) {
          isPostCodeValid = new RegExp(ACC.validation.regex.postcode).test(postCodeVal.substr(4, 3));
          if (isPostCodeValid) {
            postCodeVal = postCodeVal.replace(/(\S*)\s*(\d)/, '$1 $2');
            ACC.salesLocal.POSTCODE_INPUT.val(postCodeVal.toUpperCase());
          } else {
            postCodeVal = postCodeVal.split(' ').join('');
            ACC.salesLocal.POSTCODE_INPUT.val(postCodeVal.toUpperCase());
          }
        } else {
          postCodeVal = postCodeVal.replace(/(\S*)\s*(\d)/, '$1 $2');
          ACC.salesLocal.POSTCODE_INPUT.val(postCodeVal.toUpperCase());
          isPostCodeValid = new RegExp(ACC.validation.regex.postcode).test(postCodeVal);
        }
      } else {
        isPostCodeValid = new RegExp(ACC.validation.regex.shortpostcode).test(postCodeVal);
      }
    } else {
      isPostCodeValid = new RegExp(ACC.validation.regex.shortpostcode).test(postCodeVal);
    }

    ACC.salesLocal.applyPostCodeValidation(isPostCodeValid);
  },

  applyPostCodeValidation: function (isPostCodeValid) {
    if (isPostCodeValid) {
      ACC.salesLocal.POSTCODE_INPUT.addClass(ACC.salesLocal.POSTCODE_VALID_CLASS);
      ACC.salesLocal.errroPostCodeHide();
    } else {
      ACC.salesLocal.POSTCODE_INPUT.removeClass(ACC.salesLocal.POSTCODE_VALID_CLASS);
      ACC.salesLocal.clearPostCodeData();
      ACC.salesLocal.errorPostCode();
    }
  },

  handlePostCodeSearch: function () {
    if (ACC.salesLocal.POSTCODE_INPUT.hasClass(ACC.salesLocal.POSTCODE_VALID_CLASS)) {
      var postCodeVal = ACC.salesLocal.POSTCODE_INPUT.val();
      ACC.salesLocal.SALES_LOCAL_INDICATOR.show();
      $.ajax({
        type: 'GET',
        url: ACC.config.salesLocalRepUrl,
        dataType: 'json',
        data: { postCode: postCodeVal.toUpperCase() },
        success: function (response) {
          if (response.length > 0) {
            ACC.salesLocal.renderPostCodeResults({ response: response });
            ACC.salesLocal.errroPostCodeHide();
          } else {
            ACC.salesLocal.clearPostCodeData();
            ACC.salesLocal.errorPostCodeNoResults();
          }
        },
        error: function () {
          ACC.salesLocal.clearPostCodeData();
          ACC.salesLocal.errorPostCodeNoResults();
        }
      });
    } else {
      ACC.salesLocal.clearPostCodeData();
      ACC.salesLocal.errorPostCode();
    }
  },

  clearPostCodeData: function () {
    ACC.salesLocal.POSTCODE_LOCAL_DATA.empty();
  },

  renderPostCodeResults: function (data) {
    ACC.global.renderHandlebarsTemplate(data, 'sales-local-data', 'sales-local-postcode-template');
    ACC.salesLocal.errroPostCodeHide();
  },

  errroPostCodeHide: function () {
    ACC.salesLocal.POSTCODE_ERROR.addClass('hide');
    ACC.salesLocal.POSTCODE_NO_RESULTS.addClass('hide');
    ACC.salesLocal.SALES_LOCAL_INDICATOR.hide();
  },

  errorPostCode: function () {
    ACC.salesLocal.POSTCODE_ERROR.removeClass('hide');
    ACC.salesLocal.POSTCODE_NO_RESULTS.addClass('hide');
    ACC.salesLocal.SALES_LOCAL_INDICATOR.hide();
  },

  errorPostCodeNoResults: function () {
    ACC.salesLocal.POSTCODE_ERROR.addClass('hide');
    ACC.salesLocal.POSTCODE_NO_RESULTS.removeClass('hide');
    ACC.salesLocal.SALES_LOCAL_INDICATOR.hide();
  }
};

export default salesLocal;
