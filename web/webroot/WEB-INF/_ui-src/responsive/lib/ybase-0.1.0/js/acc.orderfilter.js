const orderfilter = {
  _autoload: [['initOrderFilter', $('.js-orderFilterBtn').length]],

  $orderFilterBtn: '',
  $orderFilterContent: '',
  $orderFilterContentHide: '',
  $orderFilterByCheckbox: '',

  initOrderFilter: function () {
    this.$orderFilterBtn = $('.js-orderFilterBtn');
    this.$orderFilterContent = $('.js-orderFilterContent');
    this.$orderFilterContentHide = $('.js-orderFilterContentHide');
    this.$orderFilterByCheckbox = $('.js-orderFilterByCheckbox');

    this.$orderFilterBtn.on('click', this.showOrderFilterContent);
    this.$orderFilterContentHide.on('click', this.hideOrderFilterContent);
    $(document).on('click', this.onClickOutside);
  },

  showOrderFilterContent: function (e) {
    e.preventDefault();
    ACC.orderfilter.$orderFilterContent.removeClass('hide');
  },

  hideOrderFilterContent: function () {
    ACC.orderfilter.$orderFilterContent.addClass('hide');
  },

  onClickOutside: function (e) {
    if (
      !ACC.orderfilter.$orderFilterBtn.is(e.target) &&
      ACC.orderfilter.$orderFilterBtn.has(e.target).length === 0 &&
      !ACC.orderfilter.$orderFilterContent.is(e.target) &&
      ACC.orderfilter.$orderFilterContent.has(e.target).length === 0
    ) {
      ACC.orderfilter.$orderFilterContent.addClass('hide');
    }
  }
};

export default orderfilter;
