<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>

<%@ attribute name="entry" required="true" type="de.hybris.platform.commercefacades.order.data.OrderEntryData" %>

<%-- Quantity --%>
<c:url value="/cart/update" var="formActionUrl" />
<c:set var="viewPromotions" value="${not empty currentB2BUnit && currentB2BUnit.viewPromotions ? 'true' : 'false' }" />
<input type="hidden" value="${viewPromotions}" id="js-cartViewPromotion"/>

<c:set var="promoGroupClass" value="${viewPromotions && entry.promoGroupNumber gt -1 ? 'js-cartItemPromoGroup' : ''}" />
<form:form action="${formActionUrl}" method="post" data-type="minibasket" class="js-addToCartForm mini-basket-qty-picker__form ${promoGroupClass}" data-id="${fn:escapeXml(entry.product.code)}">
  <ycommerce:testId code="addToCartButton">
      <input type="hidden" name="productCodePost" value="${fn:escapeXml(entry.product.code)}"/>
      <input type="hidden" name="entryNumber"
              value="${not empty entry ? entry.entryNumber : ''}"/>
      <input type="hidden" name="productNamePost" value="${fn:escapeXml(entry.product.name)}"/>
      <c:choose>
          <c:when test="${entry.product.netWeight != null && entry.product.itemCategoryGroup && entry.pricePerKilo != null}">
              <input type="hidden" name="productPostPrice" value="${fn:escapeXml(entry.product.price.value * entry.product.netWeight)}"/>
          </c:when>
          <c:otherwise>
              <input type="hidden" name="productPostPrice" value="${fn:escapeXml(entry.basePrice.value)}"/>
          </c:otherwise>
      </c:choose>
      <%-- TODO populate it from BE --%>
      <input type="hidden" name="productCartQty" class="js-productCartQty"
              value="${not empty entry.quantity ? entry.quantity : 0}"/>

      <%-- TODO add condition to check if QTY is greater then 0 --%>
       <div class="js-productQtyUpdate quantity-update">
                        <button type="button" class="btn btn-success quantity-update__btn quantity-update__btn--minus icon icon-minus js-qtyChangeBtn" data-action="remove" aria-label="Remove from cart"></button>
                        <input class="quantity-update__input js-productQtyInput" type="number" inputmode="numeric"  aria-label="Quantity" value="${entry.quantity}" min="0" max="1000" />
                        <button type="button" class="btn btn-success quantity-update__btn icon quantity-update__btn--plus icon-plus js-qtyChangeBtn" data-action="add" aria-label="Add to cart"></button>
                    </div>
  </ycommerce:testId>
</form:form>

<button type="button" class="btn mini-basket-qty-picker__remove js-removeItemMiniBasket" aria-haspopup="true" aria-expanded="false" id="editEntry__${fn:escapeXml(entry.entryNumber)}">
        <span class="icon icon-close icon--sm"></span> 
        <span class="mini-basket-qty-picker__remove-text">
                <spring:theme code="mini.cart.details.removeItem" />
        </span>
</button>