const navigation = {
  _autoload: [
    'initNavModal',
    'offcanvasNavigation',
    'myAccountNavigation',
    'orderToolsNavigation',
    'bindMainNavCarousel',
    'bindMoreCats',
    'bindMobileSubMenu',
    'bindTabletAboutNav'
  ],
  ACTIVE_CLASS: 'is-active',
  HAS_SUB_CLASS: 'has-subnav',
  SUB_NAV_CLASS: 'links-subnav__item',
  MORE_ABOUT_LINKS_CLASS: '.js-moreAboutLinks',
  ABOUT_LINKS_CLASS: '.js-aboutLinks',
  ITEM_DRILLDOWN_CLASS: '.js-linksItemDrillDown',
  offcanvasNavigation: function () {
    if (ACC.global.isIpad()) {
      enquire.register('screen and (min-width:' + ACC.breakpoints.screenSmMin + ')', {
        match: function () {
          $(document).on('click', '.js-enquire-has-sub .js_nav__link', ACC.navigation.onNavLinkClick);
        },
        unmatch: function () {
          $(document).off('click', '.js-enquire-has-sub .js_nav__link', ACC.navigation.onNavLinkClick);
        }
      });
    } else {
      enquire.register('screen and (max-width:' + ACC.breakpoints.screenSmMax + ')', {
        match: function () {
          $(document).on('click', '.js-enquire-offcanvas-navigation .js-enquire-has-sub .js_nav__link', ACC.navigation.onNavLinkClick);

          $(document).on('click', '.js-enquire-offcanvas-navigation .js-enquire-sub-close', ACC.navigation.onMobileSubClose);

          $(document).on('click', '.js-enquire-offcanvas-navigation .js-subLevel2Close', ACC.navigation.onMobileSubLevel2Close);
        },
        unmatch: function () {
          $('.js-userAccount-Links').show();
          $('.js-enquire-offcanvas-navigation ul.js-offcanvas-links').removeClass('active');
          $('.js-enquire-offcanvas-navigation .js-enquire-has-sub').removeClass('active');

          $(document).off('click', '.js-enquire-offcanvas-navigation .js-enquire-has-sub .js_nav__link');
          $(document).off('click', '.js-enquire-offcanvas-navigation .js-enquire-sub-close');
          $(document).off('click', '.js-enquire-offcanvas-navigation .js-subLevel2Close');
        }
      });
    }
  },

  onNavLinkClick: function (e) {
    e.preventDefault();
    var $parentEnquireSub = $(this).parents('.js-enquire-has-sub');

    ACC.navigation.closeOpenNavs();

    $('.js-enquire-offcanvas-navigation ul.js-offcanvas-links').addClass('active');
    $('.js-enquire-offcanvas-navigation .js-enquire-has-sub').removeClass('active');

    if ($(this).parents('.js-destMobileSub').length > 0 && !ACC.global.isIpad()) {
      // handle mobile nav
      $parentEnquireSub.addClass('active');
    } else {
      // handle tablet sized implementations
      // check MORE Sub Links
      if ($(e.currentTarget).parents('.nav__link--secondary').length > 0) {
        var targetUrl = $(e.currentTarget).find('a').attr('href');
        if (targetUrl) {
          window.location = encodeURI(targetUrl);
        }
      } else {
        if ($parentEnquireSub.hasClass('show-sub')) {
          $parentEnquireSub[0].dispatchEvent(new window.MouseEvent('mouseout'));
        } else {
          $parentEnquireSub[0].dispatchEvent(new window.MouseEvent('mouseover'));
        }
      }
    }
  },

  closeOpenNavs: function () {
    if ($('.js-moreAboutLinks').hasClass(ACC.navigation.ACTIVE_CLASS)) {
      ACC.navigation.toggleMoreLinksActive();
    }
    $('.js-linksItemDrillDown.is-active').removeClass(ACC.navigation.ACTIVE_CLASS);
    $('.js-userAccount-Links').hide();
  },

  onMobileSubClose: function (e) {
    e.preventDefault();
    e.stopPropagation();
    $('.js-userAccount-Links').show();
    $('.js-enquire-offcanvas-navigation ul.js-offcanvas-links').removeClass('active');
    $('.js-enquire-offcanvas-navigation .js-enquire-has-sub').removeClass('active');
  },

  onMobileSubLevel2Close: function (e) {
    e.preventDefault();
    e.stopPropagation();
    $(this).parents('.js-level1HasSub').removeClass('active');
  },

  myAccountNavigation: function () {
    //copy the site logo
    $('.js-mobile-logo').html($('.js-site-logo a').clone());

    //Add the order form img in the navigation
    $('.nav-form').html($('<span class="glyphicon glyphicon-list-alt"></span>'));

    var aAcctData = [];
    var sSignBtn = '';
    var oLink, oListItem;

    //my account items
    var oMyAccountData = $('.accNavComponent');

    //the my Account hook for the desktop
    var oMMainNavDesktop = $('.js-secondaryNavAccount > ul');

    if (oMyAccountData) {
      var aLinks = oMyAccountData.find('a');
      for (var j = 0; j < aLinks.length; j++) {
        aAcctData.push({ link: aLinks[j].href, text: aLinks[j].title });
      }
    }

    var navClose = '';
    navClose += '<div class="close-nav">';
    navClose += '<button type="button" class="js-toggle-sm-navigation btn"><span class="glyphicon glyphicon-remove"></span></button>';
    navClose += '</div>';

    //create Sign In/Sign Out Button
    if ($('.liOffcanvas a') && $('.liOffcanvas a').length > 0) {
      sSignBtn +=
        '<li class="auto liUserSign" ><a class="userSign" href="' +
        $('.liOffcanvas a')[0].href +
        '">' +
        $('.liOffcanvas a')[0].innerHTML +
        '</a></li>';
    }

    //create Welcome User + expand/collapse and close button
    //This is for mobile navigation. Adding html and classes.
    var oUserInfo = $('.nav__right ul li.logged_in');
    //Check to see if user is logged in
    if (oUserInfo && oUserInfo.length === 1) {
      var sUserBtn = '';
      sUserBtn += '<li class="auto">';
      sUserBtn += '<div class="userGroup">';
      sUserBtn += '<span class="glyphicon glyphicon-user myAcctUserIcon"></span>';
      sUserBtn += '<div class="userName">' + oUserInfo[0].innerHTML + '</div>';
      if (aAcctData.length > 0) {
        sUserBtn += '<a class="collapsed js-nav-collapse" id="signedInUserOptionsToggle" data-toggle="collapse"  data-target=".offcanvasGroup1">';
        sUserBtn += '<span class="glyphicon glyphicon-chevron-up myAcctExp"></span>';
        sUserBtn += '</a>';
      }
      sUserBtn += '</div>';
      sUserBtn += navClose;

      $('.js-sticky-user-group').html(sUserBtn);

      $('.js-userAccount-Links').append(sSignBtn);
      $('.js-userAccount-Links').append($('<li class="auto"><div class="myAccountLinksContainer js-myAccountLinksContainer"></div></li>'));

      //FOR DESKTOP
      var myAccountHook = $(
        '<div class="myAccountLinksHeader js-myAccount-toggle" data-toggle="collapse" data-parent=".nav__right" >' +
          oMyAccountData.data('title') +
          '</div>'
      );
      myAccountHook.insertBefore(oMyAccountData);

      //*For toggling collapse myAccount on Desktop instead of with Bootstrap.js
      $('.myAccountLinksHeader').click(function () {
        $(this).toggleClass('show');
        $('.js-secondaryNavAccount').slideToggle(400);
        if ($(this).hasClass('show')) {
          $('.myCompanyLinksHeader').removeClass('show'); // hide the other one
          $('.js-secondaryNavCompany').slideUp(400);
        }
        return false;
      });

      //FOR MOBILE
      //create a My Account Top link for desktop - in case more components come then more parameters need to be passed from the backend
      myAccountHook = [];
      myAccountHook.push('<div class="sub-nav">');
      myAccountHook.push(
        '<a id="signedInUserAccountToggle" class="myAccountLinksHeader collapsed js-myAccount-toggle" data-toggle="collapse" data-target=".offcanvasGroup2">'
      );
      myAccountHook.push(oMyAccountData.data('title'));
      myAccountHook.push('<span class="glyphicon glyphicon-chevron-down myAcctExp"></span>');
      myAccountHook.push('</a>');
      myAccountHook.push('</div>');

      $('.js-myAccountLinksContainer').append(myAccountHook.join(''));

      //add UL element for nested collapsing list
      $('.js-myAccountLinksContainer').append(
        $(
          '<ul data-trigger="#signedInUserAccountToggle" class="offcanvasGroup2 offcanvasNoBorder collapse js-nav-collapse-body subNavList js-myAccount-root sub-nav"></ul>'
        )
      );

      //*For toggling collapse on Mobile instead of with Bootstrap.js
      $('#signedInUserAccountToggle').click(function () {
        $(this).toggleClass('show');
        $('.offcanvasGroup2').slideToggle(400);
        if ($(this).hasClass('show')) {
          $(this).find('span').removeClass('glyphicon-chevron-down').addClass('glyphicon-chevron-up');
          $('#signedInCompanyToggle').removeClass('show'); // hide the other one
          $('#signedInCompanyToggle').find('span').removeClass('glyphicon-chevron-up').addClass('glyphicon-chevron-down');
          $('.offcanvasGroup3').slideUp(400);
        } else {
          $(this).find('span').removeClass('glyphicon-chevron-up').addClass('glyphicon-chevron-down');
        }
      });

      //offcanvas items
      //TODO Follow up here to see the output of the account data in the offcanvas menu
      for (var i = aAcctData.length - 1; i >= 0; i--) {
        oLink = document.createElement('a');
        oLink.title = aAcctData[i].text;
        oLink.href = aAcctData[i].link;
        oLink.innerHTML = aAcctData[i].text;

        oListItem = document.createElement('li');
        oListItem.appendChild(oLink);
        oListItem = $(oListItem);
        oListItem.addClass('auto ');
        $('.js-myAccount-root').append(oListItem);
      }
    } else {
      var navButtons = sSignBtn.substring(0, sSignBtn.length - 5) + navClose + '</li>';
      $('.js-sticky-user-group').html(navButtons);
    }

    //desktop
    for (var idx = 0; idx < aAcctData.length; idx++) {
      oLink = document.createElement('a');
      oLink.title = aAcctData[idx].text;
      oLink.href = aAcctData[idx].link;
      oLink.innerHTML = aAcctData[idx].text;

      oListItem = document.createElement('li');
      oListItem.appendChild(oLink);
      oListItem = $(oListItem);
      oListItem.addClass('auto col-md-4');
      oMMainNavDesktop.get(0).appendChild(oListItem.get(0));
    }

    //hide and show contnet areas for desktop
    $('.js-secondaryNavAccount').on('shown.bs.collapse', function () {
      if ($('.js-secondaryNavCompany').hasClass('in')) {
        $('.js-myCompany-toggle').click();
      }
    });

    $('.js-secondaryNavCompany').on('shown.bs.collapse', function () {
      if ($('.js-secondaryNavAccount').hasClass('in')) {
        $('.js-myAccount-toggle').click();
      }
    });

    //change icons for up and down
    $('.js-nav-collapse-body').on('hidden.bs.collapse', function (e) {
      var target = $(e.target);
      var targetSpan = target.attr('data-trigger') + ' > span';
      if (target.hasClass('in')) {
        $(targetSpan).removeClass('glyphicon-chevron-down').addClass('glyphicon-chevron-up');
      } else {
        $(targetSpan).removeClass('glyphicon-chevron-up').addClass('glyphicon-chevron-down');
      }
    });

    $('.js-nav-collapse-body').on('show.bs.collapse', function (e) {
      var target = $(e.target);
      var targetSpan = target.attr('data-trigger') + ' > span';
      if (target.hasClass('in')) {
        $(targetSpan).removeClass('glyphicon-chevron-up').addClass('glyphicon-chevron-down');
      } else {
        $(targetSpan).removeClass('glyphicon-chevron-down').addClass('glyphicon-chevron-up');
      }
    });

    //$('.offcanvasGroup1').collapse();
  },

  orderToolsNavigation: function () {
    $('.js-nav-order-tools').on('click', function () {
      $(this).toggleClass('js-nav-order-tools--active');
    });
  },
  bindMainNavCarousel: function () {
    var navSelector = '.js-mainNavigation';
    var $mainNavObj = $(navSelector);
    var query = 'screen and (min-width:' + ACC.breakpoints.screenSmMin + ') and (max-width:' + ACC.breakpoints.screenSmMax + ')';
    var TABLET_CLASS = 'navigation-tablet ';

    enquire.register(query, {
      match: function () {
        ACC.navigation.initTabletOnlyNav($mainNavObj, TABLET_CLASS);
      },
      unmatch: function () {
        ACC.navigation.destroyTabletOnlyNav($mainNavObj, TABLET_CLASS);
      }
    });
  },
  destroyTabletOnlyNav: function ($mainNavObj, tabletClass) {
    $mainNavObj.removeClass(tabletClass);
  },
  initTabletOnlyNav: function ($mainNavObj, tabletClass) {
    $mainNavObj.addClass(tabletClass);
    ACC.navigation.initMainNavScrolling();
  },
  initMainNavScrolling: function () {
    var $scrollRightBtn = $('.js-mainNavRight');
    var $scrollLeftBtn = $('.js-mainNavLeft');
    var $mainCatsWrapper = $('.js-mainNavCategoriesWrapper');
    var $mainCats = $('.js-mainNavCategories');
    var mainWrapperWidth = $mainCatsWrapper.width();
    var mainCatsWidth = parseInt($mainCats.width()); // To avoid odd numbers eg. 320.12
    var SCROLL_SIZE = 100;
    var SCROLL_SPEED = 500;
    var TIMEOUT = 200;
    var EASE_TYPE = 'swing';
    var pos;
    var newPos;
    var navPosition;
    var scrollTimer;
    var leftPosition;
    var rightPosition;

    // On load check the width of mega menu nav
    // If it's larger then window width display right arrow
    if (mainCatsWidth >= mainWrapperWidth) {
      $scrollRightBtn.addClass(ACC.navigation.ACTIVE_CLASS);
    }

    // On scroll using hand gestures
    $mainCatsWrapper.on('scroll', function () {
      if (scrollTimer) {
        window.clearTimeout(scrollTimer);
      }

      scrollTimer = window.setTimeout(function () {
        // actual callback
        pos = $mainCatsWrapper.scrollLeft();
        leftPosition = pos;
        rightPosition = pos + mainWrapperWidth;

        if (leftPosition > 0) {
          $scrollLeftBtn.addClass(ACC.navigation.ACTIVE_CLASS);
        } else {
          $scrollLeftBtn.removeClass(ACC.navigation.ACTIVE_CLASS);
        }

        if (rightPosition < mainCatsWidth) {
          $scrollRightBtn.addClass(ACC.navigation.ACTIVE_CLASS);
        } else {
          $scrollRightBtn.removeClass(ACC.navigation.ACTIVE_CLASS);
        }
      }, TIMEOUT);
    });

    // On click of the arrows
    $scrollLeftBtn.on('click', function () {
      if (!$(this).hasClass(ACC.navigation.ACTIVE_CLASS)) {
        return;
      }
      pos = $mainCatsWrapper.scrollLeft();
      newPos = pos - SCROLL_SIZE;
      navPosition = pos;

      if (navPosition > 0) {
        ACC.navigation.scrollMainCats($mainCatsWrapper, newPos, SCROLL_SPEED, EASE_TYPE);
      }
    });
    $scrollRightBtn.on('click', function () {
      if (!$(this).hasClass(ACC.navigation.ACTIVE_CLASS)) {
        return;
      }
      pos = $mainCatsWrapper.scrollLeft();
      newPos = pos + SCROLL_SIZE;
      navPosition = pos + mainWrapperWidth;
      if (navPosition < mainCatsWidth) {
        ACC.navigation.scrollMainCats($mainCatsWrapper, newPos, SCROLL_SPEED, EASE_TYPE);
      }
    });
  },
  scrollMainCats: function ($mainCatsObj, newPos, scrollSpeed, easeType) {
    $mainCatsObj.animate({ scrollLeft: newPos }, scrollSpeed, easeType);
  },
  bindMoreCats: function () {
    enquire.register('screen and (min-width:' + ACC.breakpoints.screenMdMin + ')', {
      match: function () {
        ACC.navigation.cloneMoreCats();
        ACC.global.bindHoverIntentMainNavigation();
      }
    });
  },

  cloneMoreCats: function () {
    var $moreList = $('.js-moreCatsList');
    var $moreCategories = $('.js-more-category');
    var $clonedCategories = $moreCategories.clone();
    var SECONDARY_CLASS = 'yCmsComponent nav__link--secondary';
    var $moreCatsUpdated = $clonedCategories.map(function (obj) {
      $clonedCategories[obj].className = SECONDARY_CLASS;
      return $clonedCategories[obj];
    });

    $moreList.html('').append($moreCatsUpdated);
  },

  bindMobileSubMenu: function () {
    $('.js-toggleMobileSub').on('click', function (event, action) {
      //action parameter has been introduced because click on this element is triggered from acc.global.js
      //as we want to close Sub Menu when CLOSE in top menu is clicked. In that case we want to force removeClass action.
      var actionName = action || 'toggle';
      var $this = $(this);
      var targetId = $this.data('target-id');
      $this[actionName + 'Class'](ACC.navigation.ACTIVE_CLASS);
      // Find element js-destMobileSub data has matching data
      $(".js-destMobileSub[data-destination-id='" + targetId + "']")[actionName + 'Class'](ACC.navigation.ACTIVE_CLASS);
    });
  },

  bindTabletAboutNav: function () {
    // includes fixes for larger/newer Ipad devices as well as mobile dropdown for broken deskptop view on larger devices
    enquire.register('screen and (min-width:' + ACC.breakpoints.screenSmMin + ')', {
      match: function () {
        if (ACC.global.isIpad()) {
          $(ACC.navigation.MORE_ABOUT_LINKS_CLASS).on('click', ACC.navigation.toggleMoreLinksActive);
          $(ACC.navigation.ITEM_DRILLDOWN_CLASS).on('click', ACC.navigation.handleTabletAboutNavClick);
        }
      },
      unmatch: function () {
        $(ACC.navigation.MORE_ABOUT_LINKS_CLASS).off('click', ACC.navigation.toggleMoreLinksActive);
        $(ACC.navigation.ITEM_DRILLDOWN_CLASS).off('click', ACC.navigation.handleTabletAboutNavClick);
      }
    });
    // only tablet devices below the large tablet breakpoint
    enquire.register('screen and (max-width:' + ACC.breakpoints.screenSmMax + ')', {
      match: function () {
        if (!ACC.global.isIpad()) {
          $(ACC.navigation.MORE_ABOUT_LINKS_CLASS).on('click', ACC.navigation.toggleMoreLinksActive);
          $(ACC.navigation.ITEM_DRILLDOWN_CLASS).on('click', ACC.navigation.handleTabletAboutNavClick);
        }
      },
      unmatch: function () {
        $(ACC.navigation.MORE_ABOUT_LINKS_CLASS).off('click', ACC.navigation.toggleMoreLinksActive);
        $(ACC.navigation.ITEM_DRILLDOWN_CLASS).off('click', ACC.navigation.handleTabletAboutNavClick);
      }
    });
    // all devices above the tablet breakpoint
    enquire.register('screen and (min-width:' + ACC.breakpoints.screenMdMin + ')', {
      match: function () {
        if (!ACC.global.isIpad()) {
          $(ACC.navigation.ITEM_DRILLDOWN_CLASS).hoverIntent(
            function () {
              $(this).addClass(ACC.navigation.ACTIVE_CLASS);
            },
            function () {
              $(this).removeClass(ACC.navigation.ACTIVE_CLASS);
            }
          );
        }
      },
      unmatch: function () {
        $(ACC.navigation.ITEM_DRILLDOWN_CLASS).hoverIntent(function () {
          // remove hover intent
        });
      }
    });
  },

  handleTabletAboutNavClick: function (e) {
    var $linkTarget = $(e.target);
    var $linkWrapper = $(e.currentTarget);
    var isSubNavItem = $linkTarget.hasClass(ACC.navigation.SUB_NAV_CLASS) || $linkTarget.parent().hasClass(ACC.navigation.SUB_NAV_CLASS);

    if (!isSubNavItem) {
      e.preventDefault();
      ACC.navigation.toggleListDrillDown($linkWrapper);
    } else {
      if (e.target.nodeName != 'A') {
        ACC.navigation.navigateToSubLink($linkTarget);
      }
    }
  },

  navigateToSubLink: function (linkTarget) {
    // find the link and navigate
    var urlTarget = linkTarget.find('a').attr('href');
    if (urlTarget) {
      window.location = encodeURI(urlTarget);
    }
  },

  toggleListDrillDown: function ($linkWrapper) {
    if ($linkWrapper.hasClass(ACC.navigation.ACTIVE_CLASS)) {
      $linkWrapper.removeClass(ACC.navigation.ACTIVE_CLASS);
      $linkWrapper[0].dispatchEvent(new window.MouseEvent('mouseout'));
    } else {
      $(ACC.navigation.ITEM_DRILLDOWN_CLASS).removeClass(ACC.navigation.ACTIVE_CLASS);
      $linkWrapper.addClass(ACC.navigation.ACTIVE_CLASS);
    }
  },

  toggleMoreLinksActive: function () {
    $(ACC.navigation.MORE_ABOUT_LINKS_CLASS).toggleClass(ACC.navigation.ACTIVE_CLASS);
    $(ACC.navigation.ABOUT_LINKS_CLASS).toggleClass(ACC.navigation.ACTIVE_CLASS);
  },
  initNavModal: function () {
    var $content = $('.js-userDetails');
    var $mobileTarget = $('.js-userDetailsMobileTarget');
    var $desktopTarget = $('.js-userDetailsDesktopTarget');

    enquire.register('screen and (max-width:' + ACC.breakpoints.screenXsMax + ')', {
      match: function () {
        ACC.navigation.detachContent($content, $mobileTarget);
      }
    });
    enquire.register('screen and (min-width:' + ACC.breakpoints.screenSmMin + ')', {
      match: function () {
        ACC.navigation.detachContent($content, $desktopTarget);
      }
    });
  },
  detachContent: function ($content, $target) {
    $content.detach();
    $target.append($content);
  }
};

export default navigation;
