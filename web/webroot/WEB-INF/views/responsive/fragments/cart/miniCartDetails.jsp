<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart"%>
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/responsive/common"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:url value="/cart" var="cartUrl"/>
<c:set var="cutOffTimeColour" value="" />
<c:set var="VATApplicableCart" value="false" />

<c:set value = "${cart.formattedDeliveryDate}" var="deliveryDate" />
<c:set value = "${cart.formattedOrderDeadlineDate}" var="deadlineDate" />

<c:set var="viewPromotions" value="${not empty currentB2BUnit && currentB2BUnit.viewPromotions ? 'true' : 'false' }" />

<c:if test="${cart.cutOffTimeWarning}">
	<c:set var="cutOffTimeColour" value="mini-basket-details__cutoff-time--red" />
</c:if>

<c:if test="${not empty cartModificationJson}">
	<c:set var="cartData">
		${cartModificationJson}
	</c:set>
	<div class="hidden" id="cartModificationJson">${cartData}</div>
</c:if>

<cart:cartValidation/>
<cart:cartPickupValidation/>

<div class="mini-basket-details__wrapper">
	<div class="global-alerts js-miniCartGlobalMessages hide">
		<%-- Information (confirmation) messages --%>
		<c:if test="${not empty accInfoMsgs}">
			<div class="alert alert-info alert-dismissable">
				<button class="close" aria-hidden="true" data-dismiss="alert" type="button">
						<span class="icon icon-close icon--sm"></span>
				</button>
				<span class="icon icon-tick alert__icon alert__icon--info"></span>
				<c:forEach items="${accInfoMsgs}" var="msg">
					<span class="alert__text"> <spring:theme code="${msg.code}"
							arguments="${msg.attributes}" htmlEscape="false"
							var="informationMessages" />
						${ycommerce:sanitizeHTML(informationMessages)}
					</span>
				</c:forEach>
			</div>
		</c:if>
	</div>
	<c:set var="outOfStockError">
		<form:errors path="productCode"/>
	</c:set>

	<c:if test="${not empty outOfStockError}">
		<script>
			window.outOfStockError = true;
		</script>
	</c:if>
	<%-- Based on ${shownProductCount}(ex:3) count we have to show the products in minicart --%>
	<c:if test="${not empty cart}">
		<div class="mini-basket-details__top js-miniBasketDetailsTop">
			<div class="mini-basket-details__header">
				<div class="mini-basket-details__total-items">    	
					<spring:theme code="mini.cart.details.totalItems" arguments="${cart.totalItems}" />
				</div>
				<div class="mini-basket-details__close js-miniBasketDetailsCollaps">
					<span class="icon icon-chevron-up icon--sm"></span>
						<div class="mini-basket-details__close-txt">
							<spring:theme code="mini.cart.details.close" />
						</div>
				</div>
			</div>
			
			<c:if test="${not empty savedCarts && fn:length(savedCarts) gt 0}">
			<div class="mini-basket-details__switch-baskets">
				<cart:switchCart savedCartCount="${saveCartCountForCurrntUser}" savedCarts="${savedCarts}" labelCode="mini.cart.details.switchBaskets" cart="${cart}"/>
			</div> 
			</c:if> 	<%-- Switch basket check--%>
				<div class="mini-basket-details__actions">
					<cart:miniCartHeader />
					<div class="mini-basket-details__date">
						<span class="mini-basket-details__delivery-date">
							<c:if test="${not empty cart.deliveryDate}">
								<spring:theme code="basket.delivery.date.txt" />
							</c:if> 
						</span>
						<span class="mini-basket-details__date-amend js-accountDropdown" data-id="delivery-calendar">
							<%-- <span class="cart-totals__body-text--underline">${deliveryDate}&nbsp;</span> --%>
							<span class="cart-totals__body-text--underline">
							<c:if test="${not empty cart.deliveryDate}">
								${deliveryDate}
							</c:if></span>
							<span class="icon icon-amend cart-totals__edit-icon"></span>
						</span>
					</div>
					<div class="mini-basket-details__cutoff-time ${cutOffTimeColour}">
						<c:if test="${not empty cart.orderDeadlineDate}">
						<spring:theme code="mini.cart.details.cutoffTxt" arguments="${deadlineDate}"/> 
						</c:if>
				
				</div>
			</div> <%-- End of mini-basket-details__date-amend --%>
		</div> <%-- End of mini-basket-details__top --%>

		<div class="mini-basket-details__middle">
			<div class="mini-basket-details__quick-add clearfix">
				<cart:miniCartQuickAdd />
			</div>
			<div class="mini-basket-details__products js-cartItemsList">
				<c:if test="${empty cart.rootGroups}">
					<cart:cartEmpty customClass="cart-empty--mini-basket"/>
				</c:if>
				<c:forEach items="${cart.entries}" var="entry">
					<c:choose>
						<c:when test="${viewPromotions && entry.promoGroupNumber gt -1}">
								<div class="mini-basket-details__promo-group">
										<cart:miniCartItem entry="${entry}"/>
										<cart:miniCartItem entry="${entry.linkedPromoEntry}" promo="true"/>
								</div>
						</c:when>
						<c:otherwise>
								<cart:miniCartItem entry="${entry}"/>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			</div>
		</div>
		<div class="mini-basket-details__bottom">
				<div class="mini-basket-summary">
					<div class="mini-basket-summary__items">
						<spring:theme code="mini.cart.summary.total.items" arguments="${cart.totalItems}" />
					</div>
					<div class="mini-basket-summary__totals">
						<span class="mini-basket-summary__totals-text"><spring:theme code="mini.cart.summary.totals" /></span>
						<ycommerce:testId code="cart_totalPrice_label">
							<c:choose>
								<c:when test="${cart.net && cart.totalTax.value > 0 }">
									<span class="mini-basket-summary__price"><format:price priceData="${cart.totalPriceWithTax}"/></span>
								</c:when>
								<c:otherwise>
									<span class="mini-basket-summary__price"><format:price priceData="${cart.totalPrice}"/></span>
								</c:otherwise>
							</c:choose>
						</ycommerce:testId> 
						<div class="cart-totals__minimum-order h-space-1">
							<c:if test="${currentB2BUnit.minimumOrderValue gt 0}">
								<span class="cart-totals__body-text--font12">
									<c:choose>
										<c:when test="${cart.totalPrice.value lt currentB2BUnit.minimumOrderValue}">
											<span class="delivery-date__deadline highlighted">
											   <spring:theme code="basket.summary.minimum.order.txt" arguments="${currentCurrency.symbol}"/><fmt:formatNumber value="${currentB2BUnit.minimumOrderValue}" minFractionDigits="2" maxFractionDigits="2" />
											</span>
										</c:when>
										<c:otherwise>
											   <spring:theme code="basket.summary.minimum.order.txt" arguments="${currentCurrency.symbol}"/><fmt:formatNumber value="${currentB2BUnit.minimumOrderValue}" minFractionDigits="2" maxFractionDigits="2" />
										</c:otherwise>
									</c:choose>
								</span>
							</c:if>
						</div>
					</div>
					<c:if test="${not empty currentB2BUnit.minimumOrderValue && (cart.totalPrice.value lt currentB2BUnit.minimumOrderValue)}">
						<c:set var="checkoutBtnClass" value="disabled" />
					</c:if> 
					<a tabindex="0" href="${siteUid eq 'brakesfoodshop' ? '/checkout': '/checkout/step-one'}" class="btn btn-primary btn--full-width btn--continue-checkout js-continue-checkout-button h-space-1 ${checkoutBtnClass}">
						<spring:theme code="mini.cart.details.checkout" />
					</a>
					<c:if test="${VATApplicableCart}">
						<div class="vat__text-box mini-basket-summary__vat">
		    			<span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color "></span>
							<spring:theme code="product.vat.applicable" />
						</div>
					</c:if>
					<a tabindex="0" href="${cartUrl}" class="mini-basket-summary__view-full js-continue-cart-button">
						<spring:theme code="mini.cart.details.viewFullBasket" />
					</a>
				</div>
		</div>
	</c:if> <%-- End for if not empty cart --%>
</div>

<cart:printMiniBasket />
<cart:favouritesListHandlebars />