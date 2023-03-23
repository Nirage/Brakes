<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart/"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ attribute name="promo" required="false" type="java.lang.Boolean" %>

<%@ attribute name="entry" required="true" type="de.hybris.platform.commercefacades.order.data.OrderEntryData" %>
<c:if test="${not empty entry}">
  <c:set var="viewPromotions" value="${not empty currentB2BUnit && currentB2BUnit.viewPromotions ? 'true' : 'false' }" />

  <c:if test="${viewPromotions && promo}">
        <c:set var="promoClass" value="mini-basket-product--has-promo" />
  </c:if>
  
  <div class="mini-basket-product ${promoClass}">
    <c:if test="${viewPromotions && promo}">
      <div class="promo-arrow"></div>
    </c:if>
    <div class="mini-basket-product__code-qty">
      <span class="mini-basket-product__code js-cartItemCode" data-code="${entry.product.code}"> ${entry.product.prefix}&nbsp;${entry.product.code} </span>
      <span class="mini-basket-product__qty-holder js-toggleMiniBasketQtyPicker">
        <span class="mini-basket-product__qty"><spring:theme code="mini.cart.details.qty" />${entry.quantity}</span>
        <c:if test="${not promo}">
          <span class="icon icon-chevron-down icon--sm"></span>
        </c:if>
      </span>
    </div>
    <div class="mini-basket-product__name">${entry.product.name}</div>
    <div class="mini-basket-product__details">
      <div class="mini-basket-product__sizes">
      <c:if test="${entry.product.unitsPerCase gt 1}">  
      <div class="mini-basket-product__case">
            <spring:theme code="product.cart.caseQuantity"/>: ${entry.product.unitsPerCase}
        </div>
        </c:if>
        <div class="mini-basket-product__pack-size">
          <spring:theme code="product.cart.packSize" />: ${entry.product.packSize}
        </div>
      </div>
      <div class="mini-basket-product__prices">
          <%-- total per item --%>
          <ycommerce:testId code="cart_totalProductPrice_label">
            <c:set var="wasPriceMarkup" value="" />
            <c:set var="hasWasPrice" value="" />
            <c:if test="${viewPromotions && not empty entry.wasPrice}">
              <c:set var="hasWasPrice" value="has-was-price" />
              <c:set var="wasPriceMarkup">
                <div class="cart-item__total--was-price">
                  <format:price priceData="${entry.wasPrice}" />
                  <c:if test="${entry.product.estimatedWasPrice != null && entry.wasPricePerKilo != null}">
                    <format:price priceData="${entry.wasPricePerKilo}" />
                  </c:if>
                </div>
              </c:set>
            </c:if>
            <div class="cart-item__total js-item-total ${hasWasPrice}">
              ${wasPriceMarkup}
              <c:if test="${viewPromotions && (promo || not empty entry.wasPrice)}">
                <div class="mini-basket-product__icon-promo js-triggerTooltip" data-toggle="popover-collapsable" data-placement="top" data-content="<spring:theme code='promo.info.tooltip' />" data-type="collapsable">
                  <span class="icon icon--sm icon-promo-alt icon-promo-alt--red"><span class="path1"></span><span class="path2"></span></span>
                </div>
              </c:if>
              <c:set var="isWeightedProduct" value="${entry.product.netWeight != null && entry.product.itemCategoryGroup && entry.pricePerKilo != null}" />
              <span class="cart-item__total--current-price ${isWeightedProduct ? 'is-weighted-product' : ''}"><format:price priceData="${entry.totalPrice}" displayFreeForZero="true" /></span>
              <c:if test="${entry.product.subjectToVAT}">
                <c:set var="VATApplicableCart" value="true" />
                <span
                  class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color "></span>
              </c:if>
              <c:if test="${isWeightedProduct}">
                <span class="cart-item__total--current-price is-weighted-product">
                  <format:price priceData="${entry.pricePerKilo}" removeSpacing="true"/>
                </span>
              </c:if>
            </div>
          </ycommerce:testId>

          <%-- price per item --%>
            <c:if test="${entry.product.netWeight == null || entry.pricePerKilo == null || !entry.product.itemCategoryGroup}">
              <div class="cart-item__price">
                (
                <format:price priceData="${entry.basePrice}" />
                ) &nbsp;${entry.product.unitPriceStr}
              </div>
            </c:if>
      </div>
    </div>
    <c:if test="${not promo}">
      <div class="mini-basket-qty-picker hide js-miniBasketQtyPicker clearfix">
        <cart:miniCartQuantityPicker entry="${entry}"/>
      </div>
    </c:if>
  </div>
</c:if>