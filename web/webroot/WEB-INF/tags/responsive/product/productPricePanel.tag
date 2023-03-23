<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ attribute name="product" required="true" type="de.hybris.platform.commercefacades.product.data.ProductData" %>
<%@ attribute name="isLoggedIn" required="false" type="java.lang.Boolean" %>

<div class="product-price product-price--current-price">
	<c:choose>
		<c:when test="${isLoggedIn}">
			<c:set var="VAT_asterisk" value="" />
			<c:if test="${product.subjectToVAT}">
				<c:set var="VAT_asterisk"><span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color hidden js-loadPriceVAT"></span></c:set>
			</c:if>
			<c:set var="priceProductCode" value="${not empty product.sapProductCode ? product.sapProductCode : product.code}" />

			<div class="js-loadPrice product-price--load-price__wrapper" data-product-code="${priceProductCode}" data-price-per-divider="${product.pricePerDivider}">
				<div class="js-loadWasPrice product-price product-price--was-price hidden">
					<span class="product-price__value product-price__value--was-price">
						<span class="js-loadWasPriceValue"></span>
					</span>
					<span class="product-price__value product-price__value--was-price hidden">
						<span class="js-loadWasPriceValueEach"></span>
					</span>
				</div>
				<span class="product-price__value product-price__value--current js-loadPriceValue ${product.estimatedPrice != null? 'is-weighted-product' : ''}">
				</span>${VAT_asterisk}
				<div class="js-loadPriceEach product-price__price-each hidden ${product.estimatedPrice != null? 'is-weighted-product' : ''}">
					<span class="js-productPrice" title="${fn:escapeXml(product.name)}">${currentCurrency.symbol}
					<span class="js-unitPrice"></span><c:if test="${not empty product.unitPriceDescriptor}">${product.unitPriceDescriptor}</c:if></span>
				</div>
			</div>
		</c:when>
		<c:otherwise>
			<c:if test="${not empty product.wasPrice}">
				<div class="product-price product-price--was-price">
					<c:choose>
						<c:when test="${product.estimatedWasPrice != null}">
							<span class="product-price__value product-price__value--was-price">
								<format:price priceData="${product.estimatedWasPrice}" />
							</span>
							<span class="product-price__value product-price__value--was-price">
								<format:price priceData="${product.wasPrice}" removeSpacing="true" />
							</span>
						</c:when>
						<c:otherwise>
							<span class="product-price__value product-price__value--was-price">
								<format:price priceData="${product.wasPrice}"/>
							</span>
						</c:otherwise>
					</c:choose>
				</div>
			</c:if>
			<c:set var="isWeightedProduct" value="${product.estimatedPrice != null}" />
			<c:choose>
				<c:when test="${isWeightedProduct}">
					<span class="js-productPrice product-price__value product-price__value--current ${isWeightedProduct ? 'is-weighted-product': ''}" data-productid="${product.code}" data-price="${product.estimatedPrice.value}" data-currency-symbol="${currentCurrency.symbol}">
						<product:productListerItemPrice product="${product}" displayWeightedEstimatedPrice="${isWeightedProduct}"/>
					</span>
					<span class="product-price__price-each is-weighted-product" data-price="${product.price.value}" data-productid="${product.code}" data-currency-symbol="${currentCurrency.symbol}">
						<span class="js-productPriceEach" data-price="${product.price.value}" data-productid="${product.code}" data-currency-symbol="${currentCurrency.symbol}">${fn:replace(product.price.formattedValue,' ', '')}</span>
					</span>
				</c:when>
				<c:otherwise>
					<span class="js-productPrice product-price__value product-price__value--current" data-price="${product.price.value}" data-productid="${product.code}" data-currency-symbol="${currentCurrency.symbol}"><product:productListerItemPrice product="${product}"/></span>
					<c:if test="${not empty product.unitPriceStr}">
						<span class="js-productPrice product-price__price-each" data-price="${product.unitPriceStr}" data-productid="${product.code}" data-currency-symbol="${currentCurrency.symbol}" data-price-descriptor="${product.unitPriceDescriptor}">${product.unitPriceStr}</span>
					</c:if>
				</c:otherwise>
			</c:choose>
		</c:otherwise>
	</c:choose>
</div>
