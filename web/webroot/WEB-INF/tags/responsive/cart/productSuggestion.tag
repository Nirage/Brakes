<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format"%>

<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product"%>
<%@ taglib prefix="favourite" tagdir="/WEB-INF/tags/responsive/favourite" %>
<%@ taglib prefix="action" tagdir="/WEB-INF/tags/responsive/action" %>

<%@ taglib prefix="component" tagdir="/WEB-INF/tags/shared/component"%>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="promotions" tagdir="/WEB-INF/tags/responsive/promotions" %>

<%@ attribute name="suggestion" required="true" type="java.lang.Object" %>
<%@ attribute name="customClass" required="false" type="java.lang.String" %>

<spring:htmlEscape defaultHtmlEscape="true" />
<c:url value="/sign-in" var="loginUrl" />
<c:url value="/cart/add-and-reload" var="formActionUrl" />


<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
	<c:set var="isLoggedIn" value="true" />
</sec:authorize>

<c:set var="showPromotion">
	<promotions:showPromotion product="${suggestion}" isLoggedIn="${isLoggedIn}"/>
</c:set>


<c:if test="${not empty favourite && not favourite.shared}">
	<c:set var="isFavouriteProduct" value="true" />
</c:if>

<c:url value="${suggestion.url}" var="productUrl" />
<c:url value="${suggestion.code}" var="productCode" />

<div class="suggestion ${customClass} clearfix ${isFavouriteProduct ? ' js-favouriteItem' : ''} js-productItem">
 <div class="suggestion__thumb">
  <a class="suggestion__img product-item__thumb m0" href="${fn:escapeXml(productUrl)}" title="${fn:escapeXml(suggestion.name)}">
    <components:productPicture product="${suggestion}" ttMobile="$basket-mobile$" ttTablet="$basket-tablet$" ttDesktop="$basket-desktop$" format="thumbnail"/>
	</a>
  <div class="suggestion__advice-icons">
    <c:forEach items="${suggestion.productInfoIcons}" var="iconClass">
        <a href="${fn:escapeXml(productUrl)}" title="<spring:theme code="icon.title.${iconClass}"/>" class="suggestion__advice-link">
            <img class="cart-item__advice-icons-img" src="https://brakes.a.bigcontent.io/v1/static/icon-${iconClass}" alt="${iconClass}"/>
        </a>
      </c:forEach>
    </div>
 </div>
 <div class="suggestion__info">
  <%-- Item info --%>
  <div class="clearfix h-space-1">
    <div class="suggestion__code">
      <a href="${productUrl}">${suggestion.prefix}&nbsp;${productCode}</a>
    </div>
    <div class="suggestion__icons">          
      <c:if test="${isLoggedIn}">
        <div class="suggestion__icon item-icons--user-actions js-userActions">
        <c:if test="${isRecentlyPurchasedProduct}"> <%-- TODO remove when story is defined --%>
          <span class="icon icon-recent-purchases" title="buy again"></span>
        </c:if>
        <c:choose>
            <c:when test="${isFavouriteProduct}">
                <favourite:editFavourite favourite="${favourite}" product="${suggestion}" isProduct="true"/>
            </c:when>
            <c:otherwise>
                <product:productAddToFavouritePanel product="${suggestion}"/>
            </c:otherwise>
        </c:choose>
        </div>
      </c:if> 
    </div>
  </div>
  <%-- Item Name --%>
  <c:if test="${component.displayProductTitles}">
    <a class="suggestion__name" href="${productUrl}">
    ${fn:escapeXml(suggestion.name)}
    </a>
  </c:if>
  <%-- Item Quantity --%>
    <c:if test="${suggestion.unitsPerCase gt 1}">
	<div class="suggestion__qty">
    <a href="${productUrl}"><spring:theme code="product.cart.caseQuantity"/>:&nbsp;${suggestion.unitsPerCase}</a>
    </div>
      </c:if>  

  <%-- Item Price --%>
  <c:if test="${component.displayProductPrices}">
    
    <c:set var="VAT_asterisk" value="" />
    <c:if test="${suggestion.subjectToVAT}">
      <c:set var="VAT_asterisk"><span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color "></span>
      </c:set>
    </c:if>

    <c:set var="priceProductCode" value="${not empty suggestion.sapProductCode ? suggestion.sapProductCode : suggestion.code}" />
    <div class="suggestion__price js-productItemPrice">
      <div data-product-code="${priceProductCode}" data-price-per-divider="${suggestion.pricePerDivider}">
        <span class="icon icon--sm icon-promo-alt icon-promo-alt--red cart-item__promo-icon--cart-page js-triggerTooltip hidden js-productPromoIcon" data-code="${priceProductCode}" data-toggle="popover-collapsable" data-placement="top" data-content="<spring:theme code='promo.info.tooltip' />" data-type="collapsable"><span class="path1"></span><span class="path2"></span></span>

        <a href="${productUrl}" class="suggestion-price__value suggestion-price__value--current js-loadPriceValue"></a>${VAT_asterisk}&nbsp;

        <span class="js-loadWasPrice suggestion-price__value suggestion-price__value--was-price hidden">
          <a href="${fn:escapeXml(productUrl)}" title="${fn:escapeXml(suggestion.name)}" class="js-loadWasPriceValue"></a>
        </span>

        <c:if test="${not empty suggestion.unitPriceDescriptor}">
          <div class="suggestion-price__price-each js-loadPriceEach hidden">
              <a href="${fn:escapeXml(productUrl)}" class="js-productPrice" title="${fn:escapeXml(suggestion.name)}">${currentCurrency.symbol}<span class="js-unitPrice"></span>${suggestion.unitPriceDescriptor}</a>
          </div>
        </c:if>

      </div>
    </div>    
  </c:if> <%-- end of Item Price --%>
  <%-- Pack Size --%>
  <div class="suggestion__size"><a href="${productUrl}"><spring:theme code="product.cart.packSize"/>:&nbsp;${suggestion.packSize}</a></div>
  <%-- Add to cart --%>
  <div class="addtocart">
    <form:form id="addToCartForm${fn:escapeXml(suggestion.code)}" action="${formActionUrl}" method="post" class="add_to_cart_form" >
        <input type="hidden" name="productCodePost" value="${fn:escapeXml(suggestion.code)}"/>
      <input type="hidden" name="productNamePost" value="${fn:escapeXml(suggestion.name)}"/>
        <c:choose>
            <c:when test="${suggestion.estimatedPrice != null}">
                <input type="hidden" name="productPostPrice" value="${fn:escapeXml(suggestion.estimatedPrice.value)}"/>
            </c:when>
            <c:otherwise>
                <input type="hidden" name="productPostPrice" value="${fn:escapeXml(suggestion.price.value)}"/>
            </c:otherwise>
        </c:choose>
      <input type="hidden" name="gaActionSource" value="${fn:escapeXml(component.title)}"/>
      <input type="hidden" name="entryNumber" value="${not empty suggestion.cartEntry ? suggestion.cartEntry.entryNumber : 0}"/>
      <input type="hidden" name="productCartQty" value="1"/>
        <input type="hidden" name="redirectTargetAfterAddToCart" value="${redirectTargetAfterAddToCart}"/>

      <c:choose>
        <c:when test="${product.stock.stockLevelStatus.code eq 'outOfStock' }">
            <button type="submit" class="btn btn-primary btn-block glyphicon glyphicon-shopping-cart"
                    aria-disabled="true" disabled="disabled">
            </button>
        </c:when>
        <c:otherwise>
          <button type="submit" class="btn btn-primary btn-block js-enable-btn ${not empty suggestion.cartEntry.quantity ? 'hide' : ''}" data-action="add" data-product-code="${fn:escapeXml(suggestion.code)}" disabled="disabled">
            <spring:theme code="product.button.addToCart"/>
          </button>
        </c:otherwise>
      </c:choose>
    </form:form>
  </div>
 </div>

</div>

