<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="cartData" required="true" type="de.hybris.platform.commercefacades.order.data.CartData" %>
<%@ attribute name="entry" required="true" type="de.hybris.platform.commercefacades.order.data.OrderEntryData" %>
<%@ attribute name="promo" required="false" type="java.lang.Boolean" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="promotions" tagdir="/WEB-INF/tags/responsive/promotions" %>

<c:set var="productPrefixHtml" value="${fn:escapeXml(entry.product.prefix)}"/>
<c:set var="productCodeHtml" value="${fn:escapeXml(entry.product.code)}"/>
<c:url value="${entry.product.url}" var="productUrl"/>
<c:set var="viewPromotions" value="${not empty currentB2BUnit && currentB2BUnit.viewPromotions ? 'true' : 'false' }" />
<input type="hidden" value="${viewPromotions}" class="js-cartViewPromotion"/>


<div class="cart-item__code js-cartItemCode" data-code="${productCodeHtml}">
 <c:if test="${not empty productPrefixHtml}">${productPrefixHtml}&nbsp;</c:if>${productCodeHtml}
</div>
<c:if test="${viewPromotions && (promo || entry.promoGroupNumber gt -1 || entry.hasPotentialPromo)}">
    <div class="item-icons item-icons--promo cart-item__promo-icon ${ not entry.hasPotentialPromo ? 'js-triggerComplexPromo':'item-icons--promo-no-action'}"  data-toggle="popover-collapsable" data-placement="bottom" data-type="collapsable">
        <span class="icon icon-promo-alt icon-promo-alt--red icon-user-actions"><span class="path1"></span><span class="path2"></span></span>
    </div>
</c:if>

<%-- <div class="cart-item__user-actions">
    <div class="item-icons item-icons--user-actions js-userActions">
        <product:productAddToFavouritePanel product="${entry.product}"/>
    </div>
</div> --%>

  <ycommerce:testId code="cart_product_name">
      <a class="cart-item__name" href="${fn:escapeXml(productUrl)}">${fn:escapeXml(entry.product.name)}</a>
  </ycommerce:testId>

<div class="cart-item__advice-icons hidden-xs hidden-sm">
    <c:if test="${entry.product.newProduct}">
        <span class="cart-item__advice-icons-img icon icon-new icon-new--royal-blue"></span>
    </c:if>
    <c:forEach items="${entry.product.productInfoIcons}" var="iconClass">
        <img class="cart-item__advice-icons-img" src="https://brakes.a.bigcontent.io/v1/static/icon-${iconClass}" alt="${iconClass}"/>
    </c:forEach>
</div>

<c:if test="${ycommerce:doesPotentialPromotionExistForOrderEntryOrOrderEntryGroup(cartData, entry)}">
    <c:forEach items="${cartData.potentialProductPromotions}" var="promotion">
        <c:set var="displayed" value="false"/>
        <c:forEach items="${promotion.consumedEntries}" var="consumedEntry">
            <c:if test="${not displayed && ycommerce:isConsumedByEntry(consumedEntry,entry) && not empty promotion.description}">
                <c:set var="displayed" value="true"/>

                <div class="promo">
                    <ycommerce:testId code="cart_potentialPromotion_label">
                        ${ycommerce:sanitizeHTML(promotion.description)}
                    </ycommerce:testId>
                </div>
            </c:if>
        </c:forEach>
    </c:forEach>
</c:if>
<c:if test="${ycommerce:doesAppliedPromotionExistForOrderEntryOrOrderEntryGroup(cartData, entry)}">
    <c:forEach items="${cartData.appliedProductPromotions}" var="promotion">
        <c:set var="displayed" value="false"/>
        <c:forEach items="${promotion.consumedEntries}" var="consumedEntry">
            <c:if test="${not displayed && ycommerce:isConsumedByEntry(consumedEntry,entry)}">
                <c:set var="displayed" value="true"/>
                <div class="promo">
                    <ycommerce:testId code="cart_appliedPromotion_label">
                        <div class="js-complexPromoTitleSrc hide">
                            <%-- TODO Remove this in case it has been decided that we can't get promo name/title to be displayed --%>
                            <c:choose>
                                <c:when test="${fn:contains(fn:toLowerCase(promotion.promotionData.code), 'multi')}">
                                    <p class="promo__offer-name"><spring:theme code="promo.complex.popup.multiBuy.msg" /></p>
                                </c:when>
                                <c:when test="${fn:contains(fn:toLowerCase(promotion.promotionData.code), 'bogof')}">
                                    <p class="promo__offer-name"><spring:theme code="promo.complex.popup.bogof.msg" /></p>
                                </c:when>
                                <c:otherwise>
                                   <p class="promo__offer-description"><spring:theme code="promo.complex.popup.other.msg" /></p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </ycommerce:testId>
                </div>
            </c:if>
        </c:forEach>
    </c:forEach>
</c:if>