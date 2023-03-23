const b2cLogIn = {
  //Initialize function
  init: function () {
    //Handle back button
    ACC.b2cLogIn.handleLoginBackButton();
    //Handle forgotten password link
    ACC.b2cLogIn.handleForgottenPasswordLink();
  },
  //Handle back button
  handleLoginBackButton: function () {
    var $logInBackButton = $('.js-b2cLogInBackBtn');

    $logInBackButton.on('click', function () {
      //Show live postcode search screen
      ACC.b2cPopup.handleRouting('b2c__router--postcode-search');
    });
  },
  //Handle forgotten password link
  handleForgottenPasswordLink: function () {
    var $forgottenPasswordLink = $('.js-b2cForgottenPasswordLink');

    $forgottenPasswordLink.on('click', function () {
      //Show forgotten password screen
      ACC.b2cPopup.handleRouting('b2c__router--forgotten-password-form');
      //Initialize validation for forgotten password screen
      ACC.b2cPopup.validateEmptyFields($('.js-b2cForgottenPasswordForm .is-required'), $('#brakesB2cForgotPasswordForm'));
    });
  }
};

export default b2cLogIn;
