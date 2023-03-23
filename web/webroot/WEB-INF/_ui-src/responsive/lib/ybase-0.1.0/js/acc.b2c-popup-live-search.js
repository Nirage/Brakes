const b2cPopupLiveSearch = {
  //Execute on page load
  init: function () {
    //Show B2B units on keypress
    $(document).on('keyup paste', '.js-b2bLocationInput', function () {
      //Disable the input of special characters
      ACC.b2cPopupLiveSearch.handleSpecialCharactersInput($(this));
      //Toggle location units based on value length
      ACC.b2cPopupLiveSearch.handleDisplayingUnitsSearchResults();
      //Handle live B2B location search
      ACC.b2cPopupLiveSearch.handleB2BUnitLiveSearch();
    });
    //Handle B2B unit selection
    ACC.b2cPopupLiveSearch.handleB2BUnitSelection();
    //Handle login button behaviour
    ACC.b2cPopupLiveSearch.handleLoginButton();
  },
  //Block user for inputing special characters
  handleSpecialCharactersInput: function (current) {
    var $value = current.val();
    var $filter = current.attr('chars');
    var $regReplace = new RegExp('[^' + $filter + ']', 'ig');

    //Replace the special characters
    current.val($value.replace($regReplace, ''));
  },
  //Handle live B2B location search
  handleB2BUnitLiveSearch: function () {
    var $locationInput = $('.js-b2bLocationInput').val();
    var $locationInputTrimmed = $locationInput.toUpperCase().replace(/ /g, '');
    var $b2bUnitArray = $('.js-b2bUnit');
    var $noSearchResultMessage = $('.js-b2bListOfUnitsEmpty');

    //Loop through b2b units
    for (var i = 0; i < $b2bUnitArray.length; i++) {
      var b2bUnitArrayItem = $b2bUnitArray[i];
      var $b2bUnitName = $(b2bUnitArrayItem).data('name');
      var $searchTerm = $b2bUnitName.toUpperCase().replace(/ /g, '').search($locationInputTrimmed);

      //Check if search term exist and show the unit
      if ($searchTerm == 0) {
        $(b2bUnitArrayItem).show();
      } else {
        $(b2bUnitArrayItem).hide();
      }
    }
    //If there is no match, show error message
    if ($('.js-b2bListOfUnits').children(':visible').length === 0 && $('.js-b2bLocationInput').val().length > 0) {
      // action when all are hidden
      $noSearchResultMessage.removeClass('hide');
    } else {
      $noSearchResultMessage.addClass('hide');
    }
  },
  //Toggle location units based on value length
  handleDisplayingUnitsSearchResults: function () {
    var $locationInput = $('.js-b2bLocationInput');
    var $locationInputValueLength = $locationInput.val().length;
    var $locationUnits = $('.js-b2bListOfUnits');

    //Toggle location units based on value lenght
    if ($locationInputValueLength > 0) {
      $locationUnits.removeClass('hide');
    } else {
      $locationUnits.addClass('hide');
    }
  },
  //Handle the selection of B2B unit
  handleB2BUnitSelection: function () {
    var $selectLocationBtn = $('.js-selectB2bUnit');
    var $selectionInput = $('.js-b2bLocationInput');

    $selectLocationBtn.on('click', function () {
      var $b2bUnitId = $(this).attr('data-id');
      var $b2bUnitName = $(this).attr('data-name');
      var $b2bUnitLabel = $('.js-b2cSingUpUnitSelection');

      //Show sign up screen
      ACC.b2cPopup.handleRouting('b2c__router--sign-up');

      $selectionInput.attr('data-unit', $b2bUnitId);
      $selectionInput.val('').trigger('paste');
      $b2bUnitLabel.html($b2bUnitName);

      //Initialize validation
      ACC.b2cPopup.validateEmptyFields($('.js-b2cSignUpForm .is-required'), $('#brakesB2cRegisterForm'));
    });
  },
  //Handle login button behaviour
  handleLoginButton: function () {
    var $loginBtn = $('.js-b2cPopUpLoginBtn');

    //Show login screen
    $loginBtn.on('click', function () {
      //Initialize validation
      ACC.b2cPopup.validateEmptyFields($('.js-b2cLogInForm .is-required'), $('#loginForm'));
      //Show log-in screen
      ACC.b2cPopup.handleRouting('b2c__router--log-in');
    });
  }
};

export default b2cPopupLiveSearch;
