<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="favourites" tagdir="/WEB-INF/tags/responsive/favourites" %>
<%@ taglib prefix="favourite" tagdir="/WEB-INF/tags/responsive/favourite" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components" %>
<%@ taglib prefix="action" tagdir="/WEB-INF/tags/responsive/action" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>

<spring:htmlEscape defaultHtmlEscape="false" />
<c:set var="showVatApplicable" value="false"/>

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
  <c:set var="isLoggedIn" value="true" />
</sec:authorize>

<script type="text/javascript">
	window.monetateComponentProductList = [];
	window.monetateQ = window.monetateQ || [];
	window.monetateQ.push([
	"setPageType",
		"${cmsPage.uid}"
	]);
</script>



<c:set var="numberOfLoadedProducts" value="${fn:length(productData)}" />
<input type="hidden" class="js-initialNumberOfLoadedProducts" value="${numberOfLoadedProducts}">
<input type="hidden" name="itemsPerPage" class="js-productItemTilePerPage" value="${itemsPerPage}"/>

<div class="product__listing product__grid js-plpTile js-PromoEnabledList container">
    <c:forEach items="${productData}" var="product" varStatus="status">
        <c:if test="${status.count > itemsPerPage}">
            <c:set var="addClass" value="hide" />
        </c:if>
        <c:set var="promoIconVisibilityClass" value="${isLoggedIn && product.hasPotentialPromo || !isLoggedIn && not empty product.wasPrice}" />
        <c:url value="${product.url}" var="productUrl" />
        <c:url value="${product.code}" var="productCode" />
        <script type="text/javascript">
			monetateComponentProductList.push("${productCode}");
		</script>
        <div class="product-item ${promoIconVisibilityClass ? 'product-item--promotion-border overflow-hide' : ''} js-productItemBorder js-productItemTile js-productItem mt1 ${(isLoggedIn && not empty product.cartEntry.quantity ? ' is-added' : '')} ${isFavouriteProduct ? ' js-favouriteItem' : ''} ${addClass}" id="product-${productCode}" data-id="${product.code}" data-code="${product.code}" data-favourite="${isFavouriteProduct ? favourite.uid : ''}">
            <div class="product-item__icons product-item__icons--top">
                <div class="item-icons item-icons--promo ${promoIconVisibilityClass ? '' : 'hidden'} js-productPromoIcon" data-code="${productCode}">
                    <span data-code="${product.code}" class="badge badge--promotion"><spring:theme code="product.promotion.offer"></spring:theme></span>
                </div>
                <c:if test="${product.newProduct}">
                    <div class="item-icons item-icons--new  ${showPromotion ? 'item-icons--second' : 'item-icons--first'}">
                        <span class="icon icon-new icon-new--royal-blue"></span>
                    </div>
                </c:if>
                <div class="item-icons item-icons--user-actions text-right js-userActions">
                    <c:if test="${isLoggedIn}">
                        <c:if test="${isRecentlyPurchasedProduct}"> <%-- TODO remove when story is defined --%>
					        <span class="icon icon-recent-purchases" title="buy again"></span>
                        </c:if>
				    </c:if>
                    <c:choose>
                        <c:when test="${isFavouriteProduct}">
                            <favourite:editFavourite favourite="${favourite}" product="${product}" isProduct="true"/>
                        </c:when>
                        <c:otherwise>
                            <product:productAddToFavouritePanel product="${product}"/>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <%-- product-item__thumb qty.overlay --%>
            <a class="product-item__thumb" href="${fn:escapeXml(productUrl)}" title="${fn:escapeXml(product.name)}">
                <c:if test="${isLoggedIn}">
				    <span class="product-item__qty-overlay">
                        <spring:theme code="product.qty.overlay" arguments="${product.cartEntry.quantity}"/>
                    </span>
			    </c:if>
                <product:productPrimaryImage product="${product}" format="product" />
            </a>

            <%-- Item info --%>
            <div class="product-item__info">
                <div class="product-item__code">
                    <a href="${productUrl}"><c:if test="${not empty product.prefix}">${fn:escapeXml(product.prefix)}&nbsp;</c:if>${productCode}</a>
                </div>
                <div class="product-item__advice-icons text-right">
                    <c:forEach items="${product.productInfoIcons}" var="iconClass">
					<span title="<spring:theme code="icon.title.${iconClass}"/>">
                        <img class="product-item__advice-icons-img" src="https://brakes.a.bigcontent.io/v1/static/icon-${iconClass}" alt="${iconClass}"/>
                    </span>
                    </c:forEach>
                </div>
            </div>

            <%-- Item Name --%>
            <ycommerce:testId code="product_productName">
                <c:set var="productName" value="${fn:escapeXml(product.name)}" />
                <a class="product-item__name product-name elipsis-3-line" title="${productName}" href="${fn:escapeXml(productUrl)}">
                    <c:out escapeXml="false" value="${productName}" />
                </a>
            </ycommerce:testId>

            <%-- Item Quantity --%>
            <div class="product-item__qty">
                <c:if test="${product.unitsPerCase gt 1}"> 
                    <a href="${fn:escapeXml(productUrl)}" >
                <spring:theme code="product.grid.caseSize"/>: ${product.unitsPerCase}</a>
                    </c:if>
            </div>

            <%-- Item Price --%>
            <div class="product-item__price js-productItemPrice ${not empty product.wasPrice ? 'has-was-price' : ''}">
                <ycommerce:testId code="product_productPrice">
				    <product:productPricePanel isLoggedIn="${isLoggedIn}" product="${product}"/>
			    </ycommerce:testId>
            </div>

            <%-- Pack Size --%>
            <div class="product-item__size"><spring:theme code="product.grid.packSize"/>: ${product.packSize}</div>

            <%-- Add to cart --%>
            <action:actions element="div" parentComponent="${component}" />
        </div>
    </c:forEach>
    <script type="text/javascript">
        window.monetateQ.push([ "addProducts", monetateComponentProductList ]);
        window.monetateQ.push(["trackData"]);
    </script>
</div>

<c:if test="${product.subjectToVAT eq true}">
  <c:set var="showVatApplicable" value="true"/>
</c:if>

<button class="btn btn-secondary js-plpTileLoadMore product__listing-load-more-btn h-space-4" style="display:none;">
    <spring:theme code="product.grid.loadMore"/>
</button>

<div class="js_spinner spinning-div">
  <img class="spinning-image" src="${themeResourcePath}/images/Spinner-1s-75px.gif" alt="Loading..." />
</div>

<div id="addToCartTitle" class="display-none">
    <div class="add-to-cart-header">
        <div class="headline">
            <span class="headline-text"><spring:theme code="basket.added.to.basket"/></span>
        </div>
    </div>
</div>
<c:if test="${showVatApplicable eq true}">
    <div class="row">
        <div class="vat__text-box h-space-1">
            <span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color"></span>
            <spring:theme code="product.vat.applicable"/>
        </div>
    </div>
</c:if>

<nav:plpHandlebarsTemplates />
<nav:similarProductsHandlebarsTemplate/>

<favourites:newFavouritiesList/>
<cart:quantityCartModals/>