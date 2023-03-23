const b2cForgottenPassword = {
  //Initialize function
  init: function () {
    //Handle user forgotten password form
    ACC.b2cForgottenPassword.handleForgottenPasswordSubmitForm();
    //Handle back to log-in button
    ACC.b2cForgottenPassword.handleBackToLogInScreen();
  },

  //Handle forgotten password form
  handleForgottenPasswordSubmitForm: function () {
    $('.js-b2cForgottenPasswordSubmitBtn').on('click', function (event) {
      //Prevent default behaviour
      event.preventDefault();
      //Show spinner
      $('.js_spinner').show();
      //Construct the form data
      var formData = {
        username: $('.js-b2cForgottenEmail').val()
      };
      //Make an AJAX call to BE
      $.ajax({
        url: ACC.config.b2cForgottenPasswordEndpoint,
        type: 'POST',
        data: formData,
        success: function () {
          //Show forgotten password success message screen
          ACC.b2cPopup.handleRouting('b2c__router--forgotten-password-message');
          //Handle back to log-in screen button
          ACC.b2cForgottenPasswordMessage.init();
          //Hide spinner
          $('.js_spinner').hide();
        },
        //Handle error
        error: function (e) {
          console.log(e);
        }
      });
    });
  },
  //Handle back to log-in button
  handleBackToLogInScreen: function () {
    var $forgottenPasswordBackButton = $('.js-b2cForgottenPasswordBackBtn');

    $forgottenPasswordBackButton.on('click', function () {
      //Show log-in screen
      ACC.b2cPopup.handleRouting('b2c__router--log-in');
    });
  }
};

export default b2cForgottenPassword;
