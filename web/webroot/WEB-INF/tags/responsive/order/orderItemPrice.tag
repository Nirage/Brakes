<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="entry" required="true" type="de.hybris.platform.commercefacades.order.data.OrderEntryData" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="order" tagdir="/WEB-INF/tags/responsive/order" %>

  <%-- total per item --%>
  <div class="cart-item__price-wrapper">
    <ycommerce:testId code="cart_totalProductPrice_label">
        <c:if test="${not empty entry.wasPrice}">
            <c:set var="hasWasPrice" value="has-was-price" />
            <c:set var="wasPriceMarkup">
                <span class="cart-item__total--was-price"><format:price priceData="${entry.wasPrice}" /></span>
            </c:set>
        </c:if>

        <div class="cart-item__total js-item-total ${hasWasPrice}">
            <c:choose>
                <c:when test="${entry.quantity == 0}">
                    <format:price priceData="${entry.totalPrice}"/>
                </c:when>
                <c:otherwise>
                    <c:set var="isWeightedProduct" value="${entry.product.netWeight != null && entry.product.itemCategoryGroup && entry.pricePerKilo != null}" />
                    <div class="cart-item__total--current-price ${isWeightedProduct ? 'is-weighted-product': ''}">
                        <format:price priceData="${entry.totalPrice}" displayFreeForZero="true"/>
                    </div>
                    ${wasPriceMarkup}
                    <c:if test="${not empty entry.pricePerKilo}">
                        <span class="cart-item__weighted-price h-space-1">
                            <format:price priceData="${entry.pricePerKilo}" removeSpacing="true"/>
                        </span>
                    </c:if>
                </c:otherwise>
            </c:choose>
            <c:if test="${entry.product.subjectToVAT}">
                <span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color "></span>
            </c:if>
        </div>
    </ycommerce:testId>

    <%-- price per item --%>
      <c:if test="${not isWeightedProduct}">
          <div class="cart-item__price">
              (<format:price priceData="${entry.basePrice}" displayFreeForZero="true"/>)
              &nbsp;${entry.product.unitPriceStr}
          </div>
      </c:if>
    <c:if test="${entry.product.unitsPerCase gt 1}">
        <div class="cart-item__case">
            <spring:theme code="product.cart.caseQuantity"/>: ${entry.product.unitsPerCase}
        </div>
    </c:if>

    <div class="cart-item__pack-size">
        <spring:theme code="product.cart.packSize"/>: ${entry.product.packSize}
    </div>
</div>