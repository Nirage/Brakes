const sideNav = {
  _autoload: ['init'],
  IS_OPENED: 'is-opened',
  init: function () {
    this.bindClick();
    this.bindMobileView();
  },
  bindClick: function () {
    $(document).on('click', '.js-sideNavDrillDown', function () {
      var $this = $(this);
      $this.toggleClass(ACC.sideNav.IS_OPENED);
    });
  },
  bindMobileView: function () {
    enquire.register('screen and (max-width:' + ACC.breakpoints.screenXsMax + ')', {
      match: function () {
        $('.js-sideNavHeading').on('click', function () {
          $('.js-sideNavLevel1').toggleClass('is-expanded');
        });
      }
    });
  }
};

export default sideNav;
