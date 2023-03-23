const b2cDeliveryPopup = {
  _autoload: ['init'],
  init: function () {
    if (ACC.config.isb2cSite === true && ACC.config.checkoutPage == true) {
      //Check if pop up needs to appear
      ACC.b2cDeliveryPopup.showPopUp();
    }
  },
  //Check if pop up needs to appear
  showPopUp: function () {
    var $invalidResponseText = 'Do not show the pop up';
    var $body = $('body');

    $.get(ACC.config.b2cAddDeliveryAddressEndpoint, function (data, status) {
      //Check response status and if user needs to see the pop up
      if (status == 'success' && data.indexOf($invalidResponseText) < 1) {
        var $stepOneRequiredFields = '.js-b2cDeliveryFormStepOne';
        var $stepOneScreen = '#b2c-checkout-delivery__step-one';
        var $stepTwoRequiredFields = '.js-b2cDeliveryFormStepTwo';
        var $stepTwoScreen = '#b2c-checkout-delivery__step-two';
        var $stepThreeRequiredFields = '.js-b2cDeliveryFormStepThree';

        //Append the pop up to the body
        $body.append(data);
        //Handle adaptive labels behaviour
        ACC.b2cAdaptiveLabel.init();
        //Initialize validation
        ACC.validation.initValidation();
        //Handle back/next buttons behaviour
        ACC.b2cDeliveryPopup.handleBackNextButtonsBehaviour();
        //Handle distance range slider
        ACC.b2cDeliveryPopup.handleDistanceRangeSlider();
        //Init postcode lookup
        ACC.postcodeLookup.init();
        //Invoke step one validation
        $(document).on('keyup paste change', $stepOneRequiredFields, function () {
          ACC.b2cDeliveryPopup.handleStepOneAndTwoValidation($($stepOneRequiredFields), $stepOneScreen);
        });
        //Invoke step two validation
        $(document).on('keyup paste change', $stepTwoRequiredFields, function () {
          ACC.b2cDeliveryPopup.handleStepOneAndTwoValidation($($stepTwoRequiredFields), $stepTwoScreen);
        });
        //Invoke step three validation
        $(document).on('keyup paste change', $stepThreeRequiredFields, function () {
          ACC.b2cDeliveryPopup.handleStepThreeValidation();
        });
      }
    });
  },
  //Handle back/next button behaviour
  handleBackNextButtonsBehaviour: function () {
    var $backButton = $('.js-b2cCheckoutDeliveryProgressBarBack');
    var $nextButton = $('.js-b2cCheckoutDeliveryProgressBarNext');
    var $nextButtonWrapper = $('.js-b2cCheckoutDeliveryNext');
    var $addAddressButtonWrapper = $('.js-b2cCheckoutDeliveryAdd');
    var progressStateConfing = {
      step: 1, //Default state is 1
      percentage: 25
    };

    // Increase step
    $nextButton.on('click', function () {
      //Increase up to 4
      if (progressStateConfing.step < 4) {
        ACC.b2cDeliveryPopup.handleProgressState((progressStateConfing.step += 1), progressStateConfing.percentage);
        $backButton.removeClass('disabled');
      }
      //Swap text if step equals 4
      if (progressStateConfing.step === 4) {
        $nextButtonWrapper.addClass('hide');
        $addAddressButtonWrapper.removeClass('hide');
      }
    });

    // Decrease step
    $backButton.on('click', function () {
      //Decrease up to 1
      if (progressStateConfing.step > 1) {
        ACC.b2cDeliveryPopup.handleProgressState((progressStateConfing.step -= 1), progressStateConfing.percentage);
      }
      //Disable the back button if on step 1
      if (progressStateConfing.step === 1) {
        $backButton.addClass('disabled');
      }
      //Swap buttons if step below 4
      if (progressStateConfing.step < 4) {
        $nextButtonWrapper.removeClass('hide');
        $addAddressButtonWrapper.addClass('hide');
      }
    });
  },
  //Handle progress state
  handleProgressState: function (step, percentage) {
    var $stepLabel = $('.js-b2cCheckoutDeliveryProgressBarStep');
    var $progressBar = $('.js-b2cCheckoutDeliveryProgress');
    var $deliverySteps = $('.js-b2cCheckoutDeliveryStep');

    var $stepOneRequiredFields = '.js-b2cDeliveryFormStepOne';
    var $stepOneScreen = '#b2c-checkout-delivery__step-one';
    var $stepTwoRequiredFields = '.js-b2cDeliveryFormStepTwo';
    var $stepTwoScreen = '#b2c-checkout-delivery__step-two';
    var $stepThreeScreen = '#b2c-checkout-delivery__step-three';
    //Handle different steps
    switch (step) {
      case 1:
        ACC.b2cDeliveryPopup.handleStepOneAndTwoValidation($($stepOneRequiredFields), $stepOneScreen); //Check step one validation
        $stepLabel.text(step); //Update progress steps
        $progressBar.width(percentage * step + '%'); //Update progress bar
        $deliverySteps.addClass('hide'); //Toggle screens
        $($stepOneScreen).removeClass('hide');
        break;
      case 2:
        ACC.b2cDeliveryPopup.handleStepOneAndTwoValidation($($stepTwoRequiredFields), $stepTwoScreen); //Check step two validation
        $progressBar.width(percentage * step + '%'); //Update progress bar
        $stepLabel.text(step); //Update progress steps
        $deliverySteps.addClass('hide'); //Toggle screens
        $($stepTwoScreen).removeClass('hide');
        break;
      case 3:
        ACC.b2cDeliveryPopup.handleStepThreeValidation(); //Check step three validation
        $stepLabel.text(step); //Update progress steps
        $progressBar.width(percentage * step + '%'); //Update progress bar
        $deliverySteps.addClass('hide'); //Toggle screens
        $($stepThreeScreen).removeClass('hide');
        break;
      case 4:
        ACC.b2cDeliveryPopup.handleStepFourValidation(); //Check step four validation
        $stepLabel.text(step); //Update progress steps
        $progressBar.width(percentage * step + '%'); //Update progress bar
        $deliverySteps.addClass('hide'); //Toggle screens
        $('#b2c-checkout-delivery__step-four').removeClass('hide');
        break;
    }
  },
  //Handle distance range slider
  handleDistanceRangeSlider: function () {
    var $slider = $('.js-checkoutDeliveryRangeSlider');
    var $output = $('.js-checkoutDeliveryRangeSliderValue');

    //Set default value
    $output.html($slider.val() + ' m');
    //Update value on user's input
    $slider.on('input', function () {
      if ($(this).val() === '100') {
        $output.html($(this).val() + 'm+');
      } else {
        $output.html($(this).val() + 'm');
      }
    });
  },
  //Handle step validation
  handleStepOneAndTwoValidation: function (selector, screen) {
    var $reqlength = selector.length;
    var $value = selector.filter(function () {
      return this.value != '';
    });
    var $nextButtonSelector = $('.js-b2cCheckoutDeliveryProgressBarNext');
    //Timeout required as DOM is slow to update
    setTimeout(function () {
      if ($value.length >= 0 && $value.length !== $reqlength) {
        //Disable the form
        $nextButtonSelector.addClass('disabled');
      } else if ($(screen + ' .has-error').length > 0) {
        //Disable the form
        $nextButtonSelector.addClass('disabled');
      } else {
        //Validate form again
        $nextButtonSelector.removeClass('disabled');
      }
    }, 200);
  },
  handleStepThreeValidation: function () {
    var $groundFloorRadioBtn = $('input[name=groundFloor]:checked').length;
    var $vehicleRestrictionsRadioBtn = $('input[name=vehicleRestriction]:checked').length;
    var $largeVehicleRadioBtn = $('input[name=largeVehicleParking]:checked').length;
    var $nextButtonSelector = $('.js-b2cCheckoutDeliveryProgressBarNext');

    if ($largeVehicleRadioBtn > 0 && $vehicleRestrictionsRadioBtn > 0 && $groundFloorRadioBtn > 0) {
      $nextButtonSelector.removeClass('disabled');
    } else {
      $nextButtonSelector.addClass('disabled');
    }
  },
  handleStepFourValidation: function () {
    $(document).on('change', '.js-bc2DeliveryLegalCheckbox', function () {
      var $checkCountLength = $('.js-bc2DeliveryLegalCheckbox:checked').length;
      var $totalCheckboxLength = $('.js-bc2DeliveryLegalCheckbox').length;
      var $addDeliveryAddressButton = $('.js-bc2DeliveryAddBtn');

      if ($totalCheckboxLength === $checkCountLength) {
        $addDeliveryAddressButton.removeClass('disabled');
      } else {
        $addDeliveryAddressButton.addClass('disabled');
      }
    });
  }
};

export default b2cDeliveryPopup;
