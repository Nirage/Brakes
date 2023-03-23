<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="orderEntry" required="true" type="de.hybris.platform.commercefacades.order.data.OrderEntryData" %>
<%@ attribute name="substitutedEntry" required="false" type="de.hybris.platform.commercefacades.order.data.OrderEntryData" %>
<%@ attribute name="itemIndex" required="true" type="java.lang.Integer" %>
<%@ attribute name="promo" required="false" type="java.lang.Boolean" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/responsive/grid" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="order" tagdir="/WEB-INF/tags/responsive/order" %>
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/responsive/common" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components" %>

<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart/" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:set var="varShowStock" value="${(empty showStock) ? true : showStock}" />
<c:set var="defaultViewConfigurationInfosBaseUrl" value="/my-account/order" />
<c:set var="substituted" value="${not empty substitutedEntry and substitutedEntry.entryStatusCode eq 'SUBSTITUTION_INITIATED' ? true : false}" />
<c:url value="${orderEntry.product.url}" var="productUrl"/>
<c:set var="entryStock" value="${fn:escapeXml(orderEntry.product.stock.stockLevelStatus.code)}"/>

<c:if test="${promo}">
    <c:set var="promoClass" value="cart-item--has-promo" />
</c:if>

<li class="order-line-entry cart-item js-orderItem ${promoClass}">
    <c:if test="${promo}">
        <div class="promo-arrow"></div>
    </c:if>
    <div class="cart-item__content">
        <%-- product image --%>
        <div class="cart-item__image">
            <ycommerce:testId code="orderDetail_productThumbnail_link">
                <a class="product-item__thumb m0" href="${fn:escapeXml(productUrl)}" title="${fn:escapeXml(orderEntry.product.name)}">
                    <product:productImageLazyLoad product="${orderEntry.product}" ttMobile="$plp-mobile$" ttTablet="$plp-tablet$" ttDesktop="$plp-desktop$" format="thumbnail"/>
                </a>
                <%-- product icons --%>
                <div class="cart-item__advice-icons hidden-md hidden-lg">
                    <c:forEach items="${orderEntry.product.productInfoIcons}" var="iconClass">
                        <a href="${fn:escapeXml(productUrl)}" title="${fn:escapeXml(orderEntry.product.name)}">
                            <img class="cart-item__advice-icons-img" src="https://brakes.a.bigcontent.io/v1/static/icon-${iconClass}" alt="${iconClass}"/>
                        </a>
                    </c:forEach>
                </div>
            </ycommerce:testId>
        </div>

        <%-- product name, code, promotions --%>
        <div class="cart-item__details">
            <div class="cart-item__description">
                <order:orderItemDescription entry="${orderEntry}" promo="${promo}"/>
            </div>
            <div class="cart-item__details-right">
                <order:orderItemPrice entry="${orderEntry}" />
                <c:choose>
                    <c:when test="${isAmendOrderDetailsPage and not substituted and not promo}">
                        <order:orderItemQuantity entry="${orderEntry}"/>
                    </c:when>
                    <c:otherwise>
                        <div class="order-line-entry__qty">
                            <spring:theme code="text.order.details.line.entry.qty" />&nbsp;${orderEntry.deliveredQuantity == null ? orderEntry.quantity : orderEntry.deliveredQuantity}
                        </div>
                    </c:otherwise>
                </c:choose>
                <c:if test="${not isAmendOrderDetailsPage}">
                    <c:choose>
                        <c:when test="${substituted}">
                            <div class="order-status order-status--substitution-init">
                                <span class="js-showentrySubstituteModal" data-original-entry='{"code": "${substitutedEntry.product.code}", "name":"${substitutedEntry.product.name}", "packSize":"${substitutedEntry.product.packSize}", "imgUrl":"${substitutedEntry.product.images[1].url}", "altText":"${substitutedEntry.product.images[1].altText}"}'
                                data-substitute-entry='{"code":"${orderEntry.product.code}", "entryNumber":"${orderEntry.entryNumber}"}'
                                data-order-code="${orderDetails.order.code}"
                                >
                                    <spring:theme code="text.order.details.line.entry.status.substitutionInitialized" />
                                </span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${orderEntry.status eq 'Queued'}">
                                    <div class="order-status"><spring:theme code="text.order.details.line.entry.status.QUEUED" /></div>
                                </c:when>
                                <c:otherwise>
                                    <div class="order-status order-status--${fn:toLowerCase(orderEntry.entryStatusCode)}">${orderEntry.status}</div>
                                </c:otherwise>
                            </c:choose> 
                        </c:otherwise>
                    </c:choose>
                </c:if>
                <c:if test="${isAmendOrderDetailsPage}">
                    <div class="order-line-entry__amend-status">
                        <c:choose>
                           <c:when test="${substituted}">
                        <div class="order-status order-status--substitution-init">
                            <span class="js-showentrySubstituteModal" data-original-entry='{"code": "${substitutedEntry.product.code}", "name":"${substitutedEntry.product.name}", "packSize":"${substitutedEntry.product.packSize}", "imgUrl":"${substitutedEntry.product.images[1].url}", "altText":"${substitutedEntry.product.images[1].altText}"}'
                            data-substitute-entry='{"code":"${orderEntry.product.code}", "entryNumber":"${orderEntry.entryNumber}"}'
                            data-order-code="${orderDetails.order.code}"
                            >
                                <spring:theme code="text.order.details.line.entry.status.substitutionInitialized" />
                            </span>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${orderEntry.status eq 'Queued'}">
                                <div class="order-status"><spring:theme code="text.order.details.line.entry.status.QUEUED" /></div>
                            </c:when>
                            <c:otherwise>
                                <div class="order-status order-status--${fn:toLowerCase(orderEntry.entryStatusCode)}">${orderEntry.status}</div>
                            </c:otherwise>
                        </c:choose> 
                    </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</li>

<c:if test="${not empty unavailableProducts}">
    <order:unavailableProductsModal />
</c:if>