const order = {
  _autoload: [
    'backToOrderHistory',
    'bindMultidProduct',
    'bindResubmit',
    'bindBuyAgain',
    ['bindCancelOrder', $('.js-cancelOrder').length],
    ['bindCancelOrderConfirm', $('.js-cancelOrderConfirm').length],
    ['showOrderResubmittedModal', $('#orderResubmittedPopup').length],
    ['bindPrintOrder', $('.js-orderPrint').length],
    ['bindOrderForm', $('#orderHistoryFormDesktop').length],
    ['bindLoadMore', $('.js-orderDetailLoadMore').length],
    ['bindAmendOrder', $('.js-amendOrder').length],
    ['bindCutOffTimeOK', $('.js-cutOffTimeOK').length],
    ['bindUnavailableProductsModal', $('#unavailableProductsModal').length],
    ['bindReOrderSuccessAction', window.reOrderedSuccess],
    ['bindReorderFormSubmit', $('.js-reOrderForm').length],
    ['bindViewHistoryRecent', $('.js-orderHistoryRecent').length],
    ['bindViewOrder', $('.js-orderViewDetails').length],
    'bindRejectSubstitute',
    'bindSubstituteModal',
    ['getAmendableOrders', $('.js-deliveryPopupTrigger').length]
  ],

  orderDetailItemsTemplate: '',

  bindOrderForm: function () {
    $('#orderHistoryFormDesktop').change(this.onOrderHistoryFormChange);
    $('#orderHistoryFormMobile').change(this.onOrderHistoryFormChange);
  },

  bindBuyAgain: function () {
    $('.js-quickOrderForm').on('submit', function () {
      ACC.global.checkLoginStatus(ACC.global.doSubmitForm, $(this));
    });
  },

  bindPrintOrder: function () {
    $(document).on('click keypress', '.js-orderPrint', function (e) {
      if (ACC.global.keyPressCheck(e)) {
        ACC.global.checkLoginStatus(ACC.order.onPrintOrder, $(this));
      }
    });
  },

  onPrintOrder: function ($this) {
    var endpoint = $this.data('url');
    $.ajax({
      type: 'GET',
      url: endpoint,
      success: function (response) {
        if (response.results.length) {
          ACC.order.renderOrderPrintTable(response);
        }
      },
      error: function () {
        console.warn('Error retrieving data');
      }
    });
  },

  bindReOrderSuccessAction: function () {
    ACC.minicart.handleMiniCartComponentCollaps();
  },

  renderOrderPrintTable: function (response) {
    ACC.global.toggleSpinner(true);
    var productCodes = [];
    var data = {
      results: response.results,
      itemCount: response.pagination.totalNumberOfResults,
      details: response.details,
      order: response.order
    };
    response.results.forEach(function (item) {
      productCodes.push(item.product.code);
      if (item.product.subjectToVAT) {
        data.hasVatPricing = true;
      }
    });
    ACC.global.renderHandlebarsTemplate(data, 'jsFavouritesPrintTable', 'orders-print-template');
    ACC.productprice.getPrices(productCodes, $('.order-print__wrapper'));

    $(document).on('getPricesDone', function () {
      $('body').addClass('is-printing-wishlist');
      ACC.global.toggleSpinner(false);
      window.print();
    });
  },

  bindViewHistoryRecent: function () {
    $(document).on('click keypress', '.js-orderHistoryRecent', ACC.global.linkClickIntercept);
  },

  bindViewOrder: function () {
    $(document).on('click keypress', '.js-orderViewDetails', ACC.global.linkClickIntercept);
  },

  onOrderHistoryFormChange: function (e) {
    var $elem = $(e.target);
    var $form = $(e.currentTarget);
    // This is hack introduced due to requirement:
    // Queued is not a customer facing status, so the front-end should display 'Waiting for Confirmation' if the //order is in this status
    // BE suggested such approach, as they it would be performance demanding to do it in BE
    if ($elem.attr('id').indexOf('WAITING_FOR_CONFRMATION') > -1) {
      if ($elem.is(':checked')) {
        $form.find('.js-queued').prop('checked', true);
      } else {
        $form.find('.js-queued').prop('checked', false);
      }
    }
    $form.submit();
  },

  backToOrderHistory: function () {
    $('.orderBackBtn > button').on('click keypress', function (e) {
      if (ACC.global.keyPressCheck(e)) {
        var sUrl = $(this).data('backToOrders');
        window.location.href = encodeURI(sUrl);
      }
    });
  },

  bindCancelOrder: function () {
    $('.js-cancelOrder').on('click keypress', function (e) {
      e.preventDefault();
      if (ACC.global.keyPressCheck(e)) {
        ACC.global.checkLoginStatus(ACC.order.onCancelOrderClick, $(this));
      }
    });
  },

  onCancelOrderClick: function ($this) {
    var cancelOrderUrl = $this.data('url');
    var cancelRedirectUrl = $this.data('cancel-url');
    $.ajax({
      url: cancelOrderUrl,
      type: 'GET',
      dataType: 'json',
      success: function (response) {
        if (response.eligible === true) {
          $('#cancelOrderConfirmModal').modal('show');
        } else {
          $('#cancelErrorOrderModal').modal('show');
          $('#cancelErrorOrderModal').on('hidden.bs.modal', function () {
            window.location = cancelRedirectUrl;
          });
        }
      },
      error: function () {
        console.error('Something went wrong...');
      }
    });
  },

  bindCancelOrderConfirm: function () {
    $('.js-cancelOrderConfirm').on('click', function () {
      var cancelOrderSubmitUrl = $(this).data('submit-url');
      window.location = cancelOrderSubmitUrl;
    });
  },

  bindMultidProduct: function () {
    // link to display the multi-d grid in read-only mode
    $(document).on('click', '.js-show-multiD-grid-in-order', function (event) {
      ACC.multidgrid.populateAndShowGrid(this, event, true);
      return false;
    });

    // link to display the multi-d grid in read-only mode
    $(document).on('click', '.showMultiDGridInOrderOverlay', function (event) {
      ACC.multidgrid.populateAndShowGridOverlay(this, event);
    });
  },

  bindLoadMore: function () {
    var handlebarsPartials = [
      'orderLineEntryPartial',
      'orderDetailsLoadMorePartial',
      'picturePartial',
      'orderItemDescriptionPartial',
      'orderItemPricePartial',
      'orderPricePartial',
      'orderItemQuantityPartial'
    ];
    ACC.global.registerHandlebarsPartials(handlebarsPartials);

    ACC.order.orderDetailItemsTemplate = ACC.global.compileHandlebarTemplate('#order-detail-items');

    $(document).on('click', '.js-orderDetailLoadMore', ACC.global.checkLoginStatus.bind(null, ACC.order.loadMoreOrderDetailItems));
  },

  loadMoreOrderDetailItems: function () {
    var $loadMoreBtn = $('.js-orderDetailLoadMore');
    var endpointUrl = $loadMoreBtn.data('url');
    if (!$loadMoreBtn.length) {
      return;
    }
    $('.js_spinner').show();

    $.ajax({
      url: endpointUrl,
      type: 'GET',
      dataType: 'json',
      success: function (response) {
        ACC.order.handleLoadMoreSuccess(response, $loadMoreBtn);
        $('.js_spinner').hide();
      },
      error: function () {
        console.error('Something went wrong...');
        $('.js_spinner').hide();
      }
    });
  },

  handleLoadMoreSuccess: function (response, $loadMoreBtn) {
    if (response.pagination.currentPage < response.pagination.numberOfPages) {
      response.hasNext = true;
    }
    $loadMoreBtn.parent('.js-orderDetailLoadMoreParent').remove();

    response.results.forEach(function (entry) {
      if (
        entry.substitutedEntry &&
        entry.substitutedEntry.entryStatusCode === 'SUBSTITUTION_INITIATED' &&
        response.order.substitutionInProcess === true
      ) {
        entry.showSubstitutedEntry = true;
      } else if (
        entry.entryStatusCode !== 'SUBSTITUTION_INITIATED' &&
        entry.entryStatusCode !== 'SUBSTITUTED_AND_CANCELLED' &&
        entry.entryStatusCode !== 'SUBSTITUTED_AND_CANCEL_REQUESTED' &&
        entry.entryStatusCode !== 'SUBSTITUTED_AND_CANCELLED_BY_ADMIN' &&
        entry.entryStatusCode !== 'SUBSTITUTE_AND_CANCEL_BY_ADMIN_REQUESTED'
      ) {
        entry.showRegularEntry = true;
      }
    });
    ACC.order.renderOrderDetailItems(response);
    ACC.plp.updateLoadMoreIcons(response, true);
  },

  renderOrderDetailItems: function (orderDetailData) {
    var moreOrderDetailHtml = ACC.order.orderDetailItemsTemplate(orderDetailData);
    $('.js-orderItemList').append(moreOrderDetailHtml);
  },

  bindResubmit: function () {
    $(document).on('click keypress', '.js-reSubmit', function (e) {
      e.preventDefault();
      if (ACC.global.keyPressCheck(e)) {
        ACC.global.checkLoginStatus(ACC.order.onReSubmitOrderClick, $(this));
      }
    });
  },

  onReSubmitOrderClick: function ($resubmitButton) {
    var $reSubmitForm = $('#js-reSubmitForm');
    var endpointUrl = $resubmitButton.data('url');

    $.ajax({
      url: endpointUrl,
      type: 'GET',
      dataType: 'json',
      success: function (response) {
        if (response.eligible === true) {
          $reSubmitForm.submit();
        } else {
          ACC.order.showOrderAmmendMessageModal(null, response.messageType);
        }
      },
      error: function () {
        console.error('Something went wrong...');
      }
    });
  },

  showReSubmitOrderErrorModal: function (resubmitButton) {
    var $messageModal = $('#reSubmitErrorOrderModal');
    var removeAmendOrderUrl = resubmitButton.data('removeorder-url');
    $messageModal.one('hidden.bs.modal', function () {
      window.location = encodeURI(removeAmendOrderUrl);
    });
    $messageModal.modal('show');
  },

  bindAmendOrder: function () {
    $(document).on('click', '.js-amendOrder', ACC.order.onAmendOrderClick);
  },

  onAmendOrderClick: function (e) {
    e.preventDefault();
    var $amendBtn = $(e.target);
    ACC.global.checkLoginStatus(ACC.order.checkOrderEligibiltyForAmend, $amendBtn);
  },

  checkOrderEligibiltyForAmend: function ($amendBtn) {
    var url = '/my-account/checkOrderEligibiltyForAmend/' + $amendBtn.data('order-code');
    $.ajax({
      url: url,
      cache: false,
      type: 'GET',
      success: function (response) {
        if (response.eligible === true) {
          location.href = encodeURI($amendBtn.attr('href'));
        } else {
          ACC.order.showOrderAmmendMessageModal(null, response.messageType);
        }
      },
      error: function () {
        console.error('Something went wrong...');
      }
    });
  },

  checkOrderEligibilityForAmendOnQtyChange: function (orderData) {
    var url = '/my-account/checkOrderEligibiltyForAmend/' + orderData.orderCode;
    $.ajax({
      url: url,
      cache: false,
      type: 'GET',
      success: function (response) {
        if (response.eligible === true) {
          orderData.$productForm.submit();
        } else {
          $('.js_spinner').hide();
          ACC.cart.$modals.modal('hide');
          ACC.order.showOrderAmmendMessageModal(orderData.redirectUrl, response.messageType);
        }
      },
      error: function () {
        console.error('Something went wrong...');
      }
    });
  },

  bindReorderFormSubmit: function () {
    $('.js-reOrderForm').on('submit', function (e) {
      e.preventDefault();
      ACC.global.checkLoginStatus(ACC.global.doSubmitForm, $(this));
    });
  },

  showOrderAmmendMessageModal: function (redirectUrl, errorMessage) {
    redirectUrl = redirectUrl || null;
    var $messagePopup = $('#orderAmmendErrorPopup');
    $messagePopup.one('show.bs.modal', function () {
      var $okBtn = $(this).find('.js-cutOffTimeOK');
      $okBtn.data('redirect-url', redirectUrl);

      $messagePopup.find('.js-orderModalMessage').addClass('hide');
      $messagePopup.find("[data-message='" + errorMessage + "']").removeClass('hide');
    });
    $messagePopup.one('hide.bs.modal', function () {
      var redirectUrl = $(this).find('.js-cutOffTimeOK').data('redirect-url');
      ACC.order.handleModalRedirect(redirectUrl);
    });
    $messagePopup.modal('show');
  },

  handleModalRedirect: function (redirectUrl) {
    if (ACC.config.amendOrderPage && redirectUrl !== null) {
      location.href = encodeURI(redirectUrl);
    } else {
      location.reload();
    }
  },

  bindCutOffTimeOK: function () {
    $(document).on('click', '.js-cutOffTimeOK', function () {
      var redirectUrl = $(this).data('redirect-url');
      ACC.order.handleModalRedirect(redirectUrl);
    });
  },

  bindUnavailableProductsModal: function () {
    $('#unavailableProductsModal').modal('show');
  },

  showOrderResubmittedModal: function () {
    $('#orderResubmittedPopup').modal('show');
  },

  bindRejectSubstitute: function () {
    $(document).on('click', '.js-rejectSubstitute', function () {
      $('#acceptSubstitute').val(false);
      $('#substituteProductForm').submit();
    });
  },

  bindSubstituteModal: function () {
    $(document).on('click', '.js-showentrySubstituteModal', ACC.order.renderAndShowSubstituteModal);
  },

  renderAndShowSubstituteModal: function (e) {
    var $modalCTA = $(e.target);
    var subsituteModalTemplate = ACC.global.compileHandlebarTemplate('#entrySubstituteModalTemplate');

    var subsituteModalHTML = subsituteModalTemplate({
      originalEntry: $modalCTA.data('original-entry'),
      substituteEntry: $modalCTA.data('substitute-entry'),
      orderCode: $modalCTA.data('order-code')
    });

    $('#entrySubstituteModalHolder').html(subsituteModalHTML);
    $('#orderSubsituteModal').modal('show');
  },
  getAmendableOrders: function () {
    $.ajax({
      type: 'GET',
      url: '/my-account/amendableOrders',
      dataType: 'json',
      success: ACC.order.appendOrdersData,
      error: function () {
        console.warn('Error retrieving amendable orders data');
      }
    });
  },
  appendOrdersData: function (orders, textStatus, request) {
    var data = {
      minCount: 1,
      orders: orders.results
    };
    ACC.order.updateDeliveryCounter(request.getResponseHeader('TOTAL_NUMBER_OF_ACTIVE_ORDERS'));
    var amendableOrdersTemplate = ACC.global.compileHandlebarTemplate('#amendeble-orders-template');
    var amendableOrdersCompiled = amendableOrdersTemplate(data);
    $('.js-amendebleOrdersTarget').html(amendableOrdersCompiled);
  },
  updateDeliveryCounter: function (ordersLength) {
    document.querySelectorAll('.js-ordersCount').forEach(function (el) {
      var createSpan = document.createElement('span');
      createSpan.classList.add('icon-van-count__total');
      createSpan.innerHTML = ordersLength;

      el.appendChild(createSpan);
      el.classList.remove('hide');
    });
  }
};

export default order;
