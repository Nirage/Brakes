const facets = {
  _autoload: [['init', $('.js-product-facet').length]],
  facetsTemplate: '',
  baseURL: '',
  searchTerm: '',
  sort: '',
  appliedFiltersThreshold: 3,
  facetAppliedLink: '',
  decodeHTMLEntities: '',
  facetsApplied: [],
  facetsToApply: [],
  ENCODED_PERCENTAGE: '%25',
  DISCLAIMER_ACCEPTED: 'false',
  NUTSALLERGENSLIST: [],
  init() {
    //this returns function for decoding of HTML entities
    //e.g. &#x3a;relevance&#x3a;dietaryandlifestyle&#x3a;Contains&#x2b;Omega&#x2b;3 will be decoded to
    //:relevance:dietaryandlifestyle:Contains+Omega+3
    this.decodeHTMLEntities = this.decodeEntities();
    const $initialData = $('.js-facetsInitialData');
    const queryURL = $initialData.data('query-url');
    this.baseURL = queryURL.substr(0, queryURL.indexOf('?'));
    this.searchTerm = $initialData.data('search-term');
    this.sort = $initialData.data('initial-sort');
    if (ACC.config.recentPage) {
      this.weeksInPast = parseInt($('.jsWeeksInPast').val());
    }

    $(document).on('click', '.js-facetClearAll', this.clearAllFacetHandler.bind(this));
    $(document).on('click', '.js-facetCheckbox', this.facetCheckHandler.bind(this));
    $(document).on('click', '.js-facetAppliedSeeMore', this.onFacetApplySeeMore);
    $(document).on('click', '.js-facetTitle', this.toggleFacetGroup);
    $(document).on('click', '.js-facetAppliedLink', this.removeAppliedFacet.bind(this));
    $(document).on('click', '.js-disclaimerAccept', this.allergensFacetShow);
    $(document).on('click', '.js-disclaimerDecline', () => ACC.facets.allergensFacetHide('firstload'));
    $(document).on('click', '.js-nutsAllergen', (e) => ACC.facets.toggleNutsAllergens(e));

    var handlebarsPartials = ['facetsAppliedFiltersPartial', 'facetsRefinementPartial'];
    ACC.global.registerHandlebarsPartials(handlebarsPartials);

    if (sessionStorage.getItem('disclaimerAccepted') === 'false' || !sessionStorage.getItem('disclaimerAccepted')) {
      this.allergensFacetHide('firstload');
    } else if (sessionStorage.getItem('disclaimerAccepted') === 'true') {
      this.allergensFacetShow('onload');
    }
  },

  replaceCharsInFacetValue(facetValue) {
    return facetValue
      .toString()
      .replace(/ /g, '+') // Space " " needs to be replaced with "+"
      .replace(/\|/g, '%7C') // Pipe "|"
      .replace(/&#x25;/g, this.ENCODED_PERCENTAGE) // Percentage "%"
      .replace(/\(/g, '%28') // Open bracket "("
      .replace(/\)/g, '%29'); // Close bracket ")"
  },

  checkSubcategory() {
    $('.js-facetTitle').each(() => ACC.facets.getSubCategory());
  },

  getSubCategory() {
    var $levelOneCategory = $('.js-facetCheckbox[data-facetCode="levelOneCategories"]');
    var $levelTwoCategory = $('.js-facetTitle[data-facetCode="levelTwoCategories"]');
    var flag = false;

    $levelOneCategory.each(function () {
      if ($(this).is(':checked')) {
        flag = true;
        return;
      }
    });
    if ($levelTwoCategory.length && flag) {
      $levelTwoCategory.removeAttr('disabled');
    } else if ($levelTwoCategory.length && flag == false) {
      $levelTwoCategory.attr('disabled', 'disabled');
      if (!$levelTwoCategory.next('.js-facet-form').hasClass('hide')) {
        ACC.facets.toggleFacetGroup($levelTwoCategory);
      }
    }
  },

  setNutsAllergens() {
    var $nutsAllergen = $('.js-facetListItem[data-facet-value*="Nuts"]');
    var $nutsAllergenForm = $nutsAllergen.find('form');
    var $cheveronDown = "<span class='js-nutsAllergen icon icon--sm icon-chevron-down'></span>";

    $nutsAllergenForm.addClass('facet__list-item--left');
    var $nutsAllergensItem = $('.js-facetTitle[data-facetCode="nutsallergens"]');
    var $nutsFacetListItem = $nutsAllergensItem
      .next('.js-facet-values')
      .find('.js-facet-list')
      .find('.facet__list-item');
    if (this.NUTSALLERGENSLIST.length < 1) {
      this.NUTSALLERGENSLIST = $nutsFacetListItem;
    }
    if ($nutsAllergen.find('.icon').length < 1) {
      $nutsAllergen.append($cheveronDown);
    }
    if (this.NUTSALLERGENSLIST.length < 1) {
      $nutsAllergen.find($('.js-nutsAllergen')).addClass('invisible');
    }
    this.NUTSALLERGENSLIST.css('margin-left', 20);
    $nutsAllergen.after(this.NUTSALLERGENSLIST);
    $nutsAllergensItem.addClass('hide');
    this.NUTSALLERGENSLIST.addClass('hide');

    var $dataFacetCode;
    var $facetCheckbox;
    var $isNutsChecked;

    $('.js-facetListItem').each(function () {
      $dataFacetCode = $(this).attr('data-facet-value');
      $facetCheckbox = $(this).find('.js-facetCheckbox');
      if ($dataFacetCode.includes('Nuts')) {
        if ($facetCheckbox.is(':checked')) {
          $isNutsChecked = true;
        }
      } else if ($dataFacetCode.includes('All allergens')) {
        var $facets = $('.js-facet[data-facetCode ="allergens"]');
        var $allergensFacetList = $facets.find('.js-facetListItem').addClass('facet-disabled');
        var $allergensFacetCheckbox = $allergensFacetList.find('.js-facetCheckbox');
        if ($facetCheckbox.is(':checked')) {
          $allergensFacetCheckbox.attr('disabled', true);
          $allergensFacetCheckbox.attr('checked', true);
          $(this).removeClass('facet-disabled');
          $(this).find('.js-facetCheckbox').attr('disabled', false);
        } else {
          $('.js-facetListItem').removeClass('facet-disabled');
          $allergensFacetCheckbox.attr('disabled', false);
          $allergensFacetCheckbox.attr('checked', false);
        }
      }
    });
    var $nutsFacetCheckbox = this.NUTSALLERGENSLIST.find('.js-facetCheckbox');
    if ($isNutsChecked) {
      this.NUTSALLERGENSLIST.addClass('facet-disabled');
      $nutsFacetCheckbox.attr('disabled', true);
      $nutsFacetCheckbox.attr('checked', true);
    } else {
      this.NUTSALLERGENSLIST.removeClass('facet-disabled');
      $nutsFacetCheckbox.attr('disabled', false);
      $nutsFacetCheckbox.attr('checked', false);
    }
  },
  toggleNutsAllergens(e) {
    ACC.facets.NUTSALLERGENSLIST.toggleClass('hide');
    $(e.currentTarget).toggleClass('icon-chevron-down icon-chevron-up');
  },

  allergensFacetShow(action) {
    var $allergensFacet = $('.js-facetTitle[data-facetCode="allergens"]');
    var $allergensFacetList = $allergensFacet.next('.js-facet-values').find('.js-facet-list');
    $allergensFacet.removeClass('hide');
    $('.js-facetDisclaimer').addClass('hide');
    $allergensFacetList.removeClass('hide');

    this.DISCLAIMER_ACCEPTED = true;
    sessionStorage.setItem('disclaimerAccepted', this.DISCLAIMER_ACCEPTED);

    if (sessionStorage.getItem('disclaimerAccepted') === 'true' && action != 'onload') {
      ACC.facets.toggleFacetGroup($allergensFacet);
    }
  },
  allergensFacetHide(action) {
    var $allergensFacet = $('.js-facetTitle[data-facetCode="allergens"]');
    var $allergensFacetList = $allergensFacet.next('.js-facet-values').find('.js-facet-list');

    if (action == 'firstload') {
      $('.js-facetDisclaimer').addClass('hide');
      $allergensFacet.removeClass('hide');
    } else {
      $('.js-facetDisclaimer').removeClass('hide');
      $allergensFacet.addClass('hide');
    }
    $allergensFacetList.addClass('hide');
    this.DISCLAIMER_ACCEPTED = false;
    sessionStorage.setItem('disclaimerAccepted', this.DISCLAIMER_ACCEPTED);
  },

  facetCheckHandler(e) {
    const $facetCheckbox = $(e.target);
    const newQuery = this.calcNewQuery($facetCheckbox);
    const updateQuery = `?q=${newQuery}`;
    const baseUrl = `${this.baseURL}${ACC.config.resultFacet}${updateQuery}`;
    const resultsURL = () => {
      if (ACC.config.recentPage) {
        return `${baseUrl}&weeksInPast=${this.weeksInPast}`;
      } else if (ACC.config.promoPage) {
        return `${ACC.config.promoResultFacet}${updateQuery}`;
      }
      return baseUrl;
    };

    this.getResults(resultsURL());
  },

  calcUrlSearchterm() {
    var urlSearchTerm = '';
    if (this.searchTerm) {
      urlSearchTerm = this.replaceCharsInFacetValue(this.searchTerm);
      if (urlSearchTerm.indexOf(this.ENCODED_PERCENTAGE) == -1) {
        urlSearchTerm = encodeURIComponent(this.searchTerm);
      }
    }
    return urlSearchTerm;
  },

  calcNewQuery($facetCheckbox) {
    const newQuery = $facetCheckbox.parents('.js-facetListItem').find("[name='q']").val();
    if (newQuery) {
      if (newQuery.indexOf(ACC.facets.ENCODED_PERCENTAGE) == -1) {
        return encodeURIComponent(newQuery);
      } else {
        return ACC.facets.replaceCharsInFacetValue(newQuery);
      }
    }
    return newQuery;
  },

  toggleFacetGroup(e) {
    const target = e.currentTarget || e[0];
    const values = target.closest('.js-facet').querySelector('.js-facet-values');
    const icon = target.querySelector('.icon');

    target.scrollIntoView({ behavior: 'smooth' });

    if (target.dataset['facetcode'] === 'allergens') {
      if (sessionStorage.getItem('disclaimerAccepted') === 'true') {
        values.classList.toggle('hide');
        icon.classList.toggle('icon-chevron-down');
        icon.classList.toggle('icon-chevron-up');
      } else {
        ACC.facets.allergensFacetHide('none');
      }
    } else {
      values.classList.toggle('hide');
      icon.classList.toggle('icon-chevron-down');
      icon.classList.toggle('icon-chevron-up');
    }
  },

  onFacetApplySeeMore() {
    $('.js-facetApplied').removeClass('hide');
    $('.js-moreAppliedFiltersCount, .js-facetAppliedSeeMore').remove();
  },

  removeAppliedFacet(e) {
    e.preventDefault();
    const currentTarget = e.currentTarget;
    const dataSet = currentTarget.dataset;
    const removeFacetQuery = `:${dataSet.facetCode}:${this.replaceCharsInFacetValue(dataSet.facetValueCode)}`;
    const facetIndex = this.facetsToApply.indexOf(removeFacetQuery);
    const url = currentTarget.href;
    const removeFacetUrl = url.split('?')[1];
    const decodedRemoveFacetUrl = this.decodeHTMLEntities(removeFacetUrl);
    const resultUrl = ACC.config.promoPage ? ACC.config.promoResultFacet : this.baseURL + ACC.config.resultFacet;

    this.facetsToApply.splice(facetIndex, 1);
    this.facetsApplied = this.facetsToApply;
    this.resultThenChecks(`${resultUrl}?${decodedRemoveFacetUrl}`);
  },

  clearAllFacetHandler(e) {
    const target = e.target;
    const url = ACC.config.promoPage ? '/my-promo-products' : this.baseURL;
    const searchTerm = this.calcUrlSearchterm(target.dataset['searchTerm']);
    const updateUrl = `${url}${ACC.config.resultFacet}?q=${searchTerm}:${this.sort}`;
    const resultUrl = ACC.config.recentPage ? `${updateUrl}&weeksInPast=${this.weeksInPast}` : updateUrl;

    this.facetsToApply = [];
    this.resultThenChecks(resultUrl);
  },

  resultThenChecks(url) {
    this.getResults(url).then(() => {
      ACC.facets.checkSubcategory();
      ACC.facets.setNutsAllergens();
    });
  },

  getResults(url) {
    $('.js_spinner').show();
    return $.ajax({
      type: 'GET',
      url: url,
      dataType: 'json',
      success: ACC.facets.facetsResultSuccess,
      error() {
        console.warn('Error retrieving products list');
      }
    });
  },

  facetsResultSuccess(response) {
    var productsData = {
      results: response.results,
      pagination: response.pagination,
      currentQuery: response.currentQuery
    };
    var facetsData = {
      breadcrumbs: response.breadcrumbs,
      facets: response.facets,
      categoryCode: response.categoryCode,
      freeTextSearch: response.freeTextSearch,
      hiddenFiltersCount: response.breadcrumbs.length - ACC.facets.appliedFiltersThreshold
    };

    ACC.facets.renderProducts(productsData);

    if (ACC.config.plp || ACC.config.search) {
      ACC.plp.updateMonetateProductCodes(response, 'replace');
    }
    ACC.facets.renderFacets(ACC.facets.facetsUrlEspcapeFix(facetsData));
    ACC.gtmDataLayer.updateFacetResponse(facetsData, productsData);

    $('.js_spinner').hide();
    document.querySelector('.js-facetsApply')?.disabled = false;
  },

  facetsUrlEspcapeFix(facetsData) {
    facetsData.facets.forEach(function (facetItem) {
      facetItem.values.forEach(function (facetItemValue) {
        facetItemValue.query.query.value = ACC.facets.replaceCharsInFacetValue(facetItemValue.query.query.value);
      });
    });
    return facetsData;
  },

  renderFacets(data) {
    const facetsTemplate = ACC.global.compileHandlebarTemplate('#facetsTemplate');
    const facetsAppliedFiltersPartial = ACC.global.compileHandlebarTemplate('#facetsAppliedFiltersPartial');
    const updateFacets = facetsTemplate({ ...data, appliedFiltersThreshold: 3 });
    const updateFacetsAppliedFilters = facetsAppliedFiltersPartial({ ...data, appliedFiltersThreshold: 6 });
    document.getElementById('applied-filters').innerHTML = updateFacetsAppliedFilters;
    document.getElementById('facet-overlay').querySelector('.js-facetContent').innerHTML = updateFacets;
    const facetSize = data.breadcrumbs.length;
    document.querySelector('.js-facet-appled-size').innerHTML = facetSize ? `(${facetSize})` : '';
  },

  renderProducts(productsData) {
    // var searchUrl = productsData.currentQuery.url.substr(0, productsData.currentQuery.url.indexOf("?"));
    // var baseUrl = searchUrl + "?q=" + this.decodeHTMLEntities(productsData.currentQuery.query.value);
    ACC.plp.renderMoreProducts(productsData, 'replace');
    this.renderLoadMoreBtns(productsData.pagination, productsData.currentQuery);
    ACC.plp.updatePageUrl(
      productsData.pagination,
      productsData.currentQuery.paginationUrl,
      productsData.pagination.sort
    );
    this.updateDisplayedResultsCounter(productsData.results.length, productsData.pagination);
  },

  updateDisplayedResultsCounter(numberOfResultsLoaded, pagination) {
    const $displayingCounterTotal = $('.js-displayingCounterTotal');
    const $searchPageTotalCount = $('.js-searchPageTotalCount');
    ACC.plp.$displayingCounter.text(numberOfResultsLoaded);
    $displayingCounterTotal.text(pagination.totalNumberOfResults);
    $searchPageTotalCount.text(pagination.totalNumberOfResults);
  },

  renderLoadMoreBtns(pagination, currentQuery) {
    var hasPreviousPage = pagination.currentPage > 1 ? true : false;
    var hasNextPage = pagination.currentPage < pagination.numberOfPages ? true : false;
    var moreBtnData, loadMoreBtnHtml;
    var searchUrl = currentQuery.url.substr(0, currentQuery.url.indexOf('?'));

    currentQuery.query.value = this.decodeHTMLEntities(currentQuery.query.value);

    if (hasNextPage) {
      moreBtnData = {
        action: 'append',
        customCSSClass: 'h-space-4',
        pageToLoadGetParam: pagination.currentPage + 1,
        currentQuery: currentQuery,
        searchUrl: searchUrl
      };
      loadMoreBtnHtml = ACC.plp.loadMoreBtnTemplate(moreBtnData);
      ACC.plp.$grid.after(loadMoreBtnHtml);
    } else if (hasPreviousPage) {
      moreBtnData = {
        action: 'prepend',
        customCSSClass: 'h-space-2',
        pageToLoadGetParam: pagination.currentPage - 1,
        currentQuery: currentQuery
      };
      loadMoreBtnHtml = ACC.plp.loadMoreBtnTemplate(moreBtnData);
      ACC.plp.$grid.before(loadMoreBtnHtml);
    }

    if (ACC.productprice) {
      ACC.productprice.loadPrices();
    }
  },

  decodeEntities() {
    // this prevents any overhead from creating the object each time
    var element = document.createElement('div');

    function decodeHTMLEntities(str) {
      if (str && typeof str === 'string') {
        // strip script/html tags
        str = str.replace(/<script[^>]*>([\S\s]*?)<\/script>/gim, '');
        str = str.replace(/<\/?\w(?:[^"'>]|"[^"]*"|'[^']*')*>/gim, '');
        element.innerHTML = str;
        str = element.textContent;
        element.textContent = '';
      }
      return str;
    }
    return decodeHTMLEntities;
  }
};

export default facets;
