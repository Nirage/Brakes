<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="cartData" required="true" type="de.hybris.platform.commercefacades.order.data.CartData" %>
<%@ attribute name="entry" required="true" type="de.hybris.platform.commercefacades.order.data.OrderEntryData" %>
<%@ attribute name="index" required="false" type="java.lang.Integer" %>
<%@ attribute name="promo" required="false" type="java.lang.Boolean" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/responsive/grid" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="order" tagdir="/WEB-INF/tags/responsive/order" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart/" %>



<%--
    Represents single cart item on cart page
 --%>

<spring:htmlEscape defaultHtmlEscape="true"/>

<c:set var="errorStatus" value="<%= de.hybris.platform.catalog.enums.ProductInfoStatus.valueOf(\"ERROR\") %>"/>

<c:set var="entryNumberHtml" value="${fn:escapeXml(entry.entryNumber)}"/>
<c:set var="quantityHtml" value="${fn:escapeXml(entry.quantity)}"/>
<c:set var="viewPromotions" value="${not empty currentB2BUnit && currentB2BUnit.viewPromotions ? 'true' : 'false' }" />


<c:if test="${empty index && not promo}">
    <c:set property="index" value="${entryNumber}"/>
</c:if>

<c:if test="${not empty entry}">
    <c:if test="${not empty entry.statusSummaryMap}">
        <c:set var="errorCount" value="${entry.statusSummaryMap.get(errorStatus)}"/>
        <c:if test="${not empty errorCount && errorCount > 0}">
            <div class="notification has-error">
                <spring:url value="/cart/{/entryNumber}/configuration/{/configuratorType}" var="entryConfigUrl"
                            htmlEscape="false">
                    <spring:param name="entryNumber" value="${entry.entryNumber}"/>
                    <spring:param name="configuratorType" value="${entry.configurationInfos[0].configuratorType}"/>
                </spring:url>

                <spring:theme code="basket.error.invalid.configuration" arguments="${errorCount}"/>
                <a href="${fn:escapeXml(entryConfigUrl)}">
                    <spring:theme code="basket.error.invalid.configuration.edit"/>
                </a>
            </div>
        </c:if>
    </c:if>
    <c:set var="showEditableGridClass" value=""/>
    <c:url value="${entry.product.url}" var="productUrl"/>
    <c:if test="${viewPromotions}">
        <c:if test="${promo}">
            <c:set var="promoClass" value="cart-item--has-promo" />
        </c:if>
        <c:if test="${entry.hasPotentialPromo}">
            <c:set var="promoClass" value="cart-item--has-potential-promo" />
        </c:if>
    </c:if>

    <li class="cart-item js-cartItem ${promoClass} ${(entry.promoGroupNumber gt -1  && viewPromotions) ? "js-cartItemPromoGroup" : ""}">
        <c:if test="${promo && viewPromotions}">
            <div class="promo-arrow"></div>
        </c:if>
        <div class="cart-item__content">
            <div class="cart-item__image">
                <a class="product-item__thumb m0" href="${fn:escapeXml(productUrl)}">
                    <product:productImageLazyLoad product="${entry.product}" ttMobile="$basket-mobile$" ttTablet="$basket-tablet$" ttDesktop="$basket-desktop$" format="thumbnail"/>
                </a>
                <div class="cart-item__advice-icons hidden-md hidden-lg">
                    <c:if test="${entry.product.newProduct}">
                        <span class="cart-item__advice-icons-img icon icon-new icon-new--royal-blue"></span>
                    </c:if>
                    <c:forEach items="${entry.product.productInfoIcons}" var="iconClass">
                        <img class="cart-item__advice-icons-img" src="https://brakes.a.bigcontent.io/v1/static/icon-${iconClass}" alt="${iconClass}"/>
                    </c:forEach>
                </div>
            </div>

            <div class="cart-item__details">
                <div class="cart-item__description">
                    <cart:cartItemDescription cartData="${cartData}" entry="${entry}" promo="${promo}" />
                </div>
            
                <div class="cart-item__details-right">
                    <c:if test="${isCheckoutPage}">
                        <div class="cart-item__qty"><span class="hide-large" aria-hidden="true"><spring:theme code="checkout.multi.order.quantity"/>: </span>${entry.quantity}</div>
                        <input type="checkbox" id="cart-item__${entry.product.code}" class="cart-item__edit-checkbox" autocomplete="off" aria-hidden="true">
                        <label for="cart-item__${entry.product.code}" class="cart-item__edit-label"><spring:theme code="checkout.summary.edit"/></label>
                    </c:if>

                    <cart:cartItemPriceQuantity entry="${entry}" promo="${promo}"/>
                
                    <c:if test="${entry.updateable}">
                        <div class="cart-item__actions">
                            <cart:cartItemActions entry="${entry}" />
                        </div>
                    </c:if>
                </div>
            
            </div>
        </div>

        <c:if test="${entry.hasPotentialPromo && viewPromotions}">
            <div class="potential-promo-teaser">
                <div class="potential-promo-teaser__left">
                    <div class="item-icons item-icons--promo potential-promo-teaser__icon">
                        <span class="icon icon-promo-alt icon-promo-alt--red"><span class="path1"></span><span class="path2"></span></span>
                    </div>
                    <div class="potential-promo-teaser__message">
                        <div class="potential-promo-teaser__message-title">
                            <spring:theme code="potential.promo.teaser.title" />
                        </div>
                        <div class="potential-promo-teaser__message-text">
                            <spring:theme code="potential.promo.teaser.text" />
                        </div>
                    </div>
                </div>
                <div class="potential-promo-teaser__right">
                    <c:url var="viewProductsUrl" value="/cart/viewProducts/${entry.entryNumber}" />
                    <button type="button" class="btn btn-secondary btn--full-width js-viewPotentialPromoProducts" data-url="${viewProductsUrl}">
                        <spring:theme code="potential.promo.teaser.view.products" />
                    </button>
                </div>
            </div>
        </c:if>
    </li>
</c:if>
