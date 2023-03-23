<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="entry" required="true" type="de.hybris.platform.commercefacades.order.data.OrderEntryData" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart/" %>

<div class="order-line-entry__qty-form clearfix">
        <%-- Quantity --%>
        <c:url value="/my-account/addToAmendOrder" var="formActionUrl"/>
        <form:form id="addToCartForm${fn:escapeXml(entry.product.code)}" action="${formActionUrl}" method="post"
                        class="add_to_cart_form js-addQuantityForm js-addToCartForm" data-id="${fn:escapeXml(entry.product.code)}">

                <ycommerce:testId code="addToCartButton">
                <input type="hidden" name="productCode" value="${fn:escapeXml(entry.product.code)}"/>
                <input type="hidden" name="qty" class="js-productCartQty"
                        value="${not empty entry.quantity ? entry.quantity : 0}"/>
                <%-- TODO add condition to check if QTY is greater then 0 --%>
                <div class="js-productQtyUpdate quantity-update ${empty entry.quantity ? 'hide' : ''} quantity-update--cart">
                        <button type="button"
                                class="btn btn-success quantity-update__btn quantity-update__btn--minus icon icon-minus js-cartQtyChangeBtn"
                                data-action="remove" aria-label="Remove from cart"></button>
                        <input class="quantity-update__input js-productCartQtyInput" type="number"
                                inputmode="numeric" aria-label="Quantity"
                                value="${not empty entry.quantity ? entry.quantity : 0}"
                                max="99" />
                        <input type="hidden" name="orderCode"  value="${orderDetails.order.code }"/>
                        <button type="button"
                                class="btn btn-success quantity-update__btn icon quantity-update__btn--plus icon-plus js-cartQtyChangeBtn"
                                data-action="add" aria-label="Add to cart"></button>
                </div>
                </ycommerce:testId>
        </form:form>
</div>
<div class="order-line-entry__actions">
        <cart:cartItemActions entry="${entry}" />
</div>

    