<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="entry" required="true" type="de.hybris.platform.commercefacades.order.data.OrderEntryData" %>
<%@ attribute name="promo" required="false" type="java.lang.Boolean" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>

<c:set var="viewPromotions" value="${not empty currentB2BUnit && currentB2BUnit.viewPromotions ? 'true' : 'false' }" />

    <div class="cart-item__price-wrapper">
       <%-- total per item --%>
       <c:set var="roundelMarkup" value="" />
       <c:if test="${not empty entry.wasPrice && viewPromotions}">
            <c:set var="roundelMarkup">
                <span class="icon icon--sm icon-promo-alt icon-promo-alt--red cart-item__promo-icon--cart-page js-triggerTooltip" data-toggle="popover-collapsable" data-placement="top" data-content="<spring:theme code='promo.info.tooltip' />" data-type="collapsable"><span class="path1"></span><span class="path2"></span></span>
            </c:set>

            <c:set var="hasWasPrice" value="has-was-price" />
            <c:set var="wasPriceMarkup">
                <span class="cart-item__total--was-price"><format:price priceData="${entry.wasPrice}" /></span>
                <c:if test="${entry.product.estimatedWasPrice != null && entry.wasPricePerKilo != null}">
                    <span class="cart-item__total--was-price"><format:price priceData="${entry.wasPricePerKilo}" removeSpacing="true"/></span>
                </c:if>
            </c:set>
		</c:if>
        <c:choose>
            <c:when test="${entry.product.netWeight != null && entry.product.itemCategoryGroup && entry.pricePerKilo != null}">
                <ycommerce:testId code="cart_totalProductPrice_label">
                    <div class="cart-item__total js-item-total ${hasWasPrice}">
                        ${roundelMarkup}
                        <span class="cart-item__total--current-price is-weighted-product"><format:price priceData="${entry.totalPrice}" displayFreeForZero="true"/>
                        </span>
                        ${wasPriceMarkup}
                        <span class="cart-item__weighted-price is-weighted-product">
                        <format:price priceData="${entry.pricePerKilo}" displayFreeForZero="false" removeSpacing="true"/>
                        <c:if test="${entry.product.subjectToVAT}">
                            <span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color "></span>
                        </c:if> 
                    </div>
                </ycommerce:testId>
            </c:when>
            <c:otherwise>
                <ycommerce:testId code="cart_totalProductPrice_label">
                    <div class="cart-item__total js-item-total ${hasWasPrice}">
                        ${roundelMarkup}
                        <span class="cart-item__total--current-price"><format:price priceData="${entry.totalPrice}" displayFreeForZero="true"/>
                            <c:if test="${entry.product.subjectToVAT}">
                                <span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color "></span>
                            </c:if></span>
                            ${wasPriceMarkup}
                        </div>
                    </ycommerce:testId>

                    <%-- price per item --%>
                    <div class="cart-item__price">
                        <c:if test="${!isb2cSite}">
                        (<format:price priceData="${entry.basePrice}"/>)
                        <span class="hide-mobile">&nbsp;${entry.product.unitPriceStr}</span>
                        </c:if>
                    </div>
            </c:otherwise>
        </c:choose>

        <c:if test="${entry.product.unitsPerCase gt 1}">
            <div class="cart-item__case">
                <spring:theme code="product.cart.caseQuantity"/>: ${entry.product.unitsPerCase}
            </div>
        </c:if>

        <div class="cart-item__pack-size">
            <spring:theme code="product.cart.packSize"/>: ${entry.product.packSize}
        </div>
    </div>

    <%-- Quantity --%>
    <div class="cart-item__quantity clearfix">
        <c:choose>
            <c:when test="${promo}">
                <spring:theme code="product.cart.promo.qty" /> ${entry.quantity}
            </c:when>
            <c:otherwise>
                <c:url value="/cart/update-and-reload" var="formActionUrl"/>
                <form:form id="addToCartForm${fn:escapeXml(entry.product.code)}" action="${formActionUrl}" method="post"
                            class="add_to_cart_form js-addQuantityForm js-addToCartForm" data-id="${fn:escapeXml(entry.product.code)}">
                    <ycommerce:testId code="addToCartButton">
                        <input type="hidden" name="productCodePost" value="${fn:escapeXml(entry.product.code)}"/>
                        <input type="hidden" name="entryNumber"
                                value="${not empty entry ? entry.entryNumber : ''}"/>
                        <input type="hidden" name="productNamePost" value="${fn:escapeXml(entry.product.name)}"/>
                        <input type="hidden" name="productPostPrice" value="${entry.basePrice.value}"/>
                        <%-- TODO populate it from BE --%>
                        <input type="hidden" name="productCartQty" class="js-productCartQty"
                                value="${not empty entry.quantity ? entry.quantity : 0}"/>
                            <input type="hidden" name="isCheckoutPage"
                                value="${not empty isCheckoutPage ? true : false}"/>       

                        <%-- TODO add condition to check if QTY is greater then 0 --%>
                        <div class="js-productQtyUpdate quantity-update ${empty entry.quantity ? 'hide' : ''} quantity-update--cart">
                            <button type="button"
                                    class="btn btn-success quantity-update__btn quantity-update__btn--minus icon icon-minus js-cartQtyChangeBtn"
                                    data-action="remove" aria-label="Remove from cart"></button>
                            <input class="quantity-update__input js-productCartQtyInput" type="number"
                                    inputmode="numeric" aria-label="Quantity"
                                    value="${not empty entry.quantity ? entry.quantity : 0}"
                                    max="1000"/>
                            <button type="button"
                                    class="btn btn-success quantity-update__btn icon quantity-update__btn--plus icon-plus js-cartQtyChangeBtn"
                                    data-action="add" aria-label="Add to cart"></button>
                        </div>
                    </ycommerce:testId>
                </form:form>
            </c:otherwise>
        </c:choose>
    </div>