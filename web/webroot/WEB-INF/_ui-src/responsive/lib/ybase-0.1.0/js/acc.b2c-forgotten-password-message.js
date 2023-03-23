const b2cForgottenPasswordMessage = {
  //Initialize function
  init: function () {
    //Handle back button
    ACC.b2cForgottenPasswordMessage.handleBackToSignIn();
  },
  //Handle back button
  handleBackToSignIn: function () {
    var $signInBackButton = $('.js-b2cForgottenPasswordMessageBtn');

    $signInBackButton.on('click', function () {
      //Show log-in screen
      ACC.b2cPopup.handleRouting('b2c__router--log-in');
    });
  }
};

export default b2cForgottenPasswordMessage;
