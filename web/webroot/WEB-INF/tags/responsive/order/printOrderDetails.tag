<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format"%>

<spring:htmlEscape defaultHtmlEscape="true" />

	<div class="cart-print">
			<div class="container">
				<cms:pageSlot position="SiteLogo" var="logo" limit="1">
					<cms:component component="${logo}" element="div" class="cart-print__logo" />
				</cms:pageSlot>
				<div class="cart-print__wrapper">
					<div class="cart-print__info">
						<span class="cart-print__id">
							<c:if test="${not empty cartData.code}">
								<spring:theme code="basket.page.print.cart" />&nbsp;${fn:escapeXml(cartData.code)}
							</c:if>
						</span>
						<c:if test="${not empty user.unit.uid}">
							<span class="cart-print__b2b-unit">
								<span class="cart-print__divider"></span>
								<spring:theme code="basket.page.print.b2bunit" />&nbsp;${user.unit.uid} <c:if test="${user.unit.name}">, ${user.unit.name}</c:if>
							</span>
						</c:if>
					</div>
					<table class="cart-print__products">
						<tr class="cart-print__product-row">
							<th><spring:theme code="basket.page.print.product" /></th>
							<th><spring:theme code="basket.page.print.price" /></th>
							<th><spring:theme code="basket.page.print.lineTotal" /></th>
						</tr>
						<c:forEach var="i" begin="1" end="${fn:length(cartData.entries)}" step="1">
   							 <c:set var="entry" value="${cartData.entries[fn:length(cartData.entries)-i]}" />
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
							<c:when test="${cartData.totalTax.value > 0}">
								<spring:theme code="basket.page.print.total.tax" />&nbsp;<format:price priceData="${cartData.totalPriceWithTax}" />
							</c:when>
							<c:otherwise>
								<spring:theme code="basket.page.print.total" />&nbsp;<format:price	priceData="${cartData.totalPrice}" />
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
				</div> <%-- cart-print__wrapper --%>
			</div><%-- container --%>
	</div>
