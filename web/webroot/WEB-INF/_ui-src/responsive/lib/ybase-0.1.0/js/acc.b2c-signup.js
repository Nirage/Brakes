const b2cSignUp = {
  //Initialize function
  init: function () {
    //Handle user sign up
    ACC.b2cSignUp.handleSignUpSubmitForm();
    //Handle back button
    ACC.b2cSignUp.handleSignUpBackButton();
    //Check if email has already been registered
    ACC.b2cSignUp.handleRegisteredEmails();
  },
  //Check if email has been registered
  handleRegisteredEmails: function () {
    var $target = '.js-signUpEmailField';

    $(document).on('focusout', $target, function () {
      //Execute the AJAX call only if the input field has no errors
      var $enteredEmail = $($target).val();
      $.ajax({
        type: 'GET',
        url: ACC.config.b2cCheckRegisterEmailEndpoint + $enteredEmail,
        dataType: 'JSON',
        success: function (response) {
          if (response === true) {
            var $formGroup = $($target).parents('.js-formGroup');
            var $errorMsgContainer = $formGroup.find('.js-errorMsg');

            $errorMsgContainer.html('Email address already registered').removeClass(ACC.validation.HIDE);
            $formGroup.removeClass(ACC.validation.IS_VALID);
            $formGroup.addClass(ACC.validation.HAS_ERROR);

            //Revalidate the form
            ACC.validation.initValidation();
          }
        },
        error: function () {
          console.warn('Error retrieving B2B Favourites list');
        }
      });
    });
  },
  //Handle sign up form
  handleSignUpSubmitForm: function () {
    $('.js-b2cSignUpSubmitBtn').on('click', function (event) {
      //Prevent default behaviour
      event.preventDefault();
      $('.js_spinner').show();
      //Construct the form data
      var formData = {
        email: $('input[name=email]').val(), //for get email
        password: $('input[name=password]').val(),
        confirmPassword: $('input[name=confirmPassword]').val(),
        b2cUnit: $('.js-b2bLocationInput').attr('data-unit')
      };
      //Make an AJAX call to BE
      $.ajax({
        url: ACC.config.b2cCheckRegisterAccountEndpoint,
        type: 'POST',
        data: formData,
        success: function () {
          //Show sign up success screen
          ACC.b2cPopup.handleRouting('b2c__router--sign-up-success');
          //Handle start shopping button behaviour
          ACC.b2cSignUpSuccess.handleStartShopping();
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
  //Handle back button
  handleSignUpBackButton: function () {
    var $signUpBackButton = $('.js-b2cSignUpBackBtn');

    $signUpBackButton.on('click', function () {
      //Show live postcode search screen
      ACC.b2cPopup.handleRouting('b2c__router--postcode-search');
    });
  }
};

export default b2cSignUp;
