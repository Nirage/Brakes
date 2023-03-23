<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="cartData" required="true" type="de.hybris.platform.commercefacades.order.data.CartData" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="storepickup" tagdir="/WEB-INF/tags/responsive/storepickup" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:set var="errorStatus" value="<%= de.hybris.platform.catalog.enums.ProductInfoStatus.valueOf(\"ERROR\") %>" />

<c:set var="cartItemsNumber" value="${fn:length(cartData.rootGroups)}" />
<ul class="cart__items-list js-cartItemsList ${isCheckoutPage && cartItemsNumber ge 6 ? 'cart__items-list--checkout' : ''}">
	<c:set var="itemsCounter" value="0"/>
	<c:set var="blocksCounter" value="1"/>
	
	<input type="hidden" id="cartUrl" value="/cart" />
	<input type="hidden" id="cartLargeQuantity" value="${cartLargeQuantity}" />
	<input type="hidden" id="cartMaximumQuantity" value="${cartMaximumQuantity}" />
	<c:forEach items="${cartData.rootGroups}" var="group" varStatus="loop">
		<cart:rootEntryGroup cartData="${cartData}" entryGroup="${group}"/>
	</c:forEach>
</ul>
<input type="hidden" id="editing-row-item" />

<product:productOrderFormJQueryTemplates />
<storepickup:pickupStorePopup />
