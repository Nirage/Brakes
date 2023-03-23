const plp = {
  _autoload: [
    [
      'initLoadMoreProducts',
      ACC.config.recentPage ||
        ACC.config.plp ||
        ACC.config.promoPage ||
        ACC.config.search ||
        $('.js-scrollEnabledList').length > 0 ||
        $('.js-plpLoadMore').length ||
        $('.js-plpGrid').length
    ]
  ],
  $grid: $('.js-plpGrid'),
  $similarGrid: $('.js-similarProducts'),
  similarBtn: '',
  productsTemplate: '',
  similarProductTemplate: '',
  loadMoreBtnTemplate: '',
  $displayingCounter: $('.js-displayingCounter'),
  displayedResultsCounter: parseInt($('.js-initialNumberOfLoadedProducts').val(), 10),
  pageTitle: document.title,
  isFavourietsDetails: false,
  isRecentPurchasedProductsPage: false,
  $vatApplicableMsg: $('.js-vatApplicableMsg'),
  ENCODED_PERCENTAGE: '%25',
  ENCODED_GREATER_THAN: '%3E',
  ENCODED_APOSTROPH: '%27',
  ENCODED_PIPE: '%7C',
  ENCODED_FORWARD_SLASH: '%47',
  BtnPadding: 13,
  MaxNumberProducts: 3,

  initLoadMoreProducts: function () {
    var isFavouritesPageList = $('.js-favouritesListDetails').length;
    var isRecentPurchasedProductsList = $('.js-recentPurchasedProducts').length;
    var isFavouritesListDetails = $('#jsFavouritesListDetails').length;
    var productItemTemplate = '#product-item-template';
    var similarProductTemplate = '#similarProduct-item-template';
    var similarCarouselTemplate = '#similarCarousel-template';
    ACC.plp.setElementPositions();
    ACC.plp.getDevice();
    if (isFavouritesPageList) {
      ACC.plp.isFavourietsDetails = true;
      productItemTemplate = '#favourite-product-item-template';
    }
    if (isRecentPurchasedProductsList) {
      ACC.plp.isRecentPurchasedProductsPage = true;
    }
    if (isFavouritesListDetails) {
      ACC.plp.isFavouritesListDetailsPage = true;
    }
    ACC.plp.productsTemplate = ACC.global.compileHandlebarTemplate(productItemTemplate);
    if ($('#similarProduct-item-template').length > 0) {
      ACC.plp.similarProductTemplate = ACC.global.compileHandlebarTemplate(similarProductTemplate);
    }
    if ($('#similarCarousel-template').length > 0) {
      ACC.plp.similarCarouselTemplate = ACC.global.compileHandlebarTemplate(similarCarouselTemplate);
    }
    ACC.plp.loadMoreBtnTemplate = ACC.global.compileHandlebarTemplate('#load-more-btn-template');
    var handlebarsPartials = ['picturePlpPartial', 'pricePartial', 'productListerItemPricePartial', 'similarCarousel-template'];
    ACC.global.registerHandlebarsPartials(handlebarsPartials);
    ACC.plp.similarBtnAction();

    $(document).on('click', '.js-plpLoadMore, .js-promoPageLoadMore', ACC.plp.loadMoreProducts);
    $(document).on('click', '.js-discontinuedInfo', function (e) {
      ACC.plp.showDiscontinuedInfoSection($(this));
      e.preventDefault();
    });
    $(document).on('click', '.js-discontinuedClose', function () {
      ACC.plp.hideDiscontinuedInfoSection($(this));
    });
    $(document).on('click', '.js-outOfStockInfo', function (e) {
      ACC.plp.showoutOfStockInfoSection($(this));
      e.preventDefault();
    });
    $(document).on('click', '.js-outOfStockClose', function () {
      ACC.plp.hideoutOfStockInfoSection($(this));
    });

    $(document).on('click', '.js-productItem a', function () {
      ACC.plp.addScrollToParam($(this));
    });

    //When browser back button is clicked, we are reloading the previous page
    window.addEventListener('popstate', function () {
      location.reload();
    });

    window.debounce(ACC.plp.scrollToProduct(), 750);
  },

  showDiscontinuedInfoSection: function ($this) {
    $this.parents('.addtocart').find('.js-discontinuedInfoSection').removeClass('hide');
  },
  hideDiscontinuedInfoSection: function ($this) {
    $this.parents('.js-discontinuedInfoSection').addClass('hide');
  },
  showoutOfStockInfoSection: function ($this) {
    $this.parents('.addtocart').find('.js-outOfStockInfoSection').removeClass('hide');
  },
  hideoutOfStockInfoSection: function ($this) {
    $this.parents('.js-outOfStockInfoSection').addClass('hide');
  },

  addScrollToParam: function ($this) {
    var currentUrl = window.location.href;
    var sURLVariables = window.location.search.replace(/\?/, '');
    var urlVariablesArray = sURLVariables.split('&');
    var $productParent = $this.parents('.js-productItem');
    var productId = $productParent.attr('id');
    var productOnPage = $productParent.data('page');
    var newUrl;

    if (currentUrl.indexOf('product-' + productId) === -1) {
      // fix for unexpected empty string in urlSearch param array
      if (urlVariablesArray[0] === '') {
        urlVariablesArray = [];
      }
      // scroll param already exists
      // we need to replace the product id
      var newVariableMapping = [];

      urlVariablesArray.map(function (variableText) {
        if (variableText.indexOf('scrollTo') === -1 && variableText.indexOf('page')) {
          newVariableMapping.push(variableText);
        } else {
          if (productOnPage) {
            newVariableMapping.push('page=' + productOnPage);
          } else if (variableText.indexOf('page')) {
            newVariableMapping.push(variableText);
          }
          if (variableText.indexOf('scrollTo') === -1) {
            newVariableMapping.push('scrollTo=' + productId);
          } else {
            newVariableMapping.push(variableText);
          }
        }
      });

      newUrl = currentUrl.split('?')[0] + '?' + newVariableMapping.join('&');

      window.history.replaceState(null, ACC.plp.pageTitle, newUrl);
    }
  },

  scrollToProduct: function () {
    var scrollToId = ACC.global.getUrlParameter('scrollTo');

    if (scrollToId) {
      var offset = 223; // size of sticky header
      if ($('#' + scrollToId).length > 0) {
        // scroll element is visible
        ACC.global.scrollToElement('#' + scrollToId, 300, offset);
      } else {
        // no scrolling element found
        ACC.global.scrollToElement('body');
      }
    } else {
      //if we load more products and hit back button,
      //loaded page will be scrolled to the position of load more button (where products were last loaded)
      //Because of that we need to scroll the page on load
      ACC.global.scrollToElement('body');
    }
    ACC.plp.removeScrollToParam();
  },

  removeScrollToParam: function () {
    var urlWithoutScrollTo = ACC.global.removeUrlParam('scrollTo', window.location.href);
    window.history.replaceState(null, ACC.plp.pageTitle, urlWithoutScrollTo);
  },

  registerHandlebarsPartials: function (partials) {
    partials.forEach(registerPartial);

    function registerPartial(partialId) {
      var partial = document.getElementById(partialId);
      if (partial !== null) {
        ACC.global.brakesHandlebars.registerPartial(partialId, ACC.global.brakesHandlebars.compile(partial.innerHTML));
      }
    }
  },

  loadMoreProducts: function () {
    var $loadMoreBtn = $(this);
    var url = ACC.plp.fixLoadMoreUrl($loadMoreBtn.data('url'));
    var baseUrl = ACC.plp.fixLoadMoreUrl($loadMoreBtn.data('base-url'));
    var sortBy = $loadMoreBtn.data('sort-by');
    var action = $loadMoreBtn.data('action');
    $('.js_spinner').show();

    $.ajax({
      type: 'GET',
      url: url,
      dataType: 'json',
      success: function (response) {
        ACC.plp.handleLoadMoreSuccess(response, action, baseUrl, sortBy, $loadMoreBtn);
      },
      error: function () {
        console.error('Error retriving products list');
      }
    });
  },
  getDevice: function () {
    enquire.register('screen and (min-width:' + ACC.breakpoints.screenMdMin + ')', {
      match: function () {
        ACC.plp.MaxNumberProducts = 6;
      },
      unmatch: function () {
        ACC.plp.MaxNumberProducts = 4;
      }
    });

    // Mobile
    enquire.register('screen and (max-width:' + ACC.breakpoints.screenXsMax + ')', {
      match: function () {
        ACC.plp.MaxNumberProducts = 2;
      }
    });
  },
  fixLoadMoreUrl: function ($loadMoreUrl) {
    var $loadMoreFixed = $loadMoreUrl;
    // fix for facet sorts
    $loadMoreFixed = $loadMoreFixed.replace(/&#x3a;|%3A/g, ':');
    // fix for search percentage symbol
    // replace an encoded percentage
    $loadMoreFixed = $loadMoreFixed.replace(/&#x25;/g, ACC.plp.ENCODED_PERCENTAGE);
    // replace a percentage that does not match the encoded symbols
    $loadMoreFixed = $loadMoreFixed.replace(/%[^(%25|%3E|%3A|%27|%47|%7C)]/g, ACC.plp.ENCODED_PERCENTAGE + ':');
    // in case of regex + ":" fix remove the exra colon(:)
    // replace of this regex removes the ":" character (unknown bug).
    $loadMoreFixed = $loadMoreFixed.replace(/::/g, ':');

    // remove the encoded special characters in facet sorts
    $loadMoreFixed = $loadMoreFixed
      .replace(/(&#x20;|&#x2b;)/g, '+')
      .replace(/%257C/g, ACC.plp.ENCODED_PIPE) // pipe
      .replace(/%2527/g, ACC.plp.ENCODED_APOSTROPH) // greater than symbol
      .replace(/%253E|>/g, ACC.plp.ENCODED_GREATER_THAN); // apostrophe

    return $loadMoreFixed;
  },

  updateLoadMoreIcons: function (response, isOtherPage) {
    response.results.forEach(function (prodItem) {
      if (isOtherPage || ACC.plp.isFavourietsDetails) {
        ACC.plp.handleLoadMoreIcons(prodItem.product.productInfoIcons);
      } else {
        ACC.plp.handleLoadMoreIcons(prodItem.productInfoIcons);
      }
    });
  },

  handleLoadMoreIcons: function (iconList) {
    if (iconList) {
      iconList.forEach(function (infoItem) {
        var msgText = $('.js-icon-msg-' + infoItem).data('title');
        $('.js-icon-wrap-' + infoItem).attr('title', msgText);
      });
    }
  },
  refreshSimilarSection: function (type) {
    ACC.plp.setElementPositions();
    ACC.plp.getDevice();
    if ($('.js-similarSection').length > 0) {
      $('.js-similarSection').each(function () {
        var productCode = $(this).attr('data-id');
        var $isSimilarTabActive = $(this).find('.js-similarTab.isActiveTab');
        var $isPerfectTabActive = $(this).find('.js-perfectTab.isActiveTab');

        $(this).remove();

        if ($isSimilarTabActive.length > 0) {
          ACC.plp.handleSimilarButtonClick(productCode, null, true);
        } else if ($isPerfectTabActive.length > 0) {
          ACC.plp.handlePerfectButtonClick(productCode, null, true);
        }
      });
    }
    if ($('.js-similarProductsCarousel').length > 0) {
      $('.js-similarProductsCarousel').trigger('destroy.owl.carousel');
      $('.js-similarProductsCarousel').owlCarousel(ACC.carousel.carouselConfig['' + type + '']);
    }
  },
  similarBtnAction: function () {
    $(document).on('click', '.js-closeBtn', function () {
      var $this = $(this);
      var hasMsgClass = $this.next('.jsABLMsg').hasClass('msgShown');
      var dataCode = $(this).parents('.js-similarSection').attr('data-id');

      ACC.plp.similarSectionCloseAction($this, hasMsgClass, dataCode);
      ACC.monetate.clearSimilarProductsList();
      $this.parents('.js-similarSection').animate(
        {
          height: 0
        },
        700,
        'swing',
        function () {
          $(this).prev('.js-tabSection').fadeOut();
          $(this).next('.jsABLMsg').fadeOut();
          $(this).next().next('.js-similarProducts').fadeOut();
          $this.parents('.js-similarSection').remove();
        }
      );
    });
    $(document).on('click', '.js-discontinuedSimilarBtn', function () {
      var $similarBtn = $(this).parents('.js-productItem').find('.js-similarBtnParent').find('.js-similarBtn');
      var $perfectBtn = $(this).parents('.js-productItem').find('.js-similarBtnParent').find('.js-perfectBtn');

      if ($similarBtn.length > 0) {
        $similarBtn.trigger('click');
      } else if ($perfectBtn.length > 0) {
        $perfectBtn.trigger('click');
      }
    });
    $(document).on('click', '.js-perfectBtn', function () {
      var productCode = $(this).attr('data-code');
      ACC.plp.handlePerfectButtonClick(productCode, null, false);
    });
    $(document).on('click', '.js-outOfStockSimilarBtn', function () {
      ACC.plp.showSimilarProducts($(this));
    });
    $(document).on('click', '.js-similarTab', function () {
      var productCode = $(this).attr('data-code');
      ACC.plp.handleSimilarButtonClick(productCode, null, false);
    });
    $(document).on('click', '.js-perfectTab', function () {
      var productCode = $(this).attr('data-code');
      ACC.plp.handlePerfectButtonClick(productCode, null, false);
    });

    $(document).on('click', '.js-similarBtn', function () {
      var productCode = $(this).attr('data-code');
      ACC.plp.handleSimilarButtonClick(productCode, this, false);
    });
  },

  showSimilarProducts: function ($this) {
    var $similarBtnParent = $this.parents('.js-productItem').find('.js-similarBtnParent');
    var $similarBtn = $similarBtnParent.find('.js-similarBtn');
    var $perfectBtn = $similarBtnParent.find('.js-perfectBtn');

    if ($similarBtn.length > 0) {
      $similarBtn.trigger('click');
    } else if ($perfectBtn.length > 0) {
      $perfectBtn.trigger('click');
    }
  },
  similarSectionCloseAction: function ($this, hasMsgClass, dataCode) {
    if (hasMsgClass) {
      $('.js-alternatives').each(function () {
        if ($(this).attr('data-code') == dataCode) {
          if ($(this).parents('.js-productItem').find('.js-similarVerticalLine').hasClass('similar__verticalLine--blue')) {
            $(this).removeClass('hide');
          }
          if ($(this).parents('.js-productItem').find('.js-similarVerticalLine').hasClass('similar__verticalLine--green')) {
            $(this).next('.js-perfectBtn').removeClass('hide');
          }
          if ($(this).hasClass('similarMsgShown')) {
            var $perfectBtn = $(this).next('.js-perfectBtn');
            $(this).addClass('hide');
            $(this).attr('data-similar', 'false');
            $perfectBtn.attr('data-similar', 'false');
            $perfectBtn.addClass('col-xs-offset-6');
          }
          if ($(this).hasClass('perfectMsgShown')) {
            var $similarBtn = $(this).prev('.js-similarBtn');

            $(this).addClass('hide');
            $(this).attr('data-perfect', 'false');
            $similarBtn.attr('data-perfect', 'false');
            $(this).removeClass('col-xs-offset-6');
          }
          $(this).parents('.js-productItem').find('.js-similarVerticalLine').remove();
          $(this).parents('.js-productItem').find('.product-item--border').removeClass('product-item--similarBorder product-item--perfectBorder');
        }
      });
    } else {
      $('.js-alternatives').each(function () {
        if ($(this).attr('data-code') == dataCode) {
          if ($(this).hasClass('js-similarBtn') && $(this).attr('data-similar') == 'true') {
            $(this).removeClass('hide');
          }
          if ($(this).hasClass('js-perfectBtn') && $(this).attr('data-perfect') == 'true') {
            $(this).removeClass('hide');
          }
          if ($(this).next('.js-perfectBtn').attr('data-perfect') == 'true') {
            $(this).next('.js-perfectBtn').removeClass('hide');
          }
          $(this).parents('.js-productItem').find('.js-similarVerticalLine').remove();
          $(this).parents('.js-productItem').find('.product-item--border').removeClass('product-item--similarBorder product-item--perfectBorder');
        }
      });
    }
  },
  findAlternateSourceProduct: function (productItem) {
    var elementObj = {
      $element: '',
      position: ''
    };
    var itemPosition = productItem.attr('data-itemposition');
    var rowNumber = productItem.attr('data-rownumber');

    var firstItem = '1';
    var sameRowProducts = $('.js-product[data-rowNumber=' + rowNumber + '][data-itemposition=' + firstItem + ']');
    elementObj.$element = sameRowProducts;
    elementObj.position = itemPosition;
    return elementObj;
  },

  handleSimilarProductSucess: function (
    response,
    $element,
    productCode,
    isSimilarBtn,
    isPerfectBtn,
    $position,
    lastElementPosition,
    elementFromProductCode,
    isMiniCartClicked
  ) {
    ACC.plp.renderSimilarProducts(
      response,
      'prepend',
      'similar',
      $element,
      productCode,
      isSimilarBtn,
      isPerfectBtn,
      $position,
      lastElementPosition,
      elementFromProductCode,
      isMiniCartClicked
    );
    ACC.plp.highlightTabButtons($element, true, false, isMiniCartClicked);
  },
  handlePerfectWithProductSucess: function (
    response,
    $element,
    productCode,
    isSimilarBtn,
    isPerfectBtn,
    $position,
    lastElementPosition,
    elementFromProductCode,
    isMiniCartClicked
  ) {
    ACC.plp.renderSimilarProducts(
      response,
      'prepend',
      'perfectWith',
      $element,
      productCode,
      isSimilarBtn,
      isPerfectBtn,
      $position,
      lastElementPosition,
      elementFromProductCode,
      isMiniCartClicked
    );
    ACC.plp.highlightTabButtons($element, false, true, isMiniCartClicked);
  },

  handleLoadMoreSuccess: function (response, action, baseUrl, sortBy, $loadMoreBtn) {
    $('.js_spinner').hide();
    ACC.plp.renderMoreProducts(response, action);
    ACC.plp.updateLoadMoreIcons(response);
    if (ACC.config.plp || ACC.config.search || ACC.config.favouriteslist || ACC.config.recentPage || ACC.config.promoPage) {
      ACC.plp.updateMonetateProductCodes(response, action);
    }
    ACC.plp.renderLoadMoreBtns(response.pagination, action, $loadMoreBtn, response.currentQuery);

    if (typeof response.currentQuery != 'undefined') {
      ACC.plp.updatePageUrl(response.pagination, response.currentQuery.paginationUrl, sortBy);
    } else if (ACC.plp.isFavourietsDetails) {
      ACC.plp.updatePageUrl(response.pagination, baseUrl, sortBy);
    }

    ACC.plp.updateDisplayedResultsCounter();
    ACC.gtmDataLayer.updateGTMLoadMore(response, $loadMoreBtn);

    if (ACC.wishlist.isWishlistDetails) {
      window.wishlistDetails.currentPage = response.pagination.currentPage;
    }

    if (ACC.plp.isVatApplicableMsgHidden()) {
      var productsSubjectToVAT = response.results.filter(function (x) {
        return x.subjectToVAT === true;
      });

      if (productsSubjectToVAT.length > 0) {
        ACC.plp.$vatApplicableMsg.removeClass('hide');
      }
    }
    // Publish/Emit custom event
    window.customEvents.emit('moreProductsLoaded');
  },

  updateMonetateProductCodes: function (response, action) {
    var prodCodeList = [];
    console.log('ACTION', action);
    console.log('response', response);
    if (action === 'append') {
      prodCodeList = window.monetateProductList || [];
    } else if (action === 'replace') {
      prodCodeList = [];
    } else {
      prodCodeList = window.monetateProductList || [];
    }
    if (ACC.config.favouriteslist) {
      response.results.forEach(function (item) {
        prodCodeList.push(item.product.code);
      });
    } else {
      response.results.forEach(function (prod) {
        prodCodeList.push(prod.code);
      });
    }

    var pageId = ACC.config.pageId;
    if (ACC.config.plp) {
      pageId = 'productGrid';
    } else if (ACC.config.search) {
      pageId = 'searchGrid';
    }

    ACC.monetate.loadMore(prodCodeList, pageId);
  },

  isVatApplicableMsgHidden: function () {
    return ACC.plp.$vatApplicableMsg.hasClass('hide');
  },

  updateDisplayedResultsCounter: function () {
    ACC.plp.displayedResultsCounter = $('.js-productItem:not(.hide)').length;
    ACC.plp.$displayingCounter.text(ACC.plp.displayedResultsCounter);
  },

  updatePageUrl: function (pagination, baseUrl, sortBy) {
    var newUrl = '';
    var paginationKey = '&page=';
    var sortQuery = '';
    if (ACC.plp.isFavourietsDetails) {
      ACC.wishlist.wishlistDetails.currentPage = pagination.currentPage;
      paginationKey = '?page=';
      sortQuery = sortBy;
    }

    newUrl = ACC.plp.fixLoadMoreUrl(baseUrl) + paginationKey + pagination.currentPage + sortQuery;

    window.history.pushState(null, ACC.plp.pageTitle, newUrl);
  },

  setElementPositions: function () {
    var rowNumber = 0;
    var itemPosition = 0;
    $('.js-product').each(function () {
      if ($(this).css('clear') == 'both') {
        rowNumber += 1;
        itemPosition = 1;
        $(this).attr('data-itemPosition', itemPosition);
        $(this).attr('data-rowNumber', rowNumber);
      } else {
        itemPosition += 1;
        $(this).attr('data-itemPosition', itemPosition);
        $(this).attr('data-rowNumber', rowNumber);
      }
    });
  },
  getProductRowLength: function (rowNumber) {
    var sameRowProducts = $('.js-productItem[data-rowNumber=' + rowNumber + ']').length;
    return sameRowProducts;
  },

  renderMoreProducts: function (response, action) {
    var moreProductsHtml;
    moreProductsHtml = ACC.plp.productsTemplate(response);

    if (action === 'append') {
      ACC.plp.$grid.append(moreProductsHtml);
    } else if (action === 'replace') {
      ACC.plp.$grid.html('');
      $('.js-plpLoadMore').remove();
      ACC.plp.$grid.append(moreProductsHtml);
    } else {
      ACC.plp.$grid.prepend(moreProductsHtml);
    }
    if (ACC.productprice.discountVal) {
      ACC.productprice.recalculateProductPrices(ACC.productprice.discountVal);
    }

    ACC.promo.getProductPromos();

    ACC.product.enableAddToCartButton();
    ACC.plp.setElementPositions();
    ACC.plp.getDevice();
  },
  renderSimilarProducts: function (
    response,
    action,
    type,
    element,
    productCode,
    isSimilarBtn,
    isPerfectBtn,
    $position,
    lastElementPosition,
    elementFromProductCode,
    isMiniCartClicked
  ) {
    // STEP3 - Will be called after step2 from below
    function recalculateStep() {
      if (ACC.productprice.discountVal) {
        ACC.productprice.recalculateProductPrices(ACC.productprice.discountVal);
      }

      ACC.promo.getProductPromos();

      ACC.product.enableAddToCartButton();
    }
    var isSameProductCode = false;
    var moreProductsHtml;
    //STEP1
    if (type === 'similar' || type === 'perfectWith') {
      moreProductsHtml = ACC.plp.similarProductTemplate(response);
    }
    var carouselTemplate = ACC.plp.similarCarouselTemplate(response);

    //STEP2
    // will be called after animation
    function addSimilarProducts($similarSectionElem) {
      if (element.parents('#js-stickyMiniBasketBoundary').hasClass('is-mb-active')) {
        ACC.carousel.similarProductsMbCarousel();
      } else {
        if ($('.checkout-suggestions').length) {
          $('.js-similarProductsCarousel').owlCarousel(ACC.carousel.carouselConfig['similar-products-checkout-step-one']);
        } else {
          ACC.carousel.similarProductsCarousel();
        }
      }

      ACC.productprice.loadPrices();
      $similarSectionElem.find('.js-ga-addTrackBtn').attr('id', 'ga-' + elementStatus + '-' + productCode);
    }
    if (type === 'similar' || type === 'perfectWith') {
      var $similarSection = $('.js-plpGrid').find('.js-similarSection'); //New Req 1069 changes

      if ($similarSection.length > 0) {
        if ($similarSection.attr('data-id') == productCode) {
          isSameProductCode = true;
          $similarSection.find('.js-similarProductSection').remove();
          $similarSection.append(carouselTemplate);
          $similarSection.removeClass('hide');
          $similarSection.find('.js-similarProductSection').find('.js-similarProducts').removeAttr('style');
        } else {
          $similarSection.remove();
          element.before(moreProductsHtml);
        }
      } else {
        element.before(moreProductsHtml);
      }

      var elementWidth = element.width();
      var $tabSection = element.prev('.js-similarSection').find('.js-tabSection');
      var $closeBtn = element.prev('.js-similarSection').find('.js-closeBtn');

      var rightPosition = Math.round(ACC.plp.MaxNumberProducts / 2);
      if ($position > rightPosition) {
        $closeBtn.css('right', 'initial');
        $closeBtn.css('left', '10px');
      }
      $tabSection.css('width', elementWidth);
      $tabSection.css('left', elementWidth * ($position - 1) + ACC.plp.BtnPadding * ($position - 1));
      $tabSection.find('.js-similarTab').attr('data-code', productCode);
      $tabSection.find('.js-perfectTab').attr('data-code', productCode);
      var $similarSectionElem = element.prev('.js-similarSection');
      var elementStatus = element.attr('data-status');
      $similarSectionElem.attr('data-id', productCode);

      var $similarProductElem = element.prev('.js-similarSection').find('.js-similarProducts');
      var ablElem = element.prev('.js-similarSection').find('.jsABLMsg');
      if (isPerfectBtn === 'false') {
        $tabSection.find('.js-perfectTab').addClass('hide');
      }
      if (isSimilarBtn === 'false') {
        $tabSection.find('.js-similarTab').addClass('hide');
      }
      if (isPerfectBtn == 'true' && isSimilarBtn == 'false') {
        $tabSection.find('.js-perfectTab').addClass('col-xs-offset-6');
      } else {
        $tabSection.find('.js-perfectTab').removeClass('col-xs-col-6');
      }
      if (response.productReferences.length < 1) {
        ablElem.removeClass('hide');
        ablElem.next('.js-similarProductSection').addClass('hide');
        ablElem.addClass('msgShown');
        if (type === 'similar') {
          elementFromProductCode.addClass('similarMsgShown');
        } else if (type === 'perfectWith') {
          elementFromProductCode.addClass('perfectMsgShown');
        }
        if ($similarProductElem) {
          $similarProductElem.addClass('hide');
        }
        if ($tabSection) {
          $tabSection.addClass('hide');
        }
        addSimilarProducts($similarSectionElem);
        recalculateStep();
      } else {
        var $similarProductElemSection = element.prev('.js-similarSection');

        if ($similarProductElemSection.length > 0) {
          element.prev('.js-similarSection').find('.jsABLMsg').addClass('hide');
          element.prev('.js-similarSection').find('.jsABLMsg').next('.js-similarProductSection').removeClass('hide');
        }
        if (isSameProductCode) {
          $similarProductElem.addClass('fullHeight');

          addSimilarProducts($similarSectionElem);
          recalculateStep();
        } else {
          $similarProductElem.removeClass('hide');

          if (isMiniCartClicked) {
            $similarProductElem.show();
            addSimilarProducts($similarSectionElem);
            recalculateStep();
          } else {
            $similarProductElem.show(600, function () {
              $similarProductElem.addClass('fullHeight');
              addSimilarProducts($similarSectionElem);
              recalculateStep();
            });
          }
        }
      }
    } else {
      recalculateStep();
    }
  },

  renderLoadMoreBtns: function (pagination, action, $loadMoreBtn, currentQuery) {
    var hasPreviousPage;
    var hasNextPage;
    var moreBtnData;
    var loadMoreBtnHtml;

    hasPreviousPage = pagination.currentPage > 1 ? true : false;
    hasNextPage = pagination.currentPage < pagination.numberOfPages ? true : false;
    if (currentQuery && typeof decodeHTMLEntities == 'function') {
      currentQuery.query.value = ACC.facets.decodeHTMLEntities(currentQuery.query.value);
    }

    if (action === 'append' && hasNextPage) {
      moreBtnData = {
        action: action,
        customCSSClass: 'h-space-4',
        pageToLoadGetParam: pagination.currentPage + 1,
        currentQuery: currentQuery
      };
      loadMoreBtnHtml = ACC.plp.loadMoreBtnTemplate(moreBtnData);
      $loadMoreBtn.replaceWith(loadMoreBtnHtml);
    } else if (action === 'prepend' && hasPreviousPage) {
      moreBtnData = {
        action: action,
        customCSSClass: 'h-space-2',
        pageToLoadGetParam: pagination.currentPage - 1,
        currentQuery: currentQuery
      };
      loadMoreBtnHtml = ACC.plp.loadMoreBtnTemplate(moreBtnData);
      $loadMoreBtn.replaceWith(loadMoreBtnHtml);
    } else {
      $loadMoreBtn.remove();
    }
    if (ACC.productprice) {
      ACC.productprice.loadPrices();
    }
  },

  /**
   * Function to handle the display of similar button after the click event
   *
   * @param {number} productCode - productCode of the button clicked
   * @param {element} thisItem - If currentTarget element is available on click
   *
   */
  handleSimilarButtonClick: function (productCode, thisItem, isMiniCartClicked) {
    var elementFromProductCode;
    var productItem;
    ACC.monetate.clearSimilarProductsList();
    if (!thisItem) {
      elementFromProductCode = $('.product__listing').find("div[data-id='" + productCode + "']");
      productItem = elementFromProductCode;
      elementFromProductCode = productItem.find('.js-similarBtnParent').find('.js-similarBtn');
    } else {
      elementFromProductCode = $(thisItem);
      productItem = elementFromProductCode.parents('.js-similarBtnParent').parents('.js-productItem');
    }

    var $this = elementFromProductCode;
    var isSimilarBtn = $this.attr('data-similar');
    var isPerfectBtn = $this.attr('data-perfect');
    var $perfectBtn = $this.next('.js-perfectBtn');
    var $elementObj = ACC.plp.findAlternateSourceProduct(productItem);
    var $element = $elementObj.$element;
    var $position = $elementObj.position;

    var $similarProductElem = $('.js-plpGrid').find('.js-similarSection'); //New Req 1069 changes

    var rowNumber = productItem.attr('data-rownumber');

    var lastElementPosition = ACC.plp.getProductRowLength(rowNumber);

    if ($similarProductElem.length > 0) {
      var elemProdCode = $similarProductElem.attr('data-id');
      var $isSimilarTabActive = $similarProductElem.find('.js-similarTab.isActiveTab');
      var $closeBtn = $similarProductElem.find('.js-closeBtn');
      if ($isSimilarTabActive.length > 0 && elemProdCode == productCode) {
        $closeBtn.trigger('click');
        return;
      }
      var hasMsgClass = $closeBtn.next('.jsABLMsg').hasClass('msgShown');
      var dataCode = $closeBtn.parents('.js-similarSection').attr('data-id');

      ACC.plp.similarSectionCloseAction($closeBtn, hasMsgClass, dataCode);
    }
    $.ajax({
      url: ACC.config.alterativeBaseUrl + 'productCode=' + productCode + ACC.config.alternativeUrl,
      productCode: productCode, // serializes the form's elements.
      success: function (data) {
        ACC.plp.handleSimilarProductSucess(
          data,
          $element,
          productCode,
          isSimilarBtn,
          isPerfectBtn,
          $position,
          lastElementPosition,
          elementFromProductCode,
          isMiniCartClicked
        );

        var verticalLine = productItem.find('.js-similarVerticalLine');
        if (verticalLine) {
          verticalLine.removeClass('similar__verticalLine--blue');
          productItem.find('.product-item--border').removeClass('product-item--perfectBorder');
          if (verticalLine.length < 1) {
            productItem.append("<div class='similar__verticalLine similar__verticalLine--green js-similarVerticalLine' style='height:0'></div>");
            productItem
              .find('.js-similarVerticalLine')
              .delay(600)
              .animate(
                {
                  height: '38px'
                },
                600,
                function () {}
              );

            productItem.find('.product-item--border').animate(
              {
                borderWidth: '1px'
              },
              1200,
              function () {
                productItem.find('.product-item--border').removeClass('product-item--perfectBorder');
                productItem.find('.product-item--border').addClass('product-item--similarBorder');
                productItem.find('.product-item--border').removeAttr('style');
              }
            );
          }
          setTimeout(function () {
            //set time out added to remove lines when quick click action occurs
            $('.js-alternatives').each(function () {
              if ($(this).attr('data-code') == productCode) {
                console.log('');
              } else {
                $(this).parents('.js-productItem').find('.js-similarVerticalLine').remove();
                $(this)
                  .parents('.js-productItem')
                  .find('.product-item--border')
                  .removeClass('product-item--similarBorder product-item--perfectBorder');
              }
            });
          }, 500);
          $this.addClass('hide');
          $perfectBtn.addClass('hide');
        }
        ACC.monetate.updateProductsList(data);
      },
      error: function () {}
    });
  },

  /**
   * Function to handle the display of similar button after the click event
   *
   * @param {number} productCode - productCode of the button clicked
   * @param {element} thisItem - If currentTarget element is available on click
   *
   */
  handlePerfectButtonClick: function (productCode, thisItem, isMiniCartClicked) {
    var elementFromProductCode;
    var productItem;
    ACC.monetate.clearSimilarProductsList();

    if (!thisItem) {
      elementFromProductCode = $('.product__listing').find("div[data-id='" + productCode + "']");
      productItem = elementFromProductCode;
      elementFromProductCode = productItem.find('.js-similarBtnParent').find('.js-perfectBtn');
    } else {
      elementFromProductCode = $(thisItem);
      productItem = elementFromProductCode.parents('.js-similarBtnParent').parents('.js-productItem');
    }

    var $this = elementFromProductCode;
    var isSimilarBtn = $this.attr('data-similar');
    var isPerfectBtn = $this.attr('data-perfect');
    var $similarBtn = $this.prev('.js-similarBtn');
    var $elementObj = ACC.plp.findAlternateSourceProduct(productItem);
    var $element = $elementObj.$element;
    var $position = $elementObj.position;
    var $similarProductElem = $('.js-plpGrid').find('.js-similarSection'); //New Req 1069 changes

    var rowNumber = productItem.attr('data-rownumber');
    var lastElementPosition = ACC.plp.getProductRowLength(rowNumber);

    if ($similarProductElem.length > 0) {
      var elemProdCode = $similarProductElem.attr('data-id');
      var $closeBtn = $similarProductElem.find('.js-closeBtn');

      var isPerfectTabActive = $similarProductElem.find('.js-perfectTab.isActiveTab');
      if (isPerfectTabActive.length > 0 && elemProdCode == productCode) {
        $closeBtn.trigger('click');
        return;
      }
      var hasMsgClass = $closeBtn.next('.jsABLMsg').hasClass('msgShown');
      var dataCode = $closeBtn.parents('.js-similarSection').attr('data-id');

      ACC.plp.similarSectionCloseAction($closeBtn, hasMsgClass, dataCode);
    }

    $.ajax({
      url: ACC.config.alterativeBaseUrl + 'productCode=' + productCode + ACC.config.prfectWithUrl,
      productCode: productCode, // serializes the form's elements.
      success: function (data) {
        ACC.plp.handlePerfectWithProductSucess(
          data,
          $element,
          productCode,
          isSimilarBtn,
          isPerfectBtn,
          $position,
          lastElementPosition,
          elementFromProductCode,
          isMiniCartClicked
        );

        var verticalLine = productItem.find('.js-similarVerticalLine');
        if (verticalLine) {
          if (verticalLine.length < 1) {
            productItem.find('.product-item--border').removeClass('product-item--similarBorder');
            productItem.append("<div class='similar__verticalLine similar__verticalLine--blue js-similarVerticalLine' style='height:0'></div>");
            productItem
              .find('.js-similarVerticalLine')
              .delay(600)
              .animate(
                {
                  height: '38px'
                },
                600,
                function () {}
              );
            productItem.find('.product-item--border').animate(
              {
                borderWidth: '1px'
              },
              1200,
              function () {
                productItem.find('.product-item--border').removeClass('product-item--similarBorder');
                productItem.find('.product-item--border').addClass('product-item--perfectBorder');
                productItem.find('.product-item--border').removeAttr('style');
              }
            );
          } else {
            verticalLine.addClass('similar__verticalLine--blue slideDown');
            productItem.find('.product-item--border').animate(
              {
                borderWidth: '1px'
              },
              1200,
              function () {
                productItem.find('.product-item--border').removeClass('product-item--similarBorder');
                productItem.find('.product-item--border').addClass('product-item--perfectBorder');
                productItem.find('.product-item--border').removeAttr('style');
              }
            );
          }
        }
        setTimeout(function () {
          $('.js-alternatives').each(function () {
            if ($(this).attr('data-code') == productCode) {
              console.log('');
            } else {
              $(this).parents('.js-productItem').find('.js-similarVerticalLine').remove();
              $(this).parents('.js-productItem').find('.product-item--border').removeClass('product-item--similarBorder product-item--perfectBorder');
            }
          });
        }, 500);
        $this.addClass('hide');
        $similarBtn.addClass('hide');
        ACC.monetate.updateProductsList(data);
      },
      error: function () {
        //
      }
    });
  },

  highlightTabButtons: function (element, isSimilar, isPerfectWith, isMiniCartClicked) {
    var $jsSimilarTab = element.prev('.js-similarSection').find('.js-similarTab');
    var $jsPerfectWithTab = element.prev('.js-similarSection').find('.js-perfectTab');
    var activeClassName = 'isActiveTab';
    var removeClassFromBothTabs = function () {
      $jsSimilarTab.removeClass(activeClassName);
      $jsPerfectWithTab.removeClass(activeClassName);
    };
    if (isSimilar) {
      removeClassFromBothTabs();
      $jsSimilarTab.addClass(activeClassName);
      $jsSimilarTab.addClass('similar-products');
      if (isMiniCartClicked) {
        $jsSimilarTab.addClass('pseudoProductsfullWidth');
      } else {
        $jsSimilarTab.find('div').animate(
          {
            border: 'none'
          },
          0,
          function () {
            $jsSimilarTab.addClass('pseudoProductsfullWidth');
          }
        );
      }
    } else if (isPerfectWith) {
      removeClassFromBothTabs();
      $jsPerfectWithTab.addClass(activeClassName);
      $jsPerfectWithTab.addClass('perfect-products');
      if (isMiniCartClicked) {
        $jsPerfectWithTab.addClass('pseudoProductsfullWidth');
      } else {
        $jsPerfectWithTab.find('div').animate(
          {
            border: 'none'
          },
          0,
          function () {
            $jsPerfectWithTab.addClass('pseudoProductsfullWidth');
          }
        );
      }
    }
  }
};

export default plp;
