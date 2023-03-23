const monetate = {
  staticListOfProducts: window.monetateProductList,
  dynamicProducts: [],
  pageId: ACC.config.pageId,
  buildProduct: function (productData) {
    var product = {
      productId: productData.product.code,
      quantity: productData.quantity.toString(),
      unitPrice: productData.basePrice.value.toFixed(2).toString(),
      currency: productData.basePrice.currencyIso
    };

    return product;
  },
  updateProductsRows: function (allCartProducts, product) {
    var newList = allCartProducts.map(function (el) {
      if (el.productId === product.productId) {
        el = product;
      }
      return el;
    });

    return newList;
  },
  containsObject: function (obj, list) {
    var i;
    for (i = 0; i < list.length; i++) {
      if (list[i].productId === obj.productId) {
        return true;
      }
    }

    return false;
  },
  updateCart: function (data) {
    var productObj = ACC.monetate.buildProduct(data);
    var allCartProducts = window.CartProducts || [];
    var isExisting = ACC.monetate.containsObject(productObj, allCartProducts);

    if (isExisting) {
      allCartProducts = ACC.monetate.updateProductsRows(allCartProducts, productObj);
    } else {
      allCartProducts.push(productObj);
    }

    window.CartProducts = allCartProducts;

    window.monetateQ = window.monetateQ || [];
    window.monetateQ.push(['setPageType', 'miniCart']);
    window.monetateQ.push(['addProductDetails', [productObj.productId]]);
    window.monetateQ.push(['addCartRows', allCartProducts]);
    window.monetateQ.push(['trackData']);
  },
  updateProductsList: function (data) {
    var updatedList = [];

    data.productReferences.filter(function (productData) {
      ACC.monetate.dynamicProducts.push(productData.target.code);
    });

    updatedList = ACC.monetate.staticListOfProducts.concat(ACC.monetate.dynamicProducts);

    ACC.monetate.pushToMonetate(updatedList, ACC.monetate.pageId);
  },
  clearSimilarProductsList: function () {
    if (ACC.monetate.dynamicProducts.length) {
      ACC.monetate.dynamicProducts = [];
      ACC.monetate.pushToMonetate(ACC.monetate.staticListOfProducts, ACC.monetate.pageId);
    }
  },

  loadMore: function (prodCodeList, pageId) {
    var newProdCodeList = prodCodeList;
    ACC.monetate.staticListOfProducts = prodCodeList;
    if (ACC.monetate.dynamicProducts.length) {
      newProdCodeList = prodCodeList.concat(ACC.monetate.dynamicProducts);
    }

    ACC.monetate.pushToMonetate(newProdCodeList, pageId);
  },
  pushToMonetate: function (productsList, pageId) {
    window.monetateQ.push(['setPageType', pageId]);
    window.monetateQ.push(['addProducts', productsList]);
    window.monetateQ.push(['trackData']);
  }
};

export default monetate;
