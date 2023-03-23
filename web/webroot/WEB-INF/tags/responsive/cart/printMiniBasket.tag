<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format"%>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:if test="${! empty( cart.entries) }">
	<div class="hide">
	<div class="cart-print__wrapper js-miniCartPrintWrapper">
		<div class="cart-print__info">
			<span class="cart-print__id">
				<c:if test="${not empty cart.code}">
					<spring:theme code="basket.page.print.cart" />&nbsp;${fn:escapeXml(cart.code)}
				</c:if>
			</span>
			<c:if test="${not empty currentB2BUnit.uid}">
				<span class="cart-print__b2b-unit">
					<span class="cart-print__divider"></span>
					<spring:theme code="basket.page.print.b2bunit" />&nbsp;${currentB2BUnit.uid}<c:if test="${not empty currentB2BUnit.name}">, ${currentB2BUnit.name}</c:if>
				</span>
			</c:if>
		</div>
		<table class="cart-print__products">
			<tr class="cart-print__product-row">
				<th><spring:theme code="basket.page.print.product" /></th>
				<th><spring:theme code="basket.page.print.price" /></th>
				<th><spring:theme code="basket.page.print.lineTotal" /></th>
			</tr>
			<c:forEach var="i" begin="1" end="${fn:length(cart.entries)}" step="1">
						<c:set var="entry" value="${cart.entries[fn:length(cart.entries)-i]}" />
				<tr class="cart-print__product-row">
					<td>
						${entry.product.code } - ${entry.product.name }
						<c:if test="${entry.product.subjectToVAT}">
							<span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color "></span>
							<c:set var="VATApplicable" value="true"/>
						</c:if>
					</td>
					<td>
						<format:price priceData="${entry.basePrice}" displayFreeForZero="true" />
					</td>
					<td>
						<format:price priceData="${entry.totalPrice}" displayFreeForZero="true" />
					</td>
				</tr>
			</c:forEach>
			<tr>
			<td colspan="3" class="cart-print__total">
				<c:choose>
				<c:when test="${cart.totalTax.value > 0}">
					<spring:theme code="basket.page.print.total.tax" />&nbsp;<format:price priceData="${cart.totalPriceWithTax}" />
				</c:when>
				<c:otherwise>
					<spring:theme code="basket.page.print.total" />&nbsp;<format:price	priceData="${cart.totalPrice}" />
				</c:otherwise>
			</c:choose>
			</td>
			</tr>
			<c:if test="${VATApplicable}">
				<tr>
					<td class="cart-print__vat">
					<span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color "></span> 
					<spring:theme code="basket.page.print.vatText" /></td>
				</tr>
			</c:if>
		</table>
	</div>
	</div>
</c:if>