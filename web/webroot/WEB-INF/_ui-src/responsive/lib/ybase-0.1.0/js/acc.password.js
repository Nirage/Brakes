const password = {
  _autoload: [['initShowPassword', $('.js-formFieldPassword').length != 0]],

  $fieldPassword: $('.js-formFieldPassword'),

  initShowPassword: function () {
    var $showPassword = $('.js-showPassword'),
      showMsg = $showPassword.data('show'),
      hideMsg = $showPassword.data('hide');
    ACC.password.$fieldPassword.val('');
    $(document).on('click', '.js-showPassword', ACC.password.toggleShowPassword.bind($showPassword, showMsg, hideMsg));
  },

  toggleShowPassword: function (showMsg, hideMsg, e) {
    var $showPasswordCTA = $(e.currentTarget);
    if ($showPasswordCTA.data('hidden') === true) {
      ACC.password.showPassword(hideMsg, $showPasswordCTA);
    } else {
      ACC.password.hidePassword(showMsg, $showPasswordCTA);
    }
  },

  showPassword: function (hideMsg, $showPasswordCTA) {
    $showPasswordCTA.parents('.js-formGroup').find('.js-formFieldPassword').attr('type', 'input');
    $showPasswordCTA.data('hidden', false);
    $showPasswordCTA.html(hideMsg);
  },

  hidePassword: function (showMsg, $showPasswordCTA) {
    $showPasswordCTA.parents('.js-formGroup').find('.js-formFieldPassword').attr('type', 'password');
    $showPasswordCTA.data('hidden', true);
    $showPasswordCTA.html(showMsg);
  }
};

export default password;
