<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="entry" required="true" type="de.hybris.platform.commercefacades.order.data.OrderEntryData" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ attribute name="promo" required="false" type="java.lang.Boolean" %>

<c:set var="productPrefixHtml" value="${fn:escapeXml(entry.product.prefix)}"/>
<c:set var="productCodeHtml" value="${fn:escapeXml(entry.product.code)}"/>
<c:url value="${entry.product.url}" var="productUrl"/>

<ycommerce:testId code="orderDetails_productCode">
  <a href="${entry.product.purchasable ? fn:escapeXml(productUrl) : ''}" class="cart-item__code js-orderItemCode" data-code="${productCodeHtml}">
    <c:if test="${not empty productPrefixHtml}">${productPrefixHtml}&nbsp;</c:if>${productCodeHtml}
  </a>
</ycommerce:testId>
<c:if test="${entry.promoGroupNumber gt -1 || promo}">
  <div class="item-icons item-icons--promo cart-item__promo-icon">
      <span class="icon icon-promo-alt icon-promo-alt--red icon-user-actions"><span class="path1"></span><span class="path2"></span></span>
  </div>
</c:if>

<ycommerce:testId code="orderDetails_productName_link">
  <a class="cart-item__name" href="${entry.product.purchasable ? fn:escapeXml(productUrl) : ''}">
    ${fn:escapeXml(entry.product.name)}
  </a>
</ycommerce:testId>

<div class="cart-item__advice-icons hidden-xs hidden-sm">
  <c:if test="${entry.product.newProduct}">
  	<span class="cart-item__advice-icons-img icon icon-new icon-new--royal-blue"></span>
  </c:if>
  <c:forEach items="${entry.product.productInfoIcons}" var="iconClass">
    <img class="cart-item__advice-icons-img" src="https://brakes.a.bigcontent.io/v1/static/icon-${iconClass}" alt="${iconClass}"/>
  </c:forEach>
</div>
