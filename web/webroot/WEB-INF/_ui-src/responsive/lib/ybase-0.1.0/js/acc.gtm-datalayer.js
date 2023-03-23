const gtmDataLayer = {
  trackAddListToCart: function (products) {
    var gtmObject = {
      event: 'ga_event',
      enhanced: 1,
      ga_event: {
        category: 'add to basket',
        action: 'List',
        label: 'List All',
        value: 0,
        nonInteraction: 0
      },
      ecommerce: {
        currencyCode: ACC.config.currencyISO,
        add: {
          products: products
        }
      }
    };
    return gtmObject;
  },

  trackProductCart: function (cartData, actionSource, trackingQuantity, action) {
    var transformProducts = ACC.gtmDataLayer.transformGTMProducts(cartData, [cartData.product], trackingQuantity);
    var name = transformProducts[0].name.replace(/(&amp;)/g, '&');
    var gtmObject = {
      event: 'ga_event',
      enhanced: 1,
      ga_event: {
        category: action === 'add' ? 'add to basket' : 'remove from basket',
        action: actionSource,
        label: name,
        value: 0,
        nonInteraction: 0
      },
      ecommerce: {
        currencyCode: ACC.config.currencyISO,
        quantity: trackingQuantity,
        name: name,
        id: transformProducts[0].id,
        brand: transformProducts[0].brand,
        price: transformProducts[0].price,
        category: transformProducts[0].category,
        add: {
          products: transformProducts
        }
      }
    };

    // Only on clear reload
    if (action === 'clear') gtmObject = ACC.gtmDataLayer.extendPageReloadEvent(gtmObject);

    ACC.gtmDataLayer.pushToGTMLayer(gtmObject);
  },

  getProductCategoryName: function (productCategories) {
    if (productCategories) {
      var categoryNameJoined = productCategories
        .map(function (category) {
          return category.name;
        })
        .join('_');
      return categoryNameJoined;
    }
    return undefined;
  },

  getProductPricing: function (cartData) {
    if (cartData.basePrice) {
      if (cartData.basePrice.value) {
        return cartData.basePrice.value;
      } else if (cartData.basePrice.formattedValue) {
        if (cartData.basePrice.formattedValue.indexOf('£') > -1) {
          return cartData.basePrice.formattedValue.substring(1);
        }
        return cartData.basePrice.formattedValue;
      }
    } else if (cartData.price) {
      return cartData.price.value;
    }
    return 'Pricing Unavailable';
  },

  getPageSource: function (formElement) {
    if ($('.mini-basket__boundary').hasClass('is-mb-active')) {
      return 'MiniBasket';
    } else if (ACC.config.plp) {
      return 'PLP';
    } else if (ACC.config.pdp) {
      return 'PDP';
    } else if (ACC.config.search) {
      return 'SRP';
    } else if (ACC.config.favouriteslist) {
      return 'Favourites List';
    } else if (ACC.config.checkoutPage) {
      return 'Checkout';
    } else if (ACC.config.cartPage) {
      return 'Basket';
    } else {
      if (formElement && formElement.parent()) {
        return formElement.parent().attr('class');
      } else {
        return 'Unknown Page Source';
      }
    }
  },

  updateGTMLoadMore: function (response, $loadMoreButton) {
    window.productListObject = window.productListObject.concat(response.results);

    ACC.gtmDataLayer.pushToGTMLayer(ACC.gtmDataLayer.transformLoadMoreData(response, $loadMoreButton));
  },

  updatePriceEngineResponse: function (response) {
    if (!ACC.config.pdp || ACC.config.checkoutPage) {
      return false;
    }
    ACC.gtmDataLayer.pushToGTMLayer(ACC.gtmDataLayer.transformPricingEngineResponse(response));
  },

  updateFacetResponse: function (facetsData, productsData) {
    window.productListObject = productsData.results;

    var gtmFacetData = $.extend(true, productsData, { freeTextSearch: ACC.gtmDataLayer.decodeSearchTerm(facetsData.freeTextSearch) });

    ACC.gtmDataLayer.pushToGTMLayer(ACC.gtmDataLayer.trasformFacetsDataResponse(gtmFacetData));
  },

  updateGtmFavouritesAddListAndReload: function (cartModifications) {
    var gtmDataObject = ACC.gtmDataLayer.trackAddListToCart(ACC.gtmDataLayer.transformCartModifications(cartModifications));
    gtmDataObject = ACC.gtmDataLayer.extendPageReloadEvent(gtmDataObject);
    ACC.gtmDataLayer.pushToGTMLayer(gtmDataObject);
  },

  transformCartModifications: function (cartModifications) {
    var normalizedProductsList = cartModifications.map(function (product) {
      var normalizedProduct = {
        id: (product.prefix ? product.prefix : '') + product.id,
        name: unescape(product.name.replace(/(&amp;)/g, '&')),
        price: product.price,
        brand: product.brand,
        category: product.category,
        quantity: product.quantity
      };
      return normalizedProduct;
    });
    return normalizedProductsList;
  },

  findDataLayerPushObj: function () {
    var pushedObject;
    if (window.dataLayer) {
      window.dataLayer.forEach(function (dataLayerItem) {
        if (dataLayerItem.event == 'dataLoaded') {
          pushedObject = dataLayerItem;
        }
      });
      return pushedObject;
    }
    return pushedObject;
  },

  transformPricingEngineResponse: function (response) {
    // This is only instantiated for PDP
    var tempPriceLoadData = {
      event: 'ga_event',
      ga_event: {
        category: 'PDP',
        action: 'Product Detail View',
        label: window.productListObject[0].name || '',
        value: 0,
        nonInteraction: 0
      },
      enhanced: 1,
      user: {},
      page: {},
      ecommerce: {
        currencyCode: ACC.config.currencyISO,
        detail: {
          products: ACC.gtmDataLayer.transformPricingEngineProducts(response.prices)
        }
      }
    };
    var dataLayerExistingObj = ACC.gtmDataLayer.findDataLayerPushObj();
    if (dataLayerExistingObj) {
      tempPriceLoadData = ACC.gtmDataLayer.extendUserData(tempPriceLoadData, dataLayerExistingObj);
      tempPriceLoadData = ACC.gtmDataLayer.extendPageData(tempPriceLoadData, dataLayerExistingObj);
    }
    return tempPriceLoadData;
  },

  transformPricingEngineProducts: function (products) {
    var transformedProductPrices = [];
    for (var i = 0; i < products.length; i++) {
      var prodItem = products[i];
      var productCode = prodItem.productCode ? prodItem.productCode : prodItem.code;
      for (var p = 0; p < window.productListObject.length; p++) {
        var productListItem = window.productListObject[p];
        if (productListItem.id == productCode || productListItem.code == productCode || productCode == productListItem.sapProductCode) {
          if (prodItem.price) {
            productListItem.price = prodItem.price.value;
          }

          if (!productListItem.category) {
            productListItem.category = ACC.gtmDataLayer.getProductCategoryName(productListItem.categories);
          }

          if (productListItem.brand && !productListItem.manufacturer) {
            productListItem.manufacturer = productListItem.brand;
          }

          var tempProdItem = {
            brand: productListItem.manufacturer ? productListItem.manufacturer : undefined,
            id: (productListItem.prefix ? productListItem.prefix : '') + productListItem.id,
            price: productListItem.price,
            name: productListItem.name,
            category: productListItem.category
          };
          transformedProductPrices.push(tempProdItem);
        }
      }
    }

    return transformedProductPrices;
  },

  transformLoadMoreData: function (response, $loadMoreButton) {
    var tempPageLoadData = {
      event: 'dataLoaded',
      enhanced: 0,
      user: {},
      page: {
        type: ACC.gtmDataLayer.getPageSource($loadMoreButton),
        number: response.pagination.currentPage,
        vpv: $loadMoreButton.data('url'),
        searchTerm: ACC.gtmDataLayer.decodeSearchTerm(response.freeTextSearch)
      }
    };

    var dataLayerExistingObj = ACC.gtmDataLayer.findDataLayerPushObj();
    if (dataLayerExistingObj) {
      tempPageLoadData = ACC.gtmDataLayer.extendUserData(tempPageLoadData, dataLayerExistingObj);
    }
    return tempPageLoadData;
  },

  trasformFacetsDataResponse: function (response) {
    var facetPageLoadData = {
      event: 'dataLoaded',
      enhanced: 0,
      user: {},
      page: {
        type: ACC.gtmDataLayer.getPageSource(),
        number: response.pagination.currentPage,
        vpv: response.currentQuery.url,
        searchTerm: ACC.gtmDataLayer.decodeSearchTerm(response.freeTextSearch)
      }
    };
    var dataLayerExistingObj = ACC.gtmDataLayer.findDataLayerPushObj();
    if (dataLayerExistingObj) {
      facetPageLoadData = ACC.gtmDataLayer.extendUserData(facetPageLoadData, dataLayerExistingObj);
      if (typeof dataLayerExistingObj.page == 'object') {
        dataLayerExistingObj.page.vpv = response.currentQuery.url;
      }
    }
    return facetPageLoadData;
  },

  transformGTMProducts: function (cartData, products, trackingQuantity) {
    var transformedProducts = [];
    for (var i = 0; i < products.length; i++) {
      var prodItem = products[i];
      var categoryName = ACC.gtmDataLayer.getProductCategoryName(prodItem.categories);

      var tempProd = {
        id: (prodItem.prefix ? prodItem.prefix : '') + prodItem.code,
        name: unescape(prodItem.name.replace(/(&amp;)/g, '&')),
        price: ACC.gtmDataLayer.getProductPricing(cartData),
        brand: prodItem.manufacturer ? prodItem.manufacturer : undefined,
        category: categoryName,
        quantity: trackingQuantity
      };
      transformedProducts.push(tempProd);
    }
    return transformedProducts;
  },

  decodeSearchTerm: function (searchTerm) {
    if (searchTerm) {
      searchTerm = searchTerm.replace(/&#x20;/g, ' ');
    }
    return searchTerm;
  },

  extendUserData: function (itemData, dataLayerExistingObj) {
    if (typeof dataLayerExistingObj.user == 'object') {
      return $.extend(true, itemData, { user: dataLayerExistingObj.user });
    }
    return itemData;
  },

  trackAddPaymentCard: function (actionSource) {
    var gtmObject = {
      event: 'ga_event',
      enhanced: 1,
      ga_event: {
        category: 'Card payment',
        action: actionSource
      }
    };
    ACC.gtmDataLayer.pushToGTMLayer(gtmObject);
  },

  extendPageReloadEvent: function (gtmObject) {
    return $.extend(true, gtmObject, {
      eventCallback: function () {
        window.location.reload();
      },
      eventTimeout: 2000
    });
  },

  extendPageData: function (itemData, dataLayerExistingObj) {
    if (typeof dataLayerExistingObj.page == 'object') {
      return $.extend(true, itemData, { page: dataLayerExistingObj.page });
    }
    return itemData;
  },

  pushToGTMLayer: function (gtmObject) {
    window.dataLayer.push(gtmObject);
  }
};

export default gtmDataLayer;
