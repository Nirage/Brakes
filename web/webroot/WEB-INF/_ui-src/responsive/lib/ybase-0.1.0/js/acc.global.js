const global = {
  _autoload: [
    'benefitsBarCarousle',
    ['passwordStrength', $('.password-strength').length > 0],
    'bindToggleOffcanvas',
    'bindToggleXsSearch',
    'bindHoverIntentMainNavigation',
    'backToHome',
    'bindDropdown',
    'closeAccAlert',
    ['initPopoversCollapsable', $('.js-triggerTooltip').length > 0],
    ['globalAlertDissapear', $('.js-alertDissapear').length > 0],
    'bindCheckboxValue',
    ['setMinContentHeight', $('.js-bgImageComponent').length > 0],
    ['eligibilityCtaRedirect', $('.js-eligibilityCta').length > 0],
    'addBlurOnIPad',
    'getCookieByName',
    'trimGACookieName',
    'init'
  ],
  brakesHandlebars: Handlebars.noConflict(),
  $toggleMobileSub: $('.js-toggleMobileSub'),
  $subNavClose: $('.js-enquire-offcanvas-navigation .js-enquire-sub-close'),
  $level1HasSub: $('.js-level1HasSub'),
  SITE_SEARCH_INPUT: '.js-site-search-input',
  SITE_SEARCH_TOGGLE_XS: '.js-toggle-xs-search',
  SEARCH_ACTIVE: 'search-active',
  REMOVE_CLICKED: false,
  init: function () {
    ACC.global.toggleNavBarPopup('.js-loginPopupTrigger', '.js-loginPopup', '.js-closeMenu');
    ACC.global.toggleNavBarPopup('.js-deliveryPopupTrigger', '.js-deliveryPopup', '.js-closeMenu');

    var searchInput = document.querySelector(ACC.global.SITE_SEARCH_INPUT);
    searchInput &&
      searchInput.addEventListener('focus', function () {
        var body = document.body;
        var mobileNav = body.querySelector('.js-menu');

        if (mobileNav.querySelector('.icon-close')) mobileNav.click();
        body.classList.add(ACC.global.SEARCH_ACTIVE);
      });
    searchInput &&
      searchInput.addEventListener('blur', function () {
        document.body.classList.remove(ACC.global.SEARCH_ACTIVE);
      });

    $(document).on('click', '.js-displayLoginPopup', function () {
      $('.js-loginPopup').removeClass('hide');
    });
  },
  toggleSpinner: function (show) {
    var $spinner = $('.js_spinner');
    if (show) {
      $spinner.show();
    } else {
      $spinner.hide();
    }
  },
  setCookie: function (name, value) {
    document.cookie = name + '=' + value;
  },
  getCookieByName: function (name) {
    /**
     * alternative: get cookie by name with using a regular expression
     */
    var pair = document.cookie.match(new RegExp(name + '=([^;]+)'));
    return pair ? pair[1] : null;
  },
  deleteCookieByName: function (name) {
    document.cookie = name + '=;expires=Thu, 01 Jan 1970 00:00:01 GMT;';
  },
  bindCheckboxValue: function () {
    $(document).on('change', '.js-formCheckbox', function () {
      var $this = $(this);
      var isChecked = $this.is(':checked');
      $this.attr('value', isChecked);
    });
  },
  trimGACookieName: function () {
    var gaCookieName = ACC.global.getCookieByName('last_touch');
    if (gaCookieName) {
      var trimmedCookieName = gaCookieName.split(' ').join('');
      ACC.global.setCookie('last_touch', trimmedCookieName);
    }
  },
  passwordStrength: function () {
    $('.password-strength').pstrength({
      verdicts: [
        ACC.pwdStrengthTooShortPwd,
        ACC.pwdStrengthVeryWeak,
        ACC.pwdStrengthWeak,
        ACC.pwdStrengthMedium,
        ACC.pwdStrengthStrong,
        ACC.pwdStrengthVeryStrong
      ],
      minCharText: ACC.pwdStrengthMinCharText
    });
  },

  doSubmitForm: function ($form) {
    $form.off('submit');
    $form.submit();
  },

  bindToggleOffcanvas: function () {
    var mobNavigation = document.querySelector('.js-toggle-sm-navigation');

    mobNavigation &&
      mobNavigation.addEventListener('click', function (e) {
        var element = e.currentTarget;
        var d = document;
        var body = d.body;
        var icon = element.querySelector('.icon');

        d.querySelector('html').classList.toggle('offcanvas');
        body.classList.toggle('offcanvas');
        body.querySelector('main').classList.toggle('offcanvas');
        icon.classList.toggle('icon-menu');
        icon.classList.toggle('icon-close');
        element.querySelector('.nav__burger-menu-text').classList.toggle('hide');

        ACC.global.closeSiteXsSearch();
        ACC.global.toggleAboutLinks(null, true);

        //closes both navigation levels in case second level is opened when close is clicked
        if (icon.classList.contains('icon-menu')) {
          ACC.global.$toggleMobileSub.trigger('click', ['remove']);
          ACC.global.$subNavClose.trigger('click');
          ACC.global.$level1HasSub.removeClass('active');
          ACC.global.toggleAboutLinks(null, false);
        }
      });
  },

  toggleAboutLinks: function (e, toggle) {
    var aboutLinks = document.querySelector('.js-aboutLinks');
    var ssoButton = document.getElementById('sso-button');

    if (toggle) {
      var destElement = document.querySelector('.js-aboutLinksDest');
      destElement.appendChild(aboutLinks);
      ssoButton && destElement.appendChild(ssoButton.parentElement);
    } else {
      var desktopLeftNav = document.querySelector('.nav-links-wrapper__left');
      desktopLeftNav.appendChild(aboutLinks);
      var desktopRightNav = document.querySelector('.nav__right');
      ssoButton && desktopRightNav.prepend(ssoButton.parentElement);
    }
  },

  bindToggleXsSearch: function () {
    $(document).on('click', ACC.global.SITE_SEARCH_TOGGLE_XS, ACC.global.onToggleXsSearchClick);
  },

  onToggleXsSearchClick: function () {
    var $this = $(this);
    if ($('body').hasClass('offcanvas')) {
      $('.js-closeMenu').trigger('click');
    }
    if ($this.hasClass('active')) {
      ACC.global.closeSiteXsSearch();
    } else {
      if ($(window).scrollTop() > 0) {
        $('body,html').animate(
          {
            scrollTop: 0
          },
          250,
          ACC.global.openSiteXsSearch()
        );
      } else {
        ACC.global.openSiteXsSearch();
      }
    }
  },

  bindXsSearchDoneFocusOut: function () {
    $(document).one('focusout', ACC.global.SITE_SEARCH_INPUT, ACC.global.checkFocusOutDone);
  },

  checkFocusOutDone: debounce(function (e) {
    e.stopPropagation();
    if (ACC.global.REMOVE_CLICKED) {
      ACC.global.REMOVE_CLICKED = false;
      return false;
    } else {
      ACC.global.closeSiteXsSearch();
    }
  }, 200),

  unbindXsSearchDone: function () {
    $(document).off('focusout', ACC.global.SITE_SEARCH_INPUT, ACC.global.checkFocusOutDone);
  },

  openSiteXsSearch: function () {
    $(ACC.global.SITE_SEARCH_TOGGLE_XS).addClass('active');
    $('body').addClass(ACC.global.SEARCH_ACTIVE);
    $('.js-mainHeader .navigation--middle').addClass('search-open');
    $('.site-search').addClass('active');
    $(document).trigger('searchOpened');
  },

  closeSiteXsSearch: function () {
    $('.site-search').removeClass('active');
    $('.js-mainHeader .navigation--middle').removeClass('search-open');
    $('body').removeClass(ACC.global.SEARCH_ACTIVE);
    $(ACC.global.SITE_SEARCH_TOGGLE_XS).removeClass('active');
    ACC.global.unbindXsSearchDone();
  },

  toggleClassState: function ($e, c) {
    $e.hasClass(c) ? $e.removeClass(c) : $e.addClass(c);
    return $e.hasClass(c);
  },

  isIpad: function () {
    return navigator.userAgent.match(/iPad/i) != null;
  },

  bindHoverIntentMainNavigation: function () {
    enquire.register('screen and (min-width:' + ACC.breakpoints.screenSmMin + ')', {
      match: function () {
        //closes both navigation levels in case second level is opened when close is clicked
        var mobNavigation = document.querySelector('.js-toggle-sm-navigation');
        if (mobNavigation && mobNavigation.querySelector('.icon').classList.contains('icon-close')) {
          mobNavigation.click();
        }
        // on screens larger or equal screenMdMin (1024px) calculate position for .sub-navigation
        $('.js-enquire-has-sub').hoverIntent(
          function () {
            var $this = $(this);
            var $subNav = $this.find('.js_sub__navigation');

            ACC.navigation.closeOpenNavs();
            ACC.global.calcSubNavPosition($this, $subNav);
            $subNav.addClass('is-active');
            $this.addClass('show-sub');
            ACC.global.bindSubNavScroll();

            var focusedSelectDropdown = document.querySelector('.page-actions-bar select:focus');
            focusedSelectDropdown && focusedSelectDropdown.blur();
          },
          function () {
            ACC.global.unbindSubNavScroll();
            var $this = $(this);
            $this.removeClass('show-sub');
            $('.js_sub__navigation.is-active').removeClass('is-active');
          }
        );
      },
      unmatch: function () {
        // on screens smaller than screenMdMin (1024px) remove inline styles from .sub-navigation and remove hoverIntent
        $('.js_sub__navigation').removeAttr('style');
        $('.js-enquire-has-sub').hoverIntent(function () {
          // unbinding hover
        });
        ACC.global.unbindSubNavScroll();
      }
    });
  },

  calcSubNavPosition: function ($this, $subNav) {
    var itemWidth = $this.width();
    var subNavWidth = $subNav.outerWidth();
    var mainNavWidth = $('.js_navigation--bottom').width();

    // get the left position for sub-navigation to be centered under each <li>
    var leftPos = $this.position().left + itemWidth / 2 - subNavWidth / 2;
    // get the top position for sub-navigation. this is usually the height of the <li> unless there is more than one row of <li>
    var topPos = $this.position().top + $this.height();

    if (leftPos > 0 && leftPos + subNavWidth < mainNavWidth) {
      // .sub-navigation is within bounds of the .main-navigation
      $subNav.css({
        left: leftPos,
        top: topPos,
        right: 'auto'
      });
    } else if (leftPos < 0) {
      // .suv-navigation can't be centered under the <li> because it would exceed the .main-navigation on the left side
      $subNav.css({
        left: 0,
        top: topPos,
        right: 'auto'
      });
    } else if (leftPos + subNavWidth > mainNavWidth) {
      // .suv-navigation can't be centered under the <li> because it would exceed the .main-navigation on the right side
      $subNav.css({
        right: 0,
        top: topPos,
        left: 'auto'
      });
    }
  },

  bindSubNavScroll: function () {
    var activeSubNavigation = $('.js_sub__navigation.is-active').find('.sub-navigation__wrapper');
    var subNavPadding = 100;
    var subNavScrollHeight = activeSubNavigation[0].scrollHeight - subNavPadding;

    // check if scrolling is required and assign listeners
    if (subNavScrollHeight > activeSubNavigation.height()) {
      activeSubNavigation.on('touchstart', ACC.global.onTouchStart);
    }
  },

  onTouchStart: function (e) {
    var $this = $(this);

    ACC.global.startinScroll = $(this).scrollTop();
    ACC.global.originalTouch = e.originalEvent.touches[0].clientY;

    $this.one('touchend', function () {
      $this.off('touchmove');
    });

    $this.on('touchmove', ACC.global.onTouchMove);
  },

  onTouchMove: function (e) {
    var $this = $(this);
    var endingTouch = e.originalEvent.changedTouches[0].clientY;
    var scrollTarget;
    var scrollHeight = $(e.target).height();

    if (endingTouch < ACC.global.originalTouch) {
      scrollTarget = ((ACC.global.originalTouch - endingTouch) / scrollHeight) * scrollHeight;
    } else {
      scrollTarget = 0 - ((endingTouch - ACC.global.originalTouch) / scrollHeight) * scrollHeight;
    }
    // can be reinstated to create instant scroll with no delay
    // $this.scrollTop(ACC.global.startinScroll + scrollTarget);
    $this.stop();
    $this.animate({ scrollTop: ACC.global.startinScroll + scrollTarget }, 250, 'easeInOutQuart');
  },

  unbindSubNavScroll: function () {
    $('.js_sub__navigation.is-active').find('.sub-navigation__wrapper').off('touchmove').off('touchend').off('touchstart');
  },

  // usage: ACC.global.addGoogleMapsApi("callback function"); // callback function name like "ACC.global.myfunction"
  addGoogleMapsApi: function (callback) {
    if (callback != undefined && $('.js-googleMapsApi').length == 0) {
      $('head').append(
        '<script class="js-googleMapsApi" type="text/javascript" src="//maps.googleapis.com/maps/api/js?key=' +
          ACC.config.googleApiKey +
          '&sensor=false&callback=' +
          callback +
          '"></script>'
      );
    } else if (callback != undefined) {
      callback();
    }
  },

  backToHome: function () {
    $('.backToHome').on('click', function () {
      var sUrl = ACC.config.contextPath;
      window.location = sUrl;
    });
  },

  bindDropdown: function () {
    $(document).on('click', '.dropdown-toggle', function (e) {
      var $this = $(this);

      // ***** Dropdown begins *****
      function dropdownParent($this) {
        var selector = $this.attr('href');
        selector = selector && /#[A-Za-z]/.test(selector) && selector.replace(/.*(?=#[^\s]*$)/, ''); // strip for ie7

        var $parent = selector && $(selector);

        return $parent && $parent.length ? $parent : $this.parent();
      }

      function dropdownClearMenus(e) {
        // if right click, exit
        if (e && e.which === 3) return;

        // remove class added on dropdownToggle
        $('.dropdown-backdrop').remove();

        $('.dropdown-toggle').each(function () {
          var $parent = dropdownParent($(this));

          if (!$parent.hasClass('open')) return;

          if (e && e.type == 'click' && /input|textarea/i.test(e.target.tagName) && $.contains($parent[0], e.target)) return;

          $parent.removeClass('open');
        });
      }

      if ($this.is('.disabled, :disabled')) return;

      var $parent = dropdownParent($this);
      var isActive = $parent.hasClass('open');

      dropdownClearMenus();

      if (!isActive) {
        if ('ontouchstart' in document.documentElement && !$parent.closest('.navbar-nav').length) {
          // if mobile we use a backdrop because click events don't delegate
          $(document.createElement('div')).addClass('dropdown-backdrop').insertAfter($(this)).on('click', dropdownClearMenus);
        }

        if (e.isDefaultPrevented()) return;

        // expand the <ul> on the dropdown
        $this.trigger('focus').attr('aria-expanded', 'true');

        // set parent to open
        $parent.toggleClass('open');
      }

      return false;
    });
  },

  closeAccAlert: function () {
    $('.closeAccAlert').on('click', function () {
      $(this).parent('.getAccAlert').remove();
    });
  },
  benefitsBarCarousle: function () {
    $('.js-benefitsCarousel').owlCarousel({
      loop: true,
      margin: 10,
      nav: true,
      navText: ["<span class='icon icon--sm icon-chevron-left'></span>", "<span class='icon icon--sm icon-chevron-right'></span>"],
      responsive: {
        0: {
          items: 1
        },
        1240: {
          items: window.benefitsBarCount,
          loop: false,
          mouseDrag: false
        }
      }
    });
  },

  scrollToElement: function (selectorName, scrollSpeed, offset) {
    offset = offset || 0;
    var $className = $(selectorName).first();
    var offsetValue = $className.offset();
    if (offsetValue) {
      $('html, body').animate(
        {
          scrollTop: offsetValue.top - offset
        },
        scrollSpeed
      );
    }
  },
  initTooltips: function () {
    $(function () {
      $('[data-toggle="tooltip"]').tooltip();
    });
  },

  initPopoversCollapsable: function () {
    var customTemplate =
      '<div class="popover" role="tooltip"><div class="arrow"></div><button class="icon icon--sm icon-close popover-close js-popoverClose"></button><div class="popover-content"></div></div>';
    $(function () {
      $('[data-toggle="popover-collapsable"]').popover({
        template: customTemplate,
        trigger: 'manual'
      });
    });
    $(document).on('mouseenter touchstart', '.js-triggerTooltip', function () {
      $(this).popover('show');
    });

    $(document).on('click', '.js-popoverClose', function () {
      $(this).parents('.popover').popover('hide');
    });
  },

  renderHandlebarsTemplate: function (data, targetEl, hbTemplate) {
    var elId = document.getElementById(hbTemplate);
    var templateSource = elId.innerHTML;
    var template = this.brakesHandlebars.compile(templateSource);
    var html = template(data);
    if (targetEl === 'noTargetEl') {
      return html;
    } else {
      var target = document.getElementById(targetEl);
      target.innerHTML = html;
    }
  },
  compileHandlebarTemplate: function (id) {
    var handlebarsTemplate = $(id).html();
    var compiledTemplated = this.brakesHandlebars.compile(handlebarsTemplate);
    return compiledTemplated;
  },

  globalAlertDissapear: function () {
    setTimeout(function () {
      $('.js-alertDissapear').hide();
    }, 5000);
  },

  //returns URL without the parameter with the name key
  removeUrlParam: function (key, sourceURL) {
    var rtn = sourceURL.split('?')[0],
      param,
      params_arr = [],
      queryString = sourceURL.indexOf('?') !== -1 ? sourceURL.split('?')[1] : '';
    if (queryString !== '') {
      params_arr = queryString.split('&');
      for (var i = params_arr.length - 1; i >= 0; i -= 1) {
        param = params_arr[i].split('=')[0];
        if (param === key) {
          params_arr.splice(i, 1);
        }
      }
      if (params_arr.length > 0) {
        rtn = rtn + '?' + params_arr.join('&');
      }
    }
    return rtn;
  },

  //Returns value of the parameter in the url or null if it's not in the url
  getUrlParameter: function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
      sURLVariables = sPageURL.split('&'),
      sParameterName,
      i;

    for (i = 0; i < sURLVariables.length; i++) {
      sParameterName = sURLVariables[i].split('=');

      if (sParameterName[0] === sParam) {
        return sParameterName[1] === undefined ? true : sParameterName[1];
      }
    }
  },

  //Used only on stripped down header pages, on tablet.
  //It resolves an issue where there is a white space below the footer, as content height + header + footer
  //is smaller than viewport height
  setMinContentHeight: function () {
    enquire.register('screen and (min-width:' + ACC.breakpoints.screenSmMin + ')', {
      match: function () {
        var strippedDownHeaderHeight = $('.js-strippedDownHeader').outerHeight();
        var strippedDownFooterHeight = $('.js-strippedDownFooter').outerHeight();
        var minHeight = 'calc(100vh - ' + (strippedDownHeaderHeight + strippedDownFooterHeight) + 'px)';
        $('.js-bgImageComponent').css({
          'min-height': minHeight,
          'background-size': 'cover',
          'background-position-x': 'center',
          'background-position-y': 'center'
        });
      }
    });
  },

  eligibilityCtaRedirect: function () {
    $(document).on('click', '.js-eligibilityCta', ACC.global.redirectToPage);
  },
  /**
   * Redirect to specific page
   * @param {String} destination
   */
  redirectTo: function (destination) {
    if (destination) {
      window.location = encodeURI(destination);
    }
  },
  redirectToPage: function (e) {
    e.preventDefault();
    var url = e.target.href;
    var parameters = {
      CSRFToken: ACC.config.CSRFToken
    };
    ACC.global.postToUrl(url, parameters);
  },

  // Post to the provided URL with the specified parameters.
  postToUrl: function (path, parameters) {
    var form = $('<form></form>');

    form.attr('method', 'post');
    form.attr('action', path);

    $.each(parameters, function (key, value) {
      var field = $('<input></input>');

      field.attr('type', 'hidden');
      field.attr('name', key);
      field.attr('value', value);

      form.append(field);
    });

    // The form needs to be a part of the document in
    // order for us to be able to submit it.
    $(document.body).append(form);
    form.submit();
  },

  addBlurOnIPad: function () {
    var isIPad = $('html').hasClass('iPad');
    if (isIPad) {
      $(document).on('click touchstart', 'body', function (event) {
        var targetElem = event.target.tagName.toUpperCase();
        if (!(targetElem == 'INPUT' || targetElem == 'SELECT' || targetElem == 'TEXTAREA')) {
          document.activeElement.blur();
        }
      });
    }
  },

  checkLoginStatus: function (callback, callbackParam) {
    $.ajax({
      url: ACC.config.loginStatusUrl,
      cache: false,
      type: 'GET',
      success: function (response) {
        if (!response.loggedInStatus) {
          window.location = encodeURI(ACC.config.loginUrl);
        } else {
          if (typeof callback == 'function') {
            callback(callbackParam);
          }
        }
      },
      error: function () {
        window.location = encodeURI(ACC.config.loginUrl);
      }
    });
  },

  linkClickIntercept: function (e) {
    e.preventDefault();
    if (!ACC.global.keyPressCheck(e)) {
      return false;
    }
    ACC.global.checkLoginStatus(function () {
      window.location.href = encodeURI($(e.target).attr('href'));
    });
  },

  keyPressCheck: function (e, action) {
    if (e.type == 'keypress') {
      var keyCode = e.keyCode || e.which;
      switch (action) {
        // buttons, links, dropdowns
        case 'enter_space':
          if (keyCode !== 13 && keyCode !== 32) {
            return false;
          }
          break;
        default:
          // links only
          if (keyCode !== 13) {
            return false;
          }
          break;
      }
    }
    return true;
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

  findObjectByKey: function (array, key, value) {
    for (var i = 0; i < array.length; i++) {
      if (array[i][key] === value) {
        return array[i];
      }
    }
    return null;
  },
  toggleNavBarPopup: function (triggerClass, popupClass, closeClass) {
    var body = document.body;
    var elements = body.querySelectorAll(triggerClass);

    elements.forEach(function (button) {
      button.addEventListener('click', function () {
        var parentElement = button.parentElement;
        var mobileItem = body.querySelector('.js-mobile-nav__item');
        mobileItem.classList.remove('open');
        var popupSelector = body.querySelector(popupClass);
        if (popupSelector) {
          popupSelector.classList.toggle('hide');
          if (popupSelector.classList.contains('hide')) {
            ACC.global.unbindWatchForClickOutside(triggerClass, popupClass);
            parentElement.classList.remove('nav__item--open');
          } else {
            mobileItem.classList.toggle('open');
            if (body.classList.contains('offcanvas')) {
              $(closeClass).trigger('click');
            }
            ACC.global.bindWatchForClickOutside(triggerClass, popupClass);
            parentElement.classList.add('nav__item--open');
          }
        }
      });
    });
  },
  hideNavBarPopup: function (popupSelector) {
    $(popupSelector).addClass('hide');
    $('.js-mobile-nav__item').removeClass('open');
  },
  bindWatchForClickOutside: function (triggerClass, popupClass) {
    $(document).on('mouseup', { triggerClass: triggerClass, popupClass: popupClass }, ACC.global.onClickOutside);
  },
  unbindWatchForClickOutside: function (triggerClass, popupClass) {
    $(document).off('mouseup', { triggerClass: triggerClass, popupClass: popupClass }, ACC.global.onClickOutside);
  },
  onClickOutside: function (e) {
    var $modalTrigger = $(e.data.triggerClass);
    var $modalContent = $(e.data.popupClass);

    if (!$modalTrigger.is(e.target) && $modalTrigger.has(e.target).length === 0) {
      // if the target of the click isn't the container nor a descendant of the container
      if (!$modalContent.is(e.target) && $modalContent.has(e.target).length === 0) {
        ACC.global.hideNavBarPopup(e.data.popupClass);
      }
    }
  }
};

// Prevent body scroll on iOS
(function () {
  var _overlay = document.getElementById('jsMainNavigation');
  var _clientY = null; // remember Y position on touch start
  if (_overlay == null) {
    // If overlay can't be found in DOM exit early.
    // For example jsMainNavigation won't exists on checkout
    return;
  }
  _overlay.addEventListener(
    'touchstart',
    function (event) {
      if (event.targetTouches.length === 1) {
        // detect single touch
        _clientY = event.targetTouches[0].clientY;
      }
    },
    {
      capture: false,
      passive: true
    }
  );

  _overlay.addEventListener(
    'touchmove',
    function (event) {
      if (event.targetTouches.length === 1) {
        // detect single touch
        disableRubberBand(event);
      }
    },
    {
      capture: false,
      passive: true
    }
  );

  function disableRubberBand(event) {
    var clientY = event.targetTouches[0].clientY - _clientY;

    if (_overlay.scrollTop === 0 && clientY > 0) {
      // element is at the top of its scroll
      event.preventDefault();
    }

    if (isOverlayTotallyScrolled() && clientY < 0) {
      //element is at the top of its scroll
      event.preventDefault();
    }
  }

  function isOverlayTotallyScrolled() {
    // https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollHeight#Problems_and_solutions
    return _overlay.scrollHeight - _overlay.scrollTop <= _overlay.clientHeight;
  }
})();

export default global;
