const paginationsort = {
  _autoload: ['bindAll'],

  downUpKeysPressed: false,

  bindAll: function () {
    this.bindPaginationSort();
  },
  bindPaginationSort: function () {
    ACC.paginationsort.bindSortForm($('#sortForm1'));
    ACC.paginationsort.bindSortForm($('#sortForm2'));
  },
  bindSortForm: function (sortForm) {
    sortForm.change(function () {
      if (!ACC.paginationsort.downUpPressed) {
        var q = ACC.global.getUrlParameter('q');
        if (q != '' && q != undefined) {
          sortForm.find("[name='q']").val(q);
        }
        this.submit();
      }
      ACC.paginationsort.downUpPressed = false;
    });
  },
  sortFormIEFix: function (sortOptions, selectedOption) {
    sortOptions.keydown(function (e) {
      // Pressed up or down keys
      if (e.keyCode === 38 || e.keyCode === 40) {
        ACC.paginationsort.downUpPressed = true;
      }
      // Pressed enter
      else if (e.keyCode === 13 && selectedOption !== $(this).val()) {
        $(this).parent().submit();
      }
      // Any other key
      else {
        ACC.paginationsort.downUpPressed = false;
      }
    });
  }
};

export default paginationsort;
