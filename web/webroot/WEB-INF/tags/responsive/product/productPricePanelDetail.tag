<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="product" required="true" type="de.hybris.platform.commercefacades.product.data.ProductData" %>
<%@ attribute name="isOrderForm" required="false" type="java.lang.Boolean" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<spring:htmlEscape defaultHtmlEscape="true" />
<sec:authorize access="!hasRole('ROLE_ANONYMOUS')">
	<c:set var="isUserLoggedIn" value="true"/>
</sec:authorize>

<c:choose>
	<c:when test="${empty product.volumePrices}">
		<c:choose>
			<c:when test="${(not empty product.priceRange) and (product.priceRange.minPrice.value ne product.priceRange.maxPrice.value) and ((empty product.baseProduct) or (not empty isOrderForm and isOrderForm))}">
				<span>
					<format:price priceData="${product.priceRange.minPrice}"/>
				</span>
				<span>
					-
				</span>
				<span>
					<format:price priceData="${product.priceRange.maxPrice}"/>
				</span>
			</c:when>
			<c:otherwise>
				<div class="product-details__price product-details-price js-productItemPrice ${not empty product.wasPrice ? 'has-was-price' : ''}">
					<%-- <div> --%>
						<c:choose>
							<c:when test="${isUserLoggedIn}">
								<c:set var="VAT_asterisk" value="" />
								<c:if test="${product.subjectToVAT}">
									<c:set var="VAT_asterisk"><span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color hidden js-loadPriceVAT"></span></c:set>
								</c:if>
								<c:set var="priceProductCode" value="${not empty product.sapProductCode ? product.sapProductCode : product.code}" />
								<div class="js-loadPrice" data-product-code="${priceProductCode}" data-price-per-divider="${product.pricePerDivider}" data-net-weight="${product.netWeight == null || !product.itemCategoryGroup ? 1.0 : product.netWeight}">
									<span class="js-loadWasPrice product-details-price--was-price hidden">
										<span class="js-loadWasPriceValue"></span>
									</span>
									<span class="product-details-price--current-price js-loadPriceValue ${product.estimatedPrice != null ? 'is-weighted-product': ''}">
									</span>${VAT_asterisk}
									
									<div class="js-loadPriceEach product-details-price__price-each col-xs-12 p-0 ${product.estimatedPrice != null ? 'is-weighted-product': ''} hidden">
										<span class="js-productPrice" title="${fn:escapeXml(product.name)}">${currentCurrency.symbol}<span class="js-unitPrice"></span><c:if test="${not empty product.unitPriceDescriptor}">${product.unitPriceDescriptor}</c:if></span>
									</div>
								</div>
							</c:when>
							<c:otherwise>
								<c:if test="${not empty product.wasPrice}">
									<c:set var="hasWasPrice" value="has-was-price" />
									<c:choose>
										<c:when test="${product.estimatedWasPrice != null}">
											<span class="product-details-price--was-price">
												<format:price priceData="${product.estimatedWasPrice}" />
											</span>
											<span class="product-details-price--was-price product-details-price--was-price-each">
												${fn:replace(product.wasPrice.formattedValue, " ", "")}
											</span>
										</c:when>
										<c:otherwise>
											<span class="product-details-price--was-price">
												${fn:replace(product.wasPrice.formattedValue, " ", "")}
											</span>
										</c:otherwise>
									</c:choose>
								</c:if>
								<c:choose>
									<c:when test="${product.estimatedPrice != null}">
										<span class="js-productPrice product-details-price--current-price is-weighted-product"
										 data-productid="${product.code}" data-currency-symbol="${currentCurrency.symbol}"  
										 data-price="${product.estimatedPrice.value}" data-currency-symbol="${currentCurrency.symbol}">
											<format:price priceData="${product.estimatedPrice}"/>
										</span>
										<c:if test="${product.subjectToVAT}">
										<span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color"></span>
										</c:if>
										<div class="js-productPriceEach product-details-price__price-each col-xs-12 p-0 is-weighted-product"
										data-productid="${product.code}">										 
											<span class="">${fn:replace(product.price.formattedValue, " ", "")}</span>
										</div>
									</c:when>
									<c:otherwise>
										<span class="js-productPrice product-details-price--current-price ${hasWasPrice}" data-productid="${product.code}" data-currency-symbol="${currentCurrency.symbol}"  data-price="${product.price.value}" data-currency-symbol="${currentCurrency.symbol}"><format:price priceData="${product.price}" /></span>
										<c:if test="${product.subjectToVAT}">
											<span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color"></span>
										</c:if>
										<div class="js-productPrice product-details-price__price-each col-xs-12 p-0 ${hasWasPrice}" data-productid="${product.code}" data-price="${product.unitPriceStr}"  data-currency-symbol="${currentCurrency.symbol}" data-currency-symbol="${currentCurrency.symbol}" data-price-descriptor="${product.unitPriceDescriptor}">
											${product.unitPriceStr}
										</div>
									</c:otherwise>
								</c:choose>
							</c:otherwise>
						</c:choose>
					</div>
				<%-- </div> --%>
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<table class="volume__prices" cellpadding="0" cellspacing="0" border="0">
			<thead>
			<th class="volume__prices-quantity"><spring:theme code="product.volumePrices.column.qa"/></th>
			<th class="volume__price-amount"><spring:theme code="product.volumePrices.column.price"/></th>
			</thead>
			<tbody>
			<c:forEach var="volPrice" items="${product.volumePrices}">
				<tr>
					<td class="volume__price-quantity">
						<c:choose>
							<c:when test="${empty volPrice.maxQuantity}">
								${volPrice.minQuantity}+
							</c:when>
							<c:otherwise>
								${volPrice.minQuantity}-${volPrice.maxQuantity}
							</c:otherwise>
						</c:choose>
					</td>
					<td class="volume__price-amount text-right">${fn:escapeXml(volPrice.formattedValue)}</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
	</c:otherwise>
</c:choose>