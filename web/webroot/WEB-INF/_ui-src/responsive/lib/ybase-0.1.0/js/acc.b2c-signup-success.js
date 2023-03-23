const b2cSignUpSuccess = {
  //Handle start shopping click event
  handleStartShopping: function () {
    var $startShoppingCta = $('.js-b2cPopUpStartShopping');
    //Redirect to homepage
    $startShoppingCta.on('click', function () {
      window.location.href = '/';
    });
  }
};

export default b2cSignUpSuccess;
