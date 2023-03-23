const b2cPopup = {
  _autoload: ['init'],
  whitelistedpage: $('.js-b2cPopUpWhitelistedPage').length > 0,
  whitelistlink: 'js-b2cPopUpWhitelistedCTA',
  //Execute on page load
  init: function () {
    //Check if we are on the brakesfoodshop site and user has not logged in
    if (ACC.config.isb2cSite === true && ACC.config.authenticated !== true) {
      //Check if the page is whitelisted or not
      if (ACC.b2cPopup.whitelistedpage) {
        ACC.b2cPopup.checkPageConditions(false);
      } else {
        ACC.b2cPopup.showPopUp();
      }
    }
  },
  //Handle pop up state on whitelisted pages
  checkPageConditions: function (state) {
    var clicked = state;

    //Remove JS associated behaviour
    if ($('.eligibility__cta').length > 0) {
      var $eligibilityCTA = $('.eligibility__cta');
      $eligibilityCTA.removeClass('js-eligibilityCta');
    }

    //Add event listener for all buttons and links on the page
    $(document.body).on('click', 'button, a, input', function (event) {
      var oneTrustContainer = $(event.target).closest('#onetrust-consent-sdk').length; // click needs to happen outside of OneTrust popup
      //Prevent default click on the page appart from the pop up elements
      if (event.target.className.indexOf(ACC.b2cPopup.whitelistlink) < 1 && !oneTrustContainer) {
        //Prevent click
        event.preventDefault();
        //Ensure the click listener execute only once
        if (clicked === false) {
          clicked = true;
          //Handle pop up state
          ACC.b2cPopup.showPopUp();
        }
      }
    });
  },
  //Check if pop up needs to appear
  showPopUp: function () {
    var $invalidResponseText = 'Do not show the pop up';
    var $body = $('body');

    $.get(ACC.config.b2cRegisterAccountEndpoint, function (data, status) {
      //Check response status and if user needs to see the pop up
      if (status == 'success' && data.indexOf($invalidResponseText) < 1) {
        //Append the pop up to the body
        $body.append(data);
        //Disable document scroll on load
        ACC.b2cPopup.handleDocumentScroll();
        //Handle adaptive labels behaviour
        ACC.b2cAdaptiveLabel.init();
        //Initialize live search
        ACC.b2cPopupLiveSearch.init();
        //Initialize sign up behaviour
        ACC.b2cSignUp.init();
        //Initialize log in behaviour
        ACC.b2cLogIn.init();
        //Initialize forgotten password behaviour
        ACC.b2cForgottenPassword.init();
        //Initialize validation
        ACC.validation.initValidation();

        $(document).on('blur change keyup', ACC.validation.formField, function () {
          ACC.b2cPopup.validateEmptyFields($('.js-b2cSignUpForm .is-required'), $('#brakesB2cRegisterForm'));
          ACC.b2cPopup.validateEmptyFields($('.js-b2cLogInForm .is-required'), $('#loginForm'));
          ACC.b2cPopup.validateEmptyFields($('.js-b2cForgottenPasswordForm .is-required'), $('#brakesB2cForgotPasswordForm'));
        });
      }
    });
  },
  //Disable scroll
  handleDocumentScroll: function () {
    var $html = $(document.documentElement);
    var $popup = $('.js-popUpOverlay');

    $html.css('overflow', 'hidden');
    $popup.css('overflow-y', 'scroll');
  },
  //Handle routing
  handleRouting: function (target) {
    var $screen = $('.js-b2cRoute');

    $screen.each(function () {
      if ($(this).attr('id') !== target) {
        $(this).addClass('hide');
      } else {
        $(this).removeClass('hide');
      }
    });
  },
  validateEmptyFields: function (selector, form) {
    var reqlength = selector.length;
    var value = selector.filter(function () {
      return this.value != '';
    });

    if (value.length >= 0 && value.length !== reqlength) {
      //Disable the form
      ACC.validation.toggleDisableSubmit(form, false);
    } else {
      //Validate form again
      ACC.validation.initValidation();
    }
  }
};

export default b2cPopup;
