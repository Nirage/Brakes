const categoryBox = {
  _autoload: [['showMoreCategory', $('.js-categoryItem').length !== 0]],

  showMoreCategory: function () {
    var $categoryItem = $('.js-categoryItem');
    var $categoryMoreBtn = $('.js-categoryMoreBtn');
    var itemState = $categoryItem.css('display');

    $categoryMoreBtn.on('click', function () {
      $categoryItem.removeClass('hide');
      $categoryMoreBtn.hide();
    });

    if (itemState !== 'block') {
      $categoryItem.removeClass('hide');
    }
  }
};

export default categoryBox;
