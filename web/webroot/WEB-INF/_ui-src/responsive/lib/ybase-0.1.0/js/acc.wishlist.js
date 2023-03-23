const wishlist = {
  _autoload: [
    ['initWishlist', ACC.config.authenticated],
    ['initEditWishlist', $('.js-editWishlist').length],
    ['initOrderChange', $('.js-favouriteItem').length > 1],
    ['setIsWishlistDetails', $('.js-favouritesListDetails').length],
    ['setWishlistLandingPage', $('.js-favouriteListPage').length],
    ['initWishlistQuickAdd', $('.js-wishlistQuickAddForm').length]
  ],
  cartToFavourites: false,
  productCode: '',
  allWishlistIcons: '.js-displayWishlist',
  productWishlistHolder: '.js-productWishlistHolder',
  popoverContent: '.js-wishlistPopoverContent',
  wishlistCountThreshold: 20,
  allowMoveItem: false,
  isMobile: false,
  isProcessing: false,
  hasWishlistPopover: false,
  wishlistsCount: 0,
  printableImagesLoaded: false,
  validation: {
    wishlistName: {
      minLength: 1,
      maxLength: 80,
      regex: '^((?!#).)*$'
    }
  },
  editPopoverVisible: false,
  EDIT_WISHLIST: '.js-editWishlist',
  ALERT_WISHLIST: '.js-wishlistAlert',
  WISHLIST_TOTAL: '.jsTotalResults',
  FAV_ITEM: '.js-favouriteItem',
  FAV_TRIGGER: '.js-favouritesLink',
  QUICK_ADD_FORM: '.js-wishlistQuickAddForm',
  QUICK_ADD_BUTTON: '.js-wishlistQuickAddSubmitButton',
  ACTIVE_CLASS: 'is-active',
  VISIBLE_CLASS: 'is-visible',
  HIDE_CLASS: 'hide',
  activeWishlist: '',
  url: '/my-account/favourites/',
  isWishlistLandingPage: false,
  isWishlistDetails: false,
  wishlistDetails: {},
  cookies: {
    itemRemoved: 'wishlistItemRemovedCookie',
    firstWishlist: 'firstWishlistCreated',
    cartToWishlist: 'cartAddedToWishlist'
  },
  endpoints: {
    delete: '/favourite/delete',
    addToCart: '/cart/addFavourite',
    changeOrder: '/favourite/changeorder',
    changeItemOrder: '/favouriteitem/changeorder',
    deleteItem: '/favouriteitem/delete',
    saveCartAsFavourite: '/favourites/saveCartAsFavourite',
    allFavouriteLists: '/favourites/rollover'
  },
  initWishlist: function () {
    ACC.wishlist.cacheSelectors();
    ACC.wishlist.onWishlistModalOpen();
    ACC.wishlist.bindFormSubmit();
    ACC.wishlist.bindPopoverClose();
    ACC.wishlist.onWishlistModalClose();
    ACC.wishlist.onWishlistNameChange();
    ACC.wishlist.onWindowResize();
    ACC.wishlist.onAddToWishlist();
    ACC.wishlist.bindMiniFavouritesList();
    ACC.wishlist.toggleWishlist();
    ACC.wishlist.checkBreakpoint();
    ACC.wishlist.checkCookies();
    ACC.wishlist.bindAddWishlistToCartBtn();
    ACC.wishlist.bindPrintWishlist();
    ACC.wishlist.bindAddCartToWishlist();
    ACC.wishlist.bindWishlistImagesLoad();
    ACC.wishlist.bindSaveCartAsFavourites();
  },
  bindWishlistImagesLoad: function () {
    document.addEventListener(
      'load',
      function (event) {
        var elm = event.target;
        if (elm.nodeName.toLowerCase() === 'img' && $(elm).closest('#jsFavouritesPrintTable').length && !$(elm).hasClass('loaded')) {
          // or any other filtering condition
          $(elm).addClass('loaded');
          if ($('#jsFavouritesPrintTable img.loaded').length === $('#jsFavouritesPrintTable img').length) {
            ACC.wishlist.printableImagesLoaded = true;
            $(document).trigger('getWishlistImagesDone');
          }
        }
      },
      true // Capture event
    );
  },

  initEditWishlist: function () {
    ACC.wishlist.bindEditPopover();
    ACC.wishlist.bindEditActions();
    ACC.wishlist.bindAmendFormSubmit();
    ACC.wishlist.bindEditPopoversClose();
  },
  initWishlistQuickAdd: function () {
    this.bindWishlistQuickAdd();
    this.onQuickAddChange();
  },
  checkCookies: function () {
    var itemRemoved = ACC.global.getCookieByName(ACC.wishlist.cookies.itemRemoved);
    var firstWishlistCreated = ACC.global.getCookieByName(ACC.wishlist.cookies.firstWishlist);
    var cartAddedToWishlist = ACC.global.getCookieByName(ACC.wishlist.cookies.cartToWishlist);
    if (itemRemoved) {
      ACC.wishlist.displayAlert(ACC.config.wishlistItemRemoved);
      ACC.global.deleteCookieByName(ACC.wishlist.cookies.itemRemoved);
    }
    if (firstWishlistCreated) {
      ACC.wishlist.displayAlert(ACC.config.wishlistCreated);
      ACC.global.deleteCookieByName(ACC.wishlist.cookies.firstWishlist);
    }
    if (cartAddedToWishlist && cartAddedToWishlist.length) {
      ACC.wishlist.displayCartToWishlistAlert(cartAddedToWishlist);
      ACC.global.deleteCookieByName(ACC.wishlist.cookies.cartToWishlist);
    }
  },

  initOrderChange: function () {
    this.allowMoveItem = true;
  },

  bindEditActions: function () {
    $(document).on('click', '.js-favEditAction', function () {
      ACC.global.checkLoginStatus(ACC.wishlist.onEditActionClick, $(this));
    });
    // Delete product from the wishlist
    $(document).on('click', '.js-deleteWishlistItem', function () {
      ACC.global.checkLoginStatus(ACC.wishlist.onDeleteWishlistItem);
    });
    // Delete wishlist
    $(document).on('click keypress', '.js-deleteWishlist', function (e) {
      if (ACC.global.keyPressCheck(e)) {
        ACC.global.checkLoginStatus(ACC.wishlist.onDeleteWishlist);
      }
    });
  },

  onEditActionClick: function ($this) {
    var actionName = $this.attr('data-action');
    var wishlistId = $this.parents('.js-favouriteItem').attr('data-favourite');
    ACC.wishlist.setActiveWishlist(wishlistId);
    ACC.wishlist.switchActions(actionName, wishlistId, $this);
  },

  onDeleteWishlist: function () {
    var endpoint = ACC.wishlist.endpoints.delete;
    var redirectTo = '';
    var wishlistCount = $('.js-favouriteItem').length;
    // When removing wishlist from wishlist details
    // Or when removing last wishlist from wishlists listing page
    if (ACC.wishlist.isWishlistDetails || wishlistCount <= 1) {
      redirectTo = ACC.wishlist.url;
    }
    // Remove entire wishlist
    ACC.wishlist.deleteWishlistItem(endpoint, redirectTo, ACC.wishlist.activeWishlist);
  },

  onDeleteWishlistItem: function () {
    ACC.wishlist.deleteWishlistItem(ACC.wishlist.endpoints.deleteItem, null, ACC.wishlist.activeWishlist, ACC.wishlist.productCode);
  },

  switchActions: function (actionName, wishlistId, $this) {
    switch (actionName) {
      case 'amend':
        ACC.wishlist.amendWishlist(wishlistId);
        break;
      case 'delete':
        ACC.wishlist.deleteWishlistModal();
        break;
      case 'move':
        ACC.wishlist.moveWishlist($this);
        break;
      default:
        console.warn('Sorry, no action available');
    }
  },
  setWishlistId: function (wishlistId) {
    ACC.wishlist.$formWishlistId.val(wishlistId);
  },
  /**
   * Method used to delete entire wishlist or single wishlist item
   * @param {String} endpoint
   * @param {String} redirectTo
   * @param {String} wishlistId
   * @param {String} productCode
   */
  deleteWishlistItem: function (endpoint, redirectTo, wishlistId, productCode) {
    var data = {
      favouriteUid: wishlistId
    };
    if (productCode) {
      data.productCode = productCode;
    }
    $.ajax({
      type: 'POST',
      data: data,
      url: endpoint,
      success: function () {
        ACC.wishlist.handleDeleteWishListSuccess(redirectTo);
      },
      error: function () {
        console.warn('removing failed');
        $('.js-removeWishlistError').removeClass('hide');
      }
    });
  },

  handleDeleteWishListSuccess: function (redirectTo) {
    ACC.wishlist.$deleteWishlistModal.modal('hide');
    ACC.wishlist.$deleteWishlistItemModal.modal('hide');
    // TODO FE: This code may be deprecated as there is no option to delete wishlist on details page
    if (ACC.wishlist.isWishlistDetails) {
      // On Wishlist details page - if user removes wishlist we should re direct back to wishlist homepage
      if (redirectTo) {
        window.location.href = redirectTo;
        return false;
      }
      ACC.wishlist.wishlistDetails.totalNumber -= 1;
      // TODO update the total on the page
      ACC.wishlist.setWishlistTotal();
      ACC.wishlist.checkWishListDelete();
    } else {
      if (redirectTo) {
        $('.js_spinner').show();
        window.location = redirectTo;
      } else {
        ACC.wishlist.wishlistsCount -= 1;
        ACC.wishlist.toggleCreateWishlistButton();
        // remove list from DOM only if BE returns success response
        ACC.wishlist.removeFromDom(ACC.wishlist.FAV_ITEM, ACC.wishlist.activeWishlist);
        ACC.wishlist.setActiveWishlist(''); // reset active wishlist
      }
    }
  },

  checkWishListDelete: function () {
    // If user removes last item from wishlist display modal window to confirm if they want to remove entire wishlist as well
    if (ACC.wishlist.wishlistDetails.totalNumber == 0) {
      ACC.wishlist.removeFromDom(ACC.wishlist.FAV_ITEM, ACC.wishlist.activeWishlist);
      ACC.global.setCookie('wishlistItemRemovedCookie', true);
      ACC.wishlist.$deleteWishlistModal.modal('show');
    } else {
      ACC.global.setCookie('wishlistItemRemovedCookie', true);
      $('.js_spinner').show();
      var pageCalc = ACC.wishlist.wishlistDetails.totalNumber / ACC.wishlist.wishlistDetails.pageSize;
      if (pageCalc == ACC.wishlist.wishlistDetails.currentPage) {
        // go to previous page
        window.location = window.location.pathname.replace('%40', '@') + '?page=' + (pageCalc - 1);
        // Reload current location
      } else {
        // Reload current location
        window.location.reload();
      }
    }
  },

  removeFromDom: function (selector, elementId) {
    $(selector + '[data-favourite="' + elementId + '"]').remove();
  },

  deleteWishlistModal: function () {
    if (ACC.wishlist.isWishlistDetails) {
      ACC.wishlist.$deleteWishlistItemModal.modal('show');
    } else {
      ACC.wishlist.$deleteWishlistModal.modal('show');
    }
  },

  amendWishlist: function (wishlistId) {
    ACC.wishlist.setWishlistId(wishlistId);
    ACC.wishlist.hideAllPopovers(ACC.wishlist.FAV_ITEM, ACC.wishlist.ACTIVE_CLASS);
    ACC.wishlist.$amendWishlistModal.modal('show');
  },

  bindEditPopover: function () {
    $(document).on('click', ACC.wishlist.EDIT_WISHLIST, function () {
      var $this = $(this);
      var $parent = $this.parents(ACC.wishlist.FAV_ITEM);
      var isActive = $parent.hasClass(ACC.wishlist.ACTIVE_CLASS);

      if (ACC.wishlist.isWishlistDetails) {
        ACC.wishlist.setProductCode($this.attr('data-product-code'));
      }
      if (!isActive) {
        ACC.wishlist.hideAllPopovers(ACC.wishlist.FAV_ITEM, ACC.wishlist.ACTIVE_CLASS);
        $parent.addClass(ACC.wishlist.ACTIVE_CLASS);
        ACC.wishlist.editPopoverVisible = true;
      } else {
        $parent.removeClass(ACC.wishlist.ACTIVE_CLASS);
      }
    });
  },
  hideAllPopovers: function (selector, cssName) {
    ACC.wishlist.editPopoverVisible = false;
    $(selector).removeClass(cssName);
  },

  checkBreakpoint: function () {
    enquire.register('screen and (min-width:' + ACC.breakpoints.screenSmMin + ')', {
      match: function () {
        ACC.wishlist.isMobile = false;
      }
    });
    enquire.register('screen and (max-width:' + ACC.breakpoints.screenXsMax + ')', {
      match: function () {
        ACC.wishlist.isMobile = true;
      }
    });
  },

  cacheSelectors: function () {
    this.$createWishlistModal = $('#createWishlistModal');
    this.$amendWishlistModal = $('#amendWishlistModal');
    this.$deleteWishlistModal = $('#deleteWishlistModal');
    this.$deleteWishlistItemModal = $('#deleteWishlistItemModal');
    this.$addWishlistToCartModal = $('#addWishlistToCartModal');
    this.$addWishlistToCartErrorModal = $('#wishlistToCartError');
    this.$mobileWishlistHolder = $('.js-mobileWishlistHolder');
    this.$formWishlistId = $('.js-formWishlistId');
    this.$favouritesNav = $('.js-favouritesNav');
  },

  bindMiniFavouritesList: function () {
    $(document).on('click keypress', ACC.wishlist.FAV_TRIGGER, function (e) {
      e.preventDefault();
      if (ACC.global.keyPressCheck(e, 'enter_space')) {
        ACC.global.checkLoginStatus(ACC.wishlist.triggerMiniFavouritesToggle, $(this));
      }
    });
    $(document).on('click keypress', '.js-favouritesNavLink', function (e) {
      e.preventDefault();
      if (ACC.global.keyPressCheck(e)) {
        ACC.global.checkLoginStatus(ACC.wishlist.handleMiniFavourtiesNavLinkClick, $(this));
      }
    });
  },

  handleMiniFavourtiesNavLinkClick: function ($this) {
    var attributeUrl = $this.attr('href');
    if (attributeUrl) {
      window.location = attributeUrl;
    }
  },

  triggerMiniFavouritesToggle: function ($this) {
    if (ACC.wishlist.$favouritesNav.hasClass(ACC.wishlist.ACTIVE_CLASS)) {
      $this.trigger('mouseleave');
    } else {
      if (ACC.wishlist.isMobile && $('.js-favouritesNav.is-mobile').length > 0) {
        ACC.wishlist.showMiniFavourites();
      } else if (!ACC.wishlist.isMobile && $('.js-favouritesNav:not(.is-mobile)').length > 0) {
        ACC.wishlist.showMiniFavourites();
      } else {
        window.location = $this.attr('href');
      }
    }
  },

  bindMiniWishlistHoverOut: function () {
    ACC.wishlist.$favouritesNav.one('mouseleave', ACC.wishlist.hideMiniFavourites);
  },

  renderMiniFavList: function (data) {
    var miniFavsTemplate = ACC.global.compileHandlebarTemplate('#mini-favourites-template');
    var miniFavsCompiled = miniFavsTemplate(data);
    $('#jsMiniFavourites').html(miniFavsCompiled);
    $('#jsMobileMiniFavourites').html(miniFavsCompiled);
  },

  showMiniFavourites: function () {
    var $favouritesLink = $(ACC.wishlist.FAV_TRIGGER);
    var endpoint = $favouritesLink.attr('data-mini-favourites-url');
    var $favouritesContainer = $('.js-favouritesContainer');
    $.ajax({
      type: 'GET',
      url: endpoint,
      dataType: 'JSON',
      success: function (response) {
        if (response.sessionExpired) {
          window.location = response.redirectURL;
        } else {
          ACC.wishlist.renderMiniFavList(response.favourites);
          $(ACC.wishlist.ALERT_WISHLIST).addClass(ACC.wishlist.HIDE_CLASS);
          $('body').addClass('minifav-active');
          $favouritesContainer.removeClass('hide');
          ACC.wishlist.$favouritesNav.addClass(ACC.wishlist.ACTIVE_CLASS);
          ACC.wishlist.bindMiniWishlistHoverOut();
        }
      },
      error: function () {
        console.warn('Error retrieving B2B Favourites list');
        ACC.global.checkLoginStatus();
      }
    });
  },
  hideMiniFavourites: function () {
    var $favouritesContainer = $('.js-favouritesContainer');
    $favouritesContainer.addClass('hide');
    ACC.wishlist.$favouritesNav.removeClass(ACC.wishlist.ACTIVE_CLASS);
    $('body').removeClass('minifav-active');
  },
  getWishlist: function ($wishlistHolder, productCode, $clickedEl) {
    var endpoint = '/favourites/rollover/add/BrakesAddToFavouritesComponent/' + productCode;
    $.ajax({
      type: 'GET',
      url: endpoint,
      success: function (response) {
        $wishlistHolder.html(response).addClass(ACC.wishlist.VISIBLE_CLASS);
        $('body').addClass('has-wishlist');
        $clickedEl.addClass(ACC.wishlist.ACTIVE_CLASS);
        ACC.wishlist.hasWishlistPopover = true;
      },
      error: function () {
        console.warn('Error retrieving');
        ACC.global.checkLoginStatus();
      }
    });
  },
  onWindowResize: function () {
    window.addEventListener('resize', debounce(ACC.wishlist.closeAllPopovers.bind(this), 200));
  },
  bindEditPopoversClose: function () {
    $(document).on('click', function (e) {
      var POPOVER_CLASS = '.js-editWishlistContainer';
      var EDIT_WISHLIST_CLASS = '.js-editWishlist';
      var $popover = $(POPOVER_CLASS);
      if (!$popover.is(e.target) && $(e.target).parents(POPOVER_CLASS).length == 0 && $(e.target).parents(EDIT_WISHLIST_CLASS).length == 0) {
        if (ACC.wishlist.editPopoverVisible) {
          ACC.wishlist.hideAllPopovers(ACC.wishlist.FAV_ITEM, ACC.wishlist.ACTIVE_CLASS);
        }
      }
    });
  },

  bindPopoverClose: function () {
    $(document).on('click', function (e) {
      var $container = $(ACC.wishlist.productWishlistHolder);
      if (!$container.is(e.target) && $container.has(e.target).length === 0) {
        if (ACC.wishlist.hasWishlistPopover && !ACC.wishlist.isMobile) {
          ACC.wishlist.closeAllPopovers();
        }
      }
    });
    $(document).on('click', '.js-wishlistPopoverClose', function () {
      ACC.wishlist.closeAllPopovers();
    });
  },

  closeAllPopovers: function () {
    $('body').removeClass('has-wishlist');
    $(ACC.wishlist.allWishlistIcons).removeClass(ACC.wishlist.ACTIVE_CLASS);
    $(ACC.wishlist.productWishlistHolder).html('').removeClass(ACC.wishlist.VISIBLE_CLASS); // clear all placeholders
    ACC.wishlist.$mobileWishlistHolder.html('').removeClass(ACC.wishlist.VISIBLE_CLASS); // clear all placeholders
    $(ACC.wishlist.popoverContent).removeClass('response-msg show-success show-error');
    ACC.wishlist.hasWishlistPopover = false;
  },

  toggleWishlist: function () {
    $(document).on('click keypress', '.js-displayWishlist', function (e) {
      e.preventDefault();
      if (ACC.global.keyPressCheck(e)) {
        ACC.global.checkLoginStatus(ACC.wishlist.handleDisplayWishlist, $(this));
      }
    });
  },

  handleDisplayWishlist: function ($this) {
    var isActive = $this.hasClass(ACC.wishlist.ACTIVE_CLASS);
    var productCode = $this.attr('data-product-id');
    var $desktopWishlistHolder = $this.parents('.js-userActions').find(ACC.wishlist.productWishlistHolder);
    ACC.wishlist.setProductCode(productCode);
    ACC.wishlist.closeAllPopovers();
    var $wishlistHolder = ACC.wishlist.isMobile ? ACC.wishlist.$mobileWishlistHolder : $desktopWishlistHolder;

    if (!isActive) {
      ACC.wishlist.getWishlist($wishlistHolder, productCode, $this);
    }
  },
  setProductCode: function (code) {
    this.productCode = code;
  },
  setActiveWishlist: function (wishlistId) {
    ACC.wishlist.activeWishlist = wishlistId;
  },
  closeWishlistModal: function ($modal) {
    $modal.modal('hide');
  },
  onWishlistModalClose: function () {
    ACC.wishlist.$createWishlistModal.on('hidden.bs.modal', function () {
      $(this).find('.js-newWishlistName').val('');
      ACC.wishlist.toggleNameError(false);
    });
    ACC.wishlist.$amendWishlistModal.on('hidden.bs.modal', function () {
      $(this).find('.js-amendWishlistName').val('');
    });
    ACC.wishlist.$addWishlistToCartModal.on('hidden.bs.modal', function () {
      $('.js-addWishlistToCartError').addClass('hide');
    });
    ACC.wishlist.$addWishlistToCartErrorModal.on('hide.bs.modal', function () {
      window.location.reload();
    });
  },
  onWishlistModalOpen: function () {
    ACC.wishlist.$createWishlistModal.on('show.bs.modal', function () {
      $('.js-newWishlistProductCode').val(ACC.wishlist.productCode);
      $(ACC.wishlist.productWishlistHolder).removeClass(ACC.wishlist.VISIBLE_CLASS);
      $('body').removeClass('has-wishlist');
    });
  },
  bindAmendFormSubmit: function () {
    $('.js-amendWishListNameForm').on('submit', ACC.wishlist.onAmendFormSubmit);
  },
  bindFormSubmit: function () {
    $('.js-createWishForm').on('submit', ACC.wishlist.onFormSubmit);
  },
  onAmendFormSubmit: function (e) {
    e.preventDefault();
    var $this = $(this);
    var method = $this.attr('method');
    var endpoint = $this.attr('action');
    var wishlistId = ACC.wishlist.$formWishlistId.val();
    var data = {
      favouriteName: $this.find('.js-amendWishlistName').val(),
      favouriteUid: $this.find('.js-formWishlistId').val()
    };
    if (data.favouriteName !== '') {
      $.ajax({
        type: method,
        url: endpoint,
        data: data,
        dataType: 'json',
        success: function (response) {
          if (response.statusCode == 'success') {
            ACC.wishlist.updateWishlistName(data.favouriteName, wishlistId, response.uid);
            ACC.wishlist.closeWishlistModal(ACC.wishlist.$amendWishlistModal);
          }
          if (response.statusCode == 'failed') {
            ACC.wishlist.toggleExistingListError(ACC.wishlist.$amendWishlistModal, true, response.statusMessage);
          }
          if (response.ERROR == 'favourite.name.exceeds.max.length') {
            $this.find('.js-maxError').removeClass('hide');
            $this.find('.js-emptyError').addClass('hide');
            $this.find('.js-errorMsg').removeClass('hide');
          }
        },
        error: function () {
          console.warn('Error amending wishlist name');
          ACC.global.checkLoginStatus();
        }
      });
    } else {
      // set error for empty wishlist
      $this.find('.js-maxError').addClass('hide');
      $this.find('.js-emptyError').removeClass('hide');
      $this.find('.js-errorMsg').removeClass('hide');
    }
  },
  updateWishlistName: function (newName, wishlistId, newId) {
    var newUrl = '/my-account/favourites/' + newId;
    var newRolloverUrl = '/favourite/rollover/edit/' + newId;
    var $wishlist = $('.js-favouriteItem[data-favourite="' + wishlistId + '"]');
    $wishlist.attr('data-favourite', newId);
    $wishlist.find('.js-favItemName').html(newName);
    $wishlist.find('a').attr('href', newUrl);
    $wishlist.find('.js-editWishlist').attr('data-url', newRolloverUrl);
  },
  onFormSubmit: function (e) {
    e.preventDefault();
    var $this = $(this);
    var method = $this.attr('method');
    var endpoint = $this.attr('action');
    var data = {
      name: $this.find('.js-newWishlistName').val(),
      productCode: $this.find('.js-newWishlistProductCode').val()
    };

    var isFieldValid = ACC.wishlist.validateName(data.name, ACC.wishlist.validation.wishlistName);
    if (!isFieldValid) {
      ACC.wishlist.toggleNameError(true);
    }
    if (isFieldValid) {
      ACC.wishlist.toggleNameError(false);
      $.ajax({
        type: method,
        url: endpoint,
        data: data,
        dataType: 'json',
        success: function (response) {
          if (response.statusCode == 'success' && ACC.wishlist.cartToFavourites) {
            ACC.wishlist.saveCartAsFavourite($this, response);
          }

          if (response.statusCode == 'success') {
            if (ACC.wishlist.isWishlistLandingPage) {
              if (ACC.wishlist.wishlistsCount == 0) {
                ACC.global.setCookie(ACC.wishlist.cookies.firstWishlist, true);
                window.location.reload();
              } else {
                // compile template
                var wishlistTemplate = ACC.global.compileHandlebarTemplate('#wishlist-template');
                var wishlistObj = wishlistTemplate({ uid: response.uid, name: data.name });
                $('.js-favouritesList').append(wishlistObj);
                // append it to end of list
                ACC.wishlist.wishlistsCount += 1;
                ACC.wishlist.toggleCreateWishlistButton();
                ACC.wishlist.closeWishlistModal(ACC.wishlist.$createWishlistModal);
                ACC.wishlist.displayAlert();
              }
            } else {
              ACC.wishlist.wishlistsCount += 1;
              ACC.wishlist.closeWishlistModal(ACC.wishlist.$createWishlistModal);
              ACC.wishlist.displayAlert();
              ACC.wishlist.changeFavIcon(data.productCode);
              //triggering click to close popover
              $(document).click();
            }
          }

          if (response.statusCode == 'failed') {
            ACC.wishlist.toggleExistingListError(ACC.wishlist.$createWishlistModal, true, response.statusMessage);
          }
        },
        error: function () {
          console.warn('error creating favourites list');
          ACC.global.checkLoginStatus();
        }
      });
    }
  },

  saveCartAsFavourite: function ($this, response) {
    var cartId = $('.js-cart-code').val();
    if (cartId == null) {
      cartId = $('.js-cartId').data('id');
    }
    var data = {
      wishlistName: $this.find('.js-newWishlistName').val(),
      cartCode: cartId,
      createNew: true,
      favouriteUid: response.uid
    };
    var endpoint = ACC.wishlist.endpoints.saveCartAsFavourite;

    $.ajax({
      type: 'POST',
      url: endpoint,
      data: data,
      dataType: 'json',
      success: function (response) {
        if (response === true) {
          var $cartItems = $('.js-cartItemsList').find('.js-cartItemCode');
          $cartItems.each(function () {
            var productCode = $(this).data('code');
            ACC.wishlist.changeFavIcon(productCode);
          });
        } else {
          console.warn("cart hasn't been saved to favourites");
        }
      },
      error: function () {
        console.warn('error saving cart as favourite');
        ACC.global.checkLoginStatus();
      }
    });
  },

  validateName: function (name, validationRules) {
    var isValid = false;
    var regexValue = new RegExp(validationRules.regex, 'g');
    var validRegex = regexValue.test(name);
    if (name.length >= validationRules.minLength && name.length <= validationRules.maxLength) {
      isValid = true;
    } else {
      return false;
    }
    if (!validRegex) {
      return false;
    }

    return isValid;
  },
  changeFavIcon: function (productCode) {
    var $wishlist = $(".js-displayWishlist[data-product-id='" + productCode + "']");
    var $icon = $wishlist.find('.js-wishlistIcon');
    $icon.removeClass('icon-Heart').addClass('icon-heart-filled');
  },
  displayAlert: function (customText) {
    var $wishlistAlert = $(ACC.wishlist.ALERT_WISHLIST);
    if (customText) {
      $('.js-wishlistAlertText').html(customText);
    }
    $wishlistAlert.removeClass(ACC.wishlist.HIDE_CLASS);

    setTimeout(function () {
      $wishlistAlert.addClass(ACC.wishlist.HIDE_CLASS);
    }, 5000);
  },
  toggleExistingListError: function ($modal, show, errorMsg) {
    var $formGroup = $modal.find('.js-formGroup');
    var $errorMsg = $modal.find('.js-errorMsg');
    if (errorMsg != '') {
      $errorMsg.html(errorMsg);
    }
    if (show) {
      $formGroup.addClass('has-error');
      $errorMsg.removeClass(ACC.wishlist.HIDE_CLASS);
    } else {
      $formGroup.removeClass('has-error');
      $errorMsg.addClass(ACC.wishlist.HIDE_CLASS);
    }
  },
  toggleNameError: function (show) {
    var $formGroup = ACC.wishlist.$createWishlistModal.find('.js-formGroup');
    var $errorMsg = ACC.wishlist.$createWishlistModal.find('.js-errorNameMsg');
    if (show) {
      $formGroup.addClass('has-error');
      $errorMsg.removeClass(ACC.wishlist.HIDE_CLASS);
    } else {
      $formGroup.removeClass('has-error');
      $errorMsg.addClass(ACC.wishlist.HIDE_CLASS);
    }
  },
  onWishlistNameChange: function () {
    $('.js-newWishlistName').on('keyup', function () {
      ACC.wishlist.toggleExistingListError(ACC.wishlist.$createWishlistModal, false);
      ACC.wishlist.toggleNameError(false);
    });
    $('.js-amendWishlistName').on('keyup', function () {
      ACC.wishlist.toggleExistingListError(ACC.wishlist.$amendWishlistModal, false);
    });
  },
  displayMessagePopover: function (response) {
    var responseClass = '';
    if (response == 'success') {
      responseClass = 'response-msg show-success';
    } else {
      responseClass = 'response-msg show-error';
    }
    $(ACC.wishlist.popoverContent).addClass(responseClass);
  },
  onAddToWishlist: function () {
    $(document).on('click', '.js-addToList', function (e) {
      e.preventDefault();
      var endpoint = $(this).attr('data-favourite-url');
      $.ajax({
        type: 'POST',
        url: endpoint,
        success: function (response) {
          ACC.wishlist.changeFavIcon(response.entry.product.code);
          ACC.wishlist.displayMessagePopover('success');
        },
        error: function () {
          ACC.wishlist.displayMessagePopover('error');
        }
      });
    });
  },
  setWishlistLandingPage: function () {
    this.isWishlistLandingPage = true;
    this.wishlistsCount = $('.js-favouriteItem').length;
    this.toggleCreateWishlistButton();
  },

  setIsWishlistDetails: function () {
    this.isWishlistDetails = true;
    this.wishlistDetails = window.wishlistDetails;
  },

  setWishlistTotal: function () {
    var countHTML = ACC.wishlist.wishlistDetails.totalNumber.toString() + (ACC.wishlist.wishlistDetails.totalNumber === 1 ? ' item' : ' items');
    var wishListHTML = $('<span>').addClass('jsTotalResults').text(countHTML);
    var totalParent = $(ACC.wishlist.WISHLIST_TOTAL).parent();
    totalParent.html(wishListHTML);
  },

  renderWishlist: function (response, wishlistId) {
    var handlebarsPartials = ['picturePlpPartial', 'pricePartial', 'productListerItemPricePartial'];
    ACC.global.registerHandlebarsPartials(handlebarsPartials);
    if (wishlistId != '') {
      response.activeListId = wishlistId;
    }
    // Items count update
    ACC.wishlist.totalNumber += response.results.length;
    ACC.wishlist.totalNumberOfResults = response.results.length;
    ACC.wishlist.setWishlistTotal();
    // Update wishlist grid
    ACC.global.renderHandlebarsTemplate(response, 'jsFavouritesListDetails', 'favourite-product-item-template');
  },
  addWishlistToCart: function (wishlistId) {
    var endpoint = ACC.wishlist.endpoints.addToCart;
    var data = {
      favouriteUid: wishlistId.data('uid')
    };
    $.ajax({
      type: 'POST',
      url: endpoint,
      data: data,
      success: function (response) {
        // If response contains productWrapper it means there was issue with adding products to cart
        if (response.productWrapper && response.productWrapper.length > 0) {
          var productsIds = ACC.wishlist.getProductsId(response.productWrapper);
          var errorMsg = ACC.config.addWishlistToCartFailed + productsIds;
          $('.js-errorMsgAddToCart').html(errorMsg);
          ACC.global.toggleSpinner(false);
          ACC.wishlist.$addWishlistToCartModal.modal('hide');
          ACC.wishlist.$addWishlistToCartErrorModal.modal('show');
        } else {
          if (response.gtmProductList.length > 0) {
            ACC.gtmDataLayer.updateGtmFavouritesAddListAndReload(response.gtmProductList);
          } else {
            window.location.reload();
          }
        }
      },
      error: function () {
        ACC.global.toggleSpinner(false);
        $('.js-addWishlistToCartError').removeClass(ACC.wishlist.HIDE_CLASS);
      }
    });
  },
  getProductsId: function (productsList) {
    var productsId = [];
    productsList.forEach(function (product) {
      productsId.push(' ' + product.productData.code);
    });
    return productsId;
  },
  bindAddWishlistToCartBtn: function () {
    $('.js-addWishlistToCartBtn').on('click keypress', function (e) {
      if (ACC.global.keyPressCheck(e)) {
        ACC.wishlist.$addWishlistToCartModal.modal('show');
      }
    });
    $('.js-addWishlistToCart').on('click keypress', function (e) {
      if (ACC.global.keyPressCheck(e)) {
        $('.js_spinner').show();
        ACC.global.checkLoginStatus(ACC.wishlist.addWishlistToCart, $('#js-stickyMiniBasketBoundary'));
      }
    });
  },
  moveWishlist: function ($listItem) {
    var _this = this;
    var endpoint = ACC.wishlist.endpoints.changeOrder;
    if (ACC.wishlist.isWishlistDetails) {
      endpoint = ACC.wishlist.endpoints.changeItemOrder;
    }
    var moveType = $listItem.data('move-type');
    var wishlistId = ACC.wishlist.activeWishlist;
    var $item = $listItem.parents('.js-favouriteItem');
    if (_this.isProcessing || !_this.allowMoveItem) {
      // Do not do anything if action is in process or user can't move item
      return;
    }

    _this.toggleProcessingFlag(true);
    _this.updateOrderInBackend(endpoint, moveType, wishlistId, $item);
  },
  moveWishlistItem: function ($item, moveType) {
    var $clone = $item.clone();
    var $listContainer = $('.js-favouritesList');
    switch (moveType) {
      case 'moveUp':
        $item.prev().insertAfter($item);
        break;
      case 'moveDown':
        $item.next().insertBefore($item);
        break;
      case 'moveToTop':
        $listContainer.prepend($clone);
        if (ACC.wishlist.isWishlistDetails) {
          ACC.global.toggleSpinner(true);
          window.location.reload();
        } else {
          $item.remove();
        }
        break;
      case 'moveToBottom':
        $listContainer.append($clone);
        if (ACC.wishlist.isWishlistDetails) {
          ACC.global.toggleSpinner(true);
          window.location.reload();
        } else {
          $item.remove();
        }
        break;
      default:
        console.warn('Sorry, no action available');
    }
  },
  toggleProcessingFlag: function (isProcessing) {
    this.isProcessing = isProcessing;
  },
  updateOrderInBackend: function (endpoint, moveType, wishlistId, $item) {
    var _this = this;
    var isMovingItem = false;
    var data = {
      favouriteUid: wishlistId,
      moveTo: moveType
    };

    if (ACC.wishlist.isWishlistDetails) {
      data.productCode = $item[0].dataset['id'];
      data.page = window.wishlistDetails.currentPage;
      data.sortCode = window.wishlistDetails.sortBy; // sortBy value

      if (moveType == 'moveUp') {
        if ($item.prev().length == 0) {
          isMovingItem = true;
          $('.js-loadPreviousFavourites').trigger('click');
          window.customEvents.on('moreProductsLoaded', function () {
            $item.prev().insertAfter($item);
            _this.toggleProcessingFlag(false);
          });
        }
      }
      if (moveType == 'moveDown') {
        if ($item.next().length == 0) {
          isMovingItem = true;
          $('.js-loadNextFavourites').trigger('click');
          window.customEvents.on('moreProductsLoaded', function () {
            $item.next().insertBefore($item);
            _this.toggleProcessingFlag(false);
          });
        }
      }
    }

    if (!isMovingItem) {
      ACC.wishlist.moveDomItem($item, moveType, data, endpoint);
    }
  },
  moveDomItem: function ($item, moveType, data, endpoint) {
    var _this = this;
    $.ajax({
      type: 'POST',
      data: data,
      url: endpoint,
      success: function () {
        _this.toggleProcessingFlag(false);
        _this.moveWishlistItem($item, moveType);
        _this.hideAllPopovers(ACC.wishlist.FAV_ITEM, ACC.wishlist.ACTIVE_CLASS);
      },
      error: function () {
        console.warn('Error retrieving data');
        ACC.global.checkLoginStatus();
      }
    });
  },

  onQuickAddChange: function () {
    $('.js-wishlistQuickAddProductCode').on('change keyup', function () {
      var $this = $(this);
      ACC.validation.validateField($this.attr('id'), $this.val(), 'quickaddinput');
      var $formGroup = $(this).parents('.js-formGroup');
      if ($formGroup.hasClass('has-error')) {
        ACC.wishlist.quickAddErrorToggle(false, $formGroup);
        $(ACC.wishlist.QUICK_ADD_BUTTON).attr('disabled', true);
      } else {
        $(ACC.wishlist.QUICK_ADD_BUTTON).attr('disabled', false);
      }
    });
  },
  /**
   *
   * @param {Boolean} hasError
   * @param {Object} $formGroup, - jQuery Object
   * @param {String} errorMsg
   */
  quickAddErrorToggle: function (showError, $formGroup, errorMsg) {
    var ERROR_CLASS = 'has-error';
    var $errorMsgContainer = $formGroup.find('.js-errorMsg');
    if (showError) {
      $formGroup.addClass(ERROR_CLASS);
      $errorMsgContainer.html(errorMsg).removeClass(ACC.wishlist.HIDE_CLASS);
    } else {
      $formGroup.removeClass(ERROR_CLASS);
      $errorMsgContainer.addClass(ACC.wishlist.HIDE_CLASS);
    }
  },

  bindWishlistQuickAdd: function () {
    $(ACC.wishlist.QUICK_ADD_FORM).on('submit', function (e) {
      e.preventDefault();
      ACC.global.checkLoginStatus(ACC.wishlist.onWishListQuickAdd, $(this));
    });
  },

  onWishListQuickAdd: function ($form) {
    var $formGroup = $form.find('.js-formGroup');
    ACC.global.toggleSpinner(true);
    $.ajax({
      type: $form.attr('method'),
      url: $form.attr('action'),
      data: $form.serialize(),
      success: function (response) {
        if (response.statusCode == 'success') {
          window.location.reload();
        } else {
          ACC.global.toggleSpinner(false);
          ACC.wishlist.quickAddErrorToggle(true, $formGroup, response.statusMessage);
        }
      },
      error: function () {
        ACC.global.toggleSpinner(false);
        console.warn('There was error submitting form');
      }
    });
  },

  toggleCreateWishlistButton: function () {
    var $btn = $('.js-createNewWishlistBtn');
    if (ACC.wishlist.wishlistsCount < ACC.wishlist.wishlistCountThreshold) {
      $btn.attr('disabled', false);
    } else {
      $btn.attr('disabled', true);
    }
  },
  renderPrintTable: function (response) {
    ACC.global.toggleSpinner(true);
    var productCodes = [];
    var data = {
      results: response.results,
      itemCount: response.pagination.totalNumberOfResults,
      details: response.details
    };
    response.results.forEach(function (item) {
      productCodes.push(item.product.code);
    });
    ACC.global.renderHandlebarsTemplate(data, 'jsFavouritesPrintTable', 'favourites-print-template');
    ACC.productprice.getPrices(productCodes, $('.wishlist-print__wrapper'));

    $(document).on('getPricesDone', function () {
      if (ACC.wishlist.printableImagesLoaded) {
        ACC.wishlist.showWishlistPrint();
      } else {
        // wait for images to load
        $(document).on('getWishlistImagesDone', function () {
          ACC.wishlist.showWishlistPrint();
        });
      }
    });
  },
  showWishlistPrint: function () {
    $('body').addClass('is-printing-wishlist');
    $(document).off('getPricesDone');
    $(document).off('getWishlistImagesDone');
    ACC.global.toggleSpinner(false);
    window.print();
  },

  bindPrintWishlist: function () {
    $('.js-wishlistPrint').on('click keypress', function (e) {
      if (ACC.global.keyPressCheck(e)) {
        ACC.global.checkLoginStatus(ACC.wishlist.onWishlistPrint);
      }
    });
  },

  onWishlistPrint: function () {
    var endpoint = window.location.pathname + '/results?show=All';
    ACC.wishlist.printableImagesLoaded = false;
    $.ajax({
      type: 'GET',
      url: endpoint,
      success: function (response) {
        if (response.results.length) {
          ACC.wishlist.renderPrintTable(response);
        }
      },
      error: function () {
        console.warn('Error retrieving data');
        ACC.global.checkLoginStatus();
      }
    });
  },

  togglePopoverActions: function (scrollToId) {
    var ACTIONS_CONTENT = '.js-cartHeaderActionsContent';
    $(ACTIONS_CONTENT).removeClass(ACC.wishlist.VISIBLE_CLASS);
    $(ACTIONS_CONTENT + '[data-id="' + scrollToId + '"]').addClass(ACC.wishlist.VISIBLE_CLASS);
    // On Cart page // desktop
    $('.js-changeActionView').removeClass(ACC.wishlist.ACTIVE_CLASS);
  },
  bindAddCartToWishlist: function () {
    var _this = this;
    var saveCartAsFavourites = '.js-saveCartAsFavourites';

    $(document).on('cartActionsToggle', function (event, arg1) {
      if (arg1 == 'close') {
        _this.togglePopoverActions('normal');
      }
    });
    $(document).on('click', '.js-addCartToWishlist', function () {
      var $this = $(this);
      var wishlistId = $this.data('favourite-id');
      var wishlistName = $this.data('favourite-name');
      var cartId = $('.js-cart-code').val();
      if (cartId == null) {
        cartId = $('.js-cartId').data('id');
      }
      _this.addToExistingWishlist(wishlistId, wishlistName, cartId);
    });

    $(saveCartAsFavourites).on('click', function () {
      var popover = '.cart-header__wishlist-holder';
      var $popover = $(popover);

      $popover.toggleClass('hide');
      if ($popover.hasClass('hide')) {
        ACC.global.unbindWatchForClickOutside(saveCartAsFavourites, popover);
      } else {
        $.ajax({
          type: 'GET',
          url: ACC.wishlist.endpoints.allFavouriteLists,
          success: function (response) {
            _this.compileAddWishlistToCart(response);
            ACC.global.bindWatchForClickOutside(saveCartAsFavourites, popover);
          },
          error: function () {
            console.warn('Error retrieving all favourite lists');
            ACC.global.checkLoginStatus();
          }
        });
      }
    });

    $(document).on('click', '.js-changeActionView', function () {
      var $this = $(this);
      var scrollToId = $this.data('target');

      if (scrollToId == 'normal') {
        _this.togglePopoverActions(scrollToId);
      }
      if (scrollToId == 'favourites') {
        _this.renderAddWishlistToCart(scrollToId);
      }
      if (scrollToId == 'popover') {
        _this.renderAddWishlistToCart(null, $this);
      }
    });
  },

  renderAddWishlistToCart: function (scrollToId, $this) {
    var _this = this;
    var endpoint = ACC.wishlist.endpoints.allFavouriteLists;
    $.ajax({
      type: 'GET',
      url: endpoint,
      success: function (response) {
        _this.compileAddWishlistToCart(response);
        if (scrollToId) {
          _this.togglePopoverActions(scrollToId);
        } else {
          $this.addClass(ACC.wishlist.ACTIVE_CLASS);
        }
      },
      error: function () {
        console.warn('Error retrieving all favourite lists');
        ACC.global.checkLoginStatus();
      }
    });
  },
  compileAddWishlistToCart: function (data) {
    var favouritesListTemplate = ACC.global.compileHandlebarTemplate('#favourites-list-template');
    var favouritesListCompiled = favouritesListTemplate(data);
    $('.js-wishlistHolder').html(favouritesListCompiled);
  },
  displayCartToWishlistAlert: function (wishlistName) {
    var $wishlistAlert = $('.js-cartToWishlistAlert');
    var HIDE_CLASS = 'hide';
    $wishlistAlert.find('.js-wishlistName').html(wishlistName);
    $wishlistAlert.removeClass(HIDE_CLASS);

    setTimeout(function () {
      $wishlistAlert.addClass(HIDE_CLASS);
    }, 5000);
  },
  addToExistingWishlist: function (wishlistId, wishlistName, cartId) {
    var _this = this;
    $.ajax({
      type: 'POST',
      url: ACC.wishlist.endpoints.saveCartAsFavourite,
      data: {
        favouriteUid: wishlistId,
        cartCode: cartId,
        createNew: false,
        wishlistName: ''
      },
      success: function (response) {
        if (response) {
          // All products were added t wishlist
          // Reload the page and display message

          ACC.global.setCookie(ACC.wishlist.cookies.cartToWishlist, wishlistName);
          window.location.reload();
        } else {
          // All products are already in favourites list - no need to reload page
          _this.displayCartToWishlistAlert(wishlistName);
        }
      },
      error: function () {
        console.warn('Error addToExistingWishlist');
      }
    });
  },
  bindSaveCartAsFavourites: function () {
    $(document).on('click', '.js-saveCartAsFavourites', function () {
      ACC.wishlist.cartToFavourites = true;
    });
  }
};

export default wishlist;
