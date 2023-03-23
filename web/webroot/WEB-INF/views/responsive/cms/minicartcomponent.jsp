<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:formatDate pattern = "dd MMM yyyy" value = "${deliveryCal.selectedDate}" var="selectedDate" />

<spring:htmlEscape defaultHtmlEscape="true" />
<spring:url value="/cart/miniCart/{/totalDisplay}" var="refreshMiniCartUrl" htmlEscape="false">
	<spring:param name="totalDisplay"  value="${totalDisplay}"/>
</spring:url>
<spring:url value="/cart/rollover/{/componentUid}" var="rolloverPopupUrl" htmlEscape="false">
	<spring:param name="componentUid"  value="${component.uid}"/>
</spring:url>
<c:url value="/cart" var="cartUrl"/>


<sec:authorize access="!hasRole('ROLE_ANONYMOUS')">
	<c:set var="isUserLoggedIn" value="true"/>
</sec:authorize>


<div class="nav-cart">
    <sec:authorize access="hasAnyRole('ROLE_ANONYMOUS')" >
    	<button tabindex="0" class="btn btn-link mini-cart-link btn ga-nav-bar-5 js-loginPopupTrigger" aria-label="My Cart">
    </sec:authorize>
    <sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')" >
		<a href="${cartUrl}"
			tabindex="0"
			class="mini-cart-link btn js-miniCartHeader ga-nav-bar-5 p0"
			data-mini-cart-url="${rolloverPopupUrl}"
			data-mini-cart-refresh-url="${refreshMiniCartUrl}"
			data-mini-cart-name="<spring:theme code="text.cart"/>"
			data-mini-cart-empty-name="<spring:theme code="popup.cart.empty"/>"
			data-mini-cart-items-text="<spring:theme code="basket.items"/>"
			>
     </sec:authorize>
		<div class="mini-cart-wrapper">
			<div class="mini-cart-icon">
				<span class="icon icon-basket"></span>
			</div>
			<c:if test="${isUserLoggedIn}">
			<div class="mini-cart-count js-miniCartCount">
				<span class="nav-items-total">
					${totalItems lt 100 ? totalItems : "99+"}
				</span>
			</div>
			</c:if>
		</div>
		<c:if test="${isUserLoggedIn}">
			<div class="mini-cart-details hidden-xs">
				<div class="mini-cart-details-wrapper">
					<c:if test="${isb2cSite}">
						<div class="mini-cart-message label-text js-cartId" data-id="${cartID}">${cartID}</div>
					</c:if>
					<c:if test="${!isb2cSite}">
						<div class="mini-cart-message label-text js-cartId" data-id="${cartID}">${selectedDate}</div>
					</c:if>
					<div class="mini-cart-price js-miniCartPrice">${totalPrice.formattedValue}</div>
				</div>
			</div>
		</c:if>
		 <sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')" >
			</a>
	 </sec:authorize>
	     <sec:authorize access="hasAnyRole('ROLE_ANONYMOUS')" >
      </button>
    </sec:authorize>
</div>
<div class="mini-cart-container js-mini-cart-container"></div>