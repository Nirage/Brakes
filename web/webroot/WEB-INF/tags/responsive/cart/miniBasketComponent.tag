<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ attribute name="customClass" required="false" type="java.lang.String" %>

<c:if test="${isCartAvailableForCustomer}">
	<spring:url value="/cart/miniCart/details" var="miniBasketContentUrl" htmlEscape="false" />
	<div class="mini-basket-component hidden-xs hidden-sm ${customClass}" id="js-miniBasketComponent" data-mini-basket-details-url="${miniBasketContentUrl}">
		<div class="mini-basket" id="js-stickyMiniBasket">
			<div class="js-miniBasketExpand mini-basket__expand">
			</div>
			<div class="mini-basket__expand-top">
				<span class="icon icon-basket"></span>
			</div>
			<div class="mini-basket__expand-bottom">
				<span class="icon icon-chevron-down icon--sm"></span>
			</div>
			<div class="mini-basket__total js-miniBasketTotal">
        ${cartTotalItems lt 100 ? cartTotalItems : "99+"}
			</div>
			<div class="js-miniBasketSpinner hide mini-basket__spinner-holder">
				<img class="mini-basket__spinner" src="/_ui/responsive/theme-brakes/images/Spinner-1s-75px.gif" alt="Loading...">
			</div>

			<div class="mini-basket__details js-miniBasketDetails">
			</div>
			<div class="mini-basket__control js-miniBasketDetailsCollaps">
				<span class="icon icon-chevron-up icon--sm"></span>
			</div>
		</div>
	</div>

	<!-- For minicart unavailable_Products_Popup-->
	<c:set var="isunavailableProductsFlag" value="${unavailableProductsFlag}"/>
	<c:if test="${isunavailableProductsFlag eq 'true'}">
		<script>
            window.outOfStockError = true;
		</script>
	</c:if>
</c:if>