const cartactions = {
  _autoload: [['initHeaderMenu', $('.js-cartHeaderActionsMenu').length > 0]],

  $popover: {},
  $menu: {},

  initHeaderMenu: function () {
    this.$popover = $('.js-cartHeaderActionsPopover');
    this.$menu = $('.js-cartHeaderActionsMenu');

    $(document).on('click keypress', '.js-cartHeaderActionsMenu', this.onCartMenuClickedHandler);
    $(document).on('click', this.bindPopoverClose);
  },

  onCartMenuClickedHandler: function (e) {
    if (ACC.global.keyPressCheck(e, 'enter_space')) {
      ACC.global.checkLoginStatus(ACC.cartactions.onCartMenuClickedHandlerEvent);
    }
  },

  onCartMenuClickedHandlerEvent: function () {
    ACC.cartactions.$popover = $('.js-cartHeaderActionsPopover');
    ACC.cartactions.$menu = $('.js-cartHeaderActionsMenu');
    ACC.cartactions.$menu.toggleClass('is-active');

    //show popover
    ACC.cartactions.$popover.toggleClass('hide');
  },
  bindPopoverClose: function (e) {
    var $container = ACC.cartactions.$popover;
    var isModal = $(e.target).hasClass('modal') || $(e.target).parents('.modal').length > 0;
    var isMenuBtn = ACC.cartactions.$menu.is(e.target);

    if (!$container.is(e.target) && $container.has(e.target).length === 0 && !isMenuBtn && !isModal) {
      ACC.cartactions.$popover.addClass('hide');
      ACC.cartactions.$menu.removeClass('is-active');
      $(document).trigger('cartActionsToggle', ['close']);
    }
  },

  unbindEventListeners: function () {
    $(document).off('click', '.js-cartHeaderActionsMenu', this.onCartMenuClickedHandler);
    $(document).off('click', this.bindPopoverClose);
  }
};

export default cartactions;
