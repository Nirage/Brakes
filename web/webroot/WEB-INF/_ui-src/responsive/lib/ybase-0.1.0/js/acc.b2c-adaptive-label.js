const b2cAdaptiveLabel = {
  init: function () {
    //Handle empty fields
    ACC.b2cAdaptiveLabel.handleEmptyFields();

    //Handle optional fields
    ACC.b2cAdaptiveLabel.handleOptionalFields();
  },
  handleEmptyFields: function () {
    var $target = '.js-adaptiveSearch';

    $(document).on('focusout', $target, function () {
      //Check if value is empty
      if ($(this).val().length > 0) {
        $(this).addClass('b2c-al--not-empty');
      } else {
        $(this).removeClass('b2c-al--not-empty');
      }
    });
  },
  handleOptionalFields: function () {
    $(document).on('focusin change', '.js-adaptiveInputOptional', function () {
      if ($(this).val().length >= 0) {
        $(this).next('.js-adaptiveLabelOptional').addClass('b2c-al__label--optional-active');
      } else {
        $(this).next('.js-adaptiveLabelOptional').removeClass('b2c-al__label--optional-active');
      }
    });
    $(document).on('focusout', '.js-adaptiveInputOptional', function () {
      if ($(this).val().length === 0) {
        $(this).next('.js-adaptiveLabelOptional').removeClass('b2c-al__label--optional-active');
      } else {
        $(this).next('.js-adaptiveLabelOptional').addClass('b2c-al__label--optional-active');
      }
    });
  }
};

export default b2cAdaptiveLabel;
