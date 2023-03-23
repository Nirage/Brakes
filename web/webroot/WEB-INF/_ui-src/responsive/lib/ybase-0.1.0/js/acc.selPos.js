const sel = {
  _autoload: ['bindAddSection', 'handleSubmit', 'handleAutoSuggest', 'addProductCodeEntry'],
  PRODUCT_CODES: [],
  LOOP_COUNT: parseInt($('.js-loopStatus').val()),
  ADD_ROW_DATA: [],
  ADD_ROW_COUNT: 0,
  ADD_ROW_MAX: 8,
  ADD_ROW_MAX_MENU: 28,
  ADD_ROW_MAX_TILL: 28,
  ADD_ROW_GROUP: 1,
  ADD_ROW_GROUP_TILL: 7,
  CAN_BE_CONFIRMED: false,
  PRODUCT_CODE_DATA: undefined,

  bindAddSection: function () {
    $(document).on('click', '.js-add-menu-button', ACC.sel.handleAddMenuButtonClick);
    $(document).on('click', '.js-add-till-card-button', ACC.sel.handleAddTillButtonClick);
    $(document).on('click', '.js-add-row-button', ACC.sel.handleAddRowButtonClick);

    ACC.sel.bindProductCodeValues();
    ACC.sel.bindProductCode1Values();
    ACC.sel.bindRrpValues();
    ACC.sel.bindMultiPriceValues();
  },
  handleAddMenuButtonClick: function (e) {
    if (ACC.sel.LOOP_COUNT + ACC.sel.ADD_ROW_GROUP_TILL < ACC.sel.ADD_ROW_MAX_MENU) {
      var data = [];
      for (var i = 1; i <= ACC.sel.ADD_ROW_GROUP_TILL; i++) {
        data.push({ id: ACC.sel.LOOP_COUNT + i, id2: ACC.sel.LOOP_COUNT + (i + 1), name: ACC.sel.LOOP_COUNT + i, productVal: '', productVal1: '' });
      }
      ACC.sel.handleAddSection(data, 'js-add-row-sectionParent', 'a4-menus-template', ACC.sel.ADD_ROW_GROUP_TILL, e.target);
    }
  },
  handleAddTillButtonClick: function (e) {
    if (ACC.sel.LOOP_COUNT + ACC.sel.ADD_ROW_GROUP_TILL < ACC.sel.ADD_ROW_MAX_TILL) {
      var data = [];
      for (var i = 1; i <= ACC.sel.ADD_ROW_GROUP_TILL; i++) {
        data.push({ id: ACC.sel.LOOP_COUNT + i, id2: ACC.sel.LOOP_COUNT + (i + 1), name: ACC.sel.LOOP_COUNT + i, productVal: '', productVal1: '' });
      }
      ACC.sel.handleAddSection(data, 'js-add-row-sectionParent', 'till-card-template', ACC.sel.ADD_ROW_GROUP_TILL, e.target);
    }
  },
  handleAddRowButtonClick: function (e) {
    if (ACC.sel.LOOP_COUNT <= ACC.sel.ADD_ROW_MAX) {
      var data = { id: ACC.sel.LOOP_COUNT, name: ACC.sel.LOOP_COUNT, productVal: '', rrpVal: '', multiVal: '', selectedMultiPriceVal: '' };
      ACC.sel.handleAddSection(data, 'js-add-row-sectionParent', 'a3-a4-posters-template', ACC.sel.ADD_ROW_GROUP, e.target);
    }
  },
  checkDisableAddButton: function (button) {
    var $eventButton = $(button);
    if ($eventButton.hasClass('js-add-menu-button')) {
      if (ACC.sel.LOOP_COUNT + ACC.sel.ADD_ROW_GROUP_TILL >= ACC.sel.ADD_ROW_MAX_MENU) {
        $eventButton.attr('disabled', 'disabled');
      }
    } else if ($eventButton.hasClass('js-add-row-button')) {
      if (ACC.sel.LOOP_COUNT >= ACC.sel.ADD_ROW_MAX) {
        $eventButton.attr('disabled', 'disabled');
      }
    } else if ($eventButton.hasClass('js-add-till-card-button')) {
      if (ACC.sel.LOOP_COUNT + ACC.sel.ADD_ROW_GROUP_TILL >= ACC.sel.ADD_ROW_MAX_TILL) {
        $eventButton.attr('disabled', 'disabled');
      }
    }
  },
  handleAddSection: function (data, parent, template, count, eventButton) {
    if ($.isArray(data)) {
      ACC.sel.ADD_ROW_DATA = ACC.sel.ADD_ROW_DATA.concat(data);
    } else {
      ACC.sel.ADD_ROW_DATA.push(data);
    }

    ACC.global.renderHandlebarsTemplate(ACC.sel.ADD_ROW_DATA, parent, template);
    ACC.sel.LOOP_COUNT = ACC.sel.LOOP_COUNT + count;
    ACC.sel.checkDisableAddButton(eventButton);
  },
  /* On blur save the product code into JsOn*/
  bindProductCodeValues: function () {
    $(document).on('blur', '.js-rowEntryProductCode', function () {
      var productVal = $(this).val();
      var id = $(this).attr('data-id');
      var i = ACC.sel.setJsonData(id);
      ACC.sel.ADD_ROW_DATA[i].productVal = productVal;
    });
  },

  /* On blur save the product code2 into JsOn*/
  bindProductCode1Values: function () {
    $(document).on('blur', '.js-rowEntryProductCode1', function () {
      var productVal = $(this).val();
      var id = $(this).attr('data-id');
      var i = ACC.sel.setJsonData(id);
      ACC.sel.ADD_ROW_DATA[i].productVal1 = productVal;
    });
  },

  /* On blur save the rrp value into JsOn*/
  bindRrpValues: function () {
    $(document).on('blur', '.js-rowEntryRrp', function () {
      var rrpVal = $(this).val();
      var id = $(this).attr('data-id');
      var i = ACC.sel.setJsonData(id);
      ACC.sel.ADD_ROW_DATA[i].rrpVal = rrpVal;
    });
  },
  /* On blur save the multi value into JsOn*/
  bindMultiPriceValues: function () {
    $(document).on('blur', '.js-rowEntryMultiPrice', function () {
      var multiPriceVal = $(this).val();
      var id = $(this).attr('data-id');
      var i = ACC.sel.setJsonData(id);
      ACC.sel.ADD_ROW_DATA[i].selectedMultiPriceVal = multiPriceVal;
    });
  },
  setJsonData: function (id) {
    for (var i = 0; i < ACC.sel.ADD_ROW_DATA.length; i++) {
      if (ACC.sel.ADD_ROW_DATA[i].id == id) {
        return i;
      }
    }
  },

  handleSubmit: function () {
    $('.js-posSubmitForm').on('submit', function (e) {
      e.preventDefault();
      ACC.sel.bindMultiSelctedVal();
      ACC.sel.bindMenuSelectedVal();
      ACC.sel.bindPosSelectedVal();
      ACC.global.checkLoginStatus(ACC.global.doSubmitForm, $(this));
    });
  },
  /*a3-a4posters and multi buy tag form selected hidden var update*/
  bindMultiSelctedVal: function () {
    var $selectedMultiSectionEntries = $('.js-multiSectionEntry');
    $.each($selectedMultiSectionEntries, function () {
      var $selectedMulti = $(this).find('.js-posFieldSelectedMulti');
      var $productCodeVal = $(this).find('.js-productCodeMulti').val();
      var $singlePriceVal = $(this).find('.js-singlePriceSelected').val();
      var $multiPriceVal = $(this).find('.js-multiPriceSelected').val();
      if ($productCodeVal || $singlePriceVal || $multiPriceVal) {
        $selectedMulti.val(true);
      }
    });
  },
  /*a4-menuy tag form selected hidden var update*/
  bindMenuSelectedVal: function () {
    var $selectedMenuSectionEntries = $('.js-menuSectionEntry');
    $.each($selectedMenuSectionEntries, function () {
      var $productCodeVal = $(this).find('.js-productCodeMenu').val();
      var $rrpVal = $(this).find('.js-rrpMenu').val();
      var $selectedMenu = $(this).find('.js-posFieldSelectedMenu');
      if ($productCodeVal || $rrpVal) {
        $selectedMenu.val(true);
      }
    });
  },

  /*Till cards tag form selected hidden var update*/
  bindPosSelectedVal: function () {
    var $posField = $('.js-posField');
    $.each($posField, function () {
      var $val = $(this).val();
      var $fieldSectionSelected = $(this).parents('.js-posFieldSection').find('.js-posFieldSelected');
      if ($val) {
        $fieldSectionSelected.val(true);
      } else {
        $fieldSectionSelected.val(false);
      }
    });
  },

  addProductCodeEntry: function () {
    $('.js-selEntryConfirm').click(function () {
      var orderProductCodeEle = $('.js-orderSelEntryProductCode');
      $.each(orderProductCodeEle, function () {
        ACC.sel.PRODUCT_CODES.push($(this).text());
      });
      var $productCodeVal = $('.js-selProductCode').val();
      if (ACC.sel.PRODUCT_CODES.indexOf($productCodeVal) > -1) {
      } else {
        var $singlePriceVal = $('.js-selSinglePrice').val();
        var $multiPriceVal = $('.js-selMultiPrice').val();
        var $productName = $('.js-selProductName').val();

        var $orderSelEntrySection = $('.js-orderSelEnriesSection');
        var $orderSelEntries = $('.js-orderSelEnries');
        var $orderSelEntry = $orderSelEntries.eq($orderSelEntries.length - 1);
        if (($productCodeVal || $singlePriceVal || $multiPriceVal) && ACC.sel.CAN_BE_CONFIRMED) {
          $orderSelEntry.clone().appendTo($orderSelEntrySection);
          $orderSelEntries = $('.js-orderSelEnries');
          var $appendedEntry = $orderSelEntries.eq($orderSelEntries.length - 1);

          var $orderSelEntryMultiPriceEle = $appendedEntry.find('.js-orderSelEntryMultiPrice');
          var $orderSelEntrySinglePriceEle = $appendedEntry.find('.js-orderSelEntrySinglePrice');
          var $orderSelEntrySelectEle = $appendedEntry.find('.js-orderSelEntrySelect');
          var $orderSelPosIndexEle = $appendedEntry.find('.js-selPosIndex');

          ACC.sel.findinteger($orderSelEntryMultiPriceEle, $multiPriceVal);
          ACC.sel.findinteger($orderSelEntrySinglePriceEle, $singlePriceVal);
          ACC.sel.findinteger($orderSelEntrySelectEle, '');
          ACC.sel.findinteger($orderSelPosIndexEle, $productCodeVal);
          $appendedEntry.find('.js-orderSelEntryProductCode').text($productCodeVal);
          $appendedEntry.find('.js-orderSelEntryProductName').text($productName);
          $('.js-selSinglePrice').val('');
          $('.js-selMultiPrice').val('');
          $('.js-selProductName').val('');
          $('.js-selProductCode').val('');
          ACC.sel.CAN_BE_CONFIRMED = false;
        }
      }
    });
  },

  findinteger: function (ele, val) {
    var id = ele.attr('name');
    var startIndex = id.indexOf('[');
    var endIndex = id.indexOf(']');
    var length = id.length;
    var index = parseInt(id.slice(startIndex + 1, endIndex)) + 1;
    var firstPartStr = id.slice(0, startIndex + 1);
    var secondPartStr = id.slice(endIndex, length);
    var newId = firstPartStr + index + secondPartStr;
    if (ele.next('.js-orderSelEntrySelectLabel').length > 0) {
      ele.next('.js-orderSelEntrySelectLabel').attr('for', newId);
      ele.prop('checked', false);
      if (val) {
        ele.val(val);
      }
    } else {
      ele.val(val);
    }
    ele.attr('id', newId);
    ele.attr('name', newId);
  },

  handleAutoSuggest: function () {
    $('body').on('click', function () {
      ACC.sel.hideProductCodeList();
    });
    $('.js-selProductCode').blur(ACC.sel.handleProductCodeBlur);

    $(document).on('keyup', '.js-selProductCode', function () {
      ACC.global.checkLoginStatus(ACC.sel.handleProductCodeKeyup, $(this));
    });
  },

  handleProductCodeBlur: function () {
    var timeout;
    var valueSelected = false;
    if ($('#selProductCodeList').css('display') == 'none') {
      var selectedProductCode = $(this).val();
      ACC.sel.setProductVal(ACC.sel.PRODUCT_CODE_DATA, selectedProductCode);
    } else {
      $(document).on('click', '.js-listCode', function () {
        valueSelected = true;
        selectedProductCode = $(this).find('.js-listCodeVal').text();
        ACC.sel.setProductVal(ACC.sel.PRODUCT_CODE_DATA, selectedProductCode);
      });
      timeout = setTimeout(function () {
        if (valueSelected == false) {
          var selectedProductCode = $('.js-selProductCode').val();
          ACC.sel.setProductVal(ACC.sel.PRODUCT_CODE_DATA, selectedProductCode);
        }
        clearTimeout(timeout);
      }, 800);
    }
  },

  handleProductCodeKeyup: function ($input) {
    var $inputVal = $input.val();
    if ($inputVal == '') {
      $('.js-selSinglePrice').val('');
      $('.js-selMultiPrice').val('');
      ACC.sel.PRODUCT_CODE_DATA = undefined;
    }
    if ($inputVal.length > 3) {
      var $url = $('.js-productcodeSuggestUrl').val();
      var productSuggestUrl = $url + $inputVal;
      $.ajax({
        type: 'GET',
        url: productSuggestUrl,
        dataType: 'json',
        success: function (response) {
          ACC.sel.PRODUCT_CODE_DATA = response;
          if (response.length > 0) {
            ACC.global.renderHandlebarsTemplate(response, 'selProductCodeList', 'sel-productCode-list-template');
            ACC.sel.showProductCodeList();
          } else {
            ACC.sel.PRODUCT_CODE_DATA = undefined;
            ACC.sel.CAN_BE_CONFIRMED = false;
          }
        }
      });
    }
  },

  setProductVal: function (data, selectedProductCode) {
    $.each(data, function (i) {
      if (data[i].code == selectedProductCode) {
        $('.js-selSinglePrice').val(data[i].singlePrice);
        $('.js-selMultiPrice').val(data[i].multiPrice);
        $('.js-selProductName').val(data[i].name);
        $('.js-selProductCode').val(data[i].code);
        ACC.sel.CAN_BE_CONFIRMED = true;
      }
    });
    ACC.sel.hideProductCodeList();
  },
  showProductCodeList: function () {
    $('#selProductCodeList').css('display', 'block');
  },

  hideProductCodeList: function () {
    $('#selProductCodeList').css('display', 'none');
  }
};

export default sel;
