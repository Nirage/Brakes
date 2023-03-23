<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="cartData" required="true" type="de.hybris.platform.commercefacades.order.data.CartData" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="storepickup" tagdir="/WEB-INF/tags/responsive/storepickup" %>
<%@ taglib prefix="addoncart" tagdir="/WEB-INF/tags/addons/b2bpunchoutaddon/responsive/cart" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:set var="errorStatus" value="<%= de.hybris.platform.catalog.enums.ProductInfoStatus.valueOf(\"ERROR\") %>" />

<%-- Number of items that are visible on page load. 
Also the size of the block of items that will be displayed on Load more --%>
<c:set var="displayBlockSize" value="60" />
<c:set var="cartItemsNumber" value="${fn:length(cartData.rootGroups)}" />
<ul class="cart__items-list js-cartItemsList ${isCheckoutPage && cartItemsNumber ge 6 ? 'cart__items-list--checkout' : ''}">

	<fmt:formatNumber var="numberOfBlocks" value="${cartItemsNumber/displayBlockSize}" maxFractionDigits="0" />
	<c:if test="${cartItemsNumber%displayBlockSize gt 0 && cartItemsNumber%displayBlockSize lt 5}">
		<c:set var="numberOfBlocks" value="${numberOfBlocks + 1}" />
	</c:if>

	<c:set var="itemsCounter" value="0"/>
	<c:set var="blocksCounter" value="1"/>
	<c:url var="cartUrl" value="/cart" />

	<input type="hidden" id="cartUrl" value="${cartUrl}" />
	<input type="hidden" id="cartLargeQuantity" value="${cartLargeQuantity}" />
	<input type="hidden" id="cartMaximumQuantity" value="${cartMaximumQuantity}" />
	<c:forEach items="${cartData.rootGroups}" var="group" varStatus="loop">
		<c:if test="${itemsCounter eq displayBlockSize*blocksCounter}">
			<c:set var="blocksCounter" value="${blocksCounter + 1}" />
		</c:if> 
		<c:choose>
			<c:when test="${loop.count le displayBlockSize}">
				<addoncart:rootEntryGroup cartData="${cartData}" entryGroup="${group}"/>
			</c:when>
			<c:otherwise>
				<c:if test="${loop.count eq (displayBlockSize + 1)}">
					<c:set var="loadMoreBtn">
					<li class="cart-item__load-more">
						<button class="btn btn-secondary js-loadMoreCartItems" data-id-next="${blocksCounter}" data-max="${numberOfBlocks}">
							<spring:theme code="basket.page.load.more" />
						</button>
					</li>
					</c:set>
				</c:if>
				<c:if test="${loop.count%displayBlockSize eq 1}">
					<div class="hide" id="id-${blocksCounter}">
				</c:if>
					<addoncart:rootEntryGroup cartData="${cartData}" entryGroup="${group}"/>
				<c:if test="${loop.count% displayBlockSize eq 0 || loop.last}">
					</div>
				</c:if>
			</c:otherwise>
		</c:choose> 
		<c:set var="itemsCounter" value="${itemsCounter + 1}"/>
  </c:forEach>
	${loadMoreBtn}
</ul>
<input type="hidden" id="editing-row-item" />

<product:productOrderFormJQueryTemplates />
<%-- <storepickup:pickupStorePopup /> --%>
