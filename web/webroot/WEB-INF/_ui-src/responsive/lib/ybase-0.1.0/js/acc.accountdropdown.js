const accountdropdown = {
  _autoload: [['init', $('.js-accountDropdown').length > 0]],
  ACTIVE_CLASS: 'is-active',
  LOCK_SCROLL_CLASS: 'is-locked',
  HIDE_CLASS: 'hide',
  init: function () {
    $(document).on('click keypress', '.js-accountDropdown', function (e) {
      if (ACC.global.keyPressCheck(e)) {
        var dropDownId = $(this).data('id');
        ACC.accountdropdown.toggleAccountDropdown(dropDownId);
        ACC.accountdropdown.calcAccountDropdownHeight();
      }
    });
  },

  calcAccountDropdownHeight: function () {
    var windowHeight = $(window).height();
    var $navigationTop = $('.js-navigationTop');
    var $ASMheader = $('.ASM_header'); //js class not used becaused this part of code is generated through addon
    var navigationTopHeight = $navigationTop.height();
    var maxHeight;
    if ($ASMheader.length > 0) {
      var ASMheaderHeight = $ASMheader.height();
      maxHeight = windowHeight - navigationTopHeight - ASMheaderHeight;
    } else {
      maxHeight = windowHeight - navigationTopHeight;
    }
    var $accountDropdownContent = $('.js-accountDropdownContent');

    $accountDropdownContent.css('max-height', maxHeight);
  },

  bindWatchForClickOutside: function () {
    $(document).on('mouseup', ACC.accountdropdown.onClickOutside);
  },

  unbindWatchForClickOutside: function () {
    $(document).off('mouseup', ACC.accountdropdown.onClickOutside);
  },

  onClickOutside: function (e) {
    var $dropdown = $('.js-accountDropdown');
    var $dropdownContent = $('.js-accountDropdownContent');

    if (!$dropdown.is(e.target) && $dropdown.has(e.target).length === 0) {
      // if the target of the click isn't the container nor a descendant of the container
      if (!$dropdownContent.is(e.target) && $dropdownContent.has(e.target).length === 0) {
        $dropdown.removeClass(ACC.accountdropdown.ACTIVE_CLASS);
        $dropdownContent.addClass(ACC.accountdropdown.HIDE_CLASS);
        $('body').removeClass(ACC.accountdropdown.LOCK_SCROLL_CLASS);
      }
    }
  },
  /**
   * @param {string} dropDownId
   */
  toggleAccountDropdown: function (dropDownId) {
    var $dropdown = $(".js-accountDropdown[data-id='" + dropDownId + "']");
    var $dropdownContent = $(".js-accountDropdownContent[data-id='" + dropDownId + "']");
    var isHidden = $dropdownContent.hasClass(ACC.accountdropdown.HIDE_CLASS);
    var $body = $('body');

    // First close all dropdowns
    $('.js-accountDropdown').removeClass(ACC.accountdropdown.ACTIVE_CLASS);
    $('.js-accountDropdownContent').addClass(ACC.accountdropdown.HIDE_CLASS);

    // Open selected dropdown only
    if (isHidden) {
      $dropdownContent.removeClass(ACC.accountdropdown.HIDE_CLASS);
      $dropdown.addClass(ACC.accountdropdown.ACTIVE_CLASS);
      $body.addClass(ACC.accountdropdown.LOCK_SCROLL_CLASS);
      ACC.accountdropdown.bindWatchForClickOutside();
    } else {
      $dropdownContent.addClass(ACC.accountdropdown.HIDE_CLASS);
      $dropdown.removeClass(ACC.accountdropdown.ACTIVE_CLASS);
      $body.removeClass(ACC.accountdropdown.LOCK_SCROLL_CLASS);
      ACC.accountdropdown.unbindWatchForClickOutside();
    }
  }
};

export default accountdropdown;
