<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- Begin Monetate ExpressTag Sync v8.1. Place at start of document head. DO NOT ALTER. --%>
<script type="text/javascript">
var monetateT = new Date().getTime();
</script>
<script type="text/javascript" src="${monetateScriptUrl}"></script>
<%-- End Monetate tag. --%>

<script type="text/javascript">
  window.monetateProductList = [];
  window.monetateQ = window.monetateQ || [];
  window.CartProducts = [];
  window.monetateQ.push([
      "setPageType",
      "${cmsPage.uid}"
  ]);

  <c:if test="${pageType eq 'PRODUCT'}">
    window.monetateQ.push(["addProductDetails", ["${product.code}"]]);
  </c:if>

  <c:if test="${not empty cartMonetateData.cartEntries}">
	<c:forEach items="${cartMonetateData.cartEntries}" var="entry">
	CartProducts.push({
		"productId" : "${entry.productID}",
		"quantity" : "${entry.quantity}",
		"unitPrice" : "${entry.unitPrice}",
		"currency": "GBP"
	});
	</c:forEach>
	window.monetateQ.push([ "addCartRows", CartProducts ]);
	</c:if>


	<c:if test="${pageType eq 'ORDERCONFIRMATION'}">
	var OrderDetails = [];
	<c:forEach items="${orderData.unconsignedEntries}" var="entry">
	OrderDetails.push({
		"purchaseId" : "${orderData.code}",
		"productId" : "${entry.product.code}",
		"quantity" : "${entry.quantity}",
		"unitPrice" : "${entry.basePrice.value}",
		"currency": "GBP"
	});
	</c:forEach>
	window.monetateQ.push([ "addPurchaseRows", OrderDetails ]);
	</c:if>

  	<c:if test="${cmsPage.uid eq 'productGrid' || cmsPage.uid eq 'searchGrid' || cmsPage.uid eq 'recentPurchasedProductsPage'}">
		<c:forEach items="${searchPageData.results}" var="product">
			monetateProductList.push("${product.code}");
		</c:forEach>
		window.monetateQ.push([ "addProducts", monetateProductList ]);
  	</c:if>
	<c:if test="${cmsPage.uid eq 'favouriteItemGrid'}">
		<c:forEach items="${favouriteItemPageData.results}" var="favItem">
			monetateProductList.push(${favItem.product.code});
		</c:forEach>
		window.monetateQ.push([ "addProducts", monetateProductList ]);
	</c:if>

	<c:if test="${cmsPage.uid ne 'productDetails' && cmsPage.uid ne 'favouriteItemGrid' && cmsPage.uid ne 'productGrid' && cmsPage.uid ne 'searchGrid' && cmsPage.uid ne 'recentPurchasedProductsPage'}">
		<c:forEach items="${searchPageData.results}" var="product">
		monetateProductList.push("${product.code}");
		</c:forEach>
		window.monetateQ.push([ "addProducts", monetateProductList ]);
	</c:if>
  window.monetateQ.push(["trackData"]);
</script>
