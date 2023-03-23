<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>

<%@ attribute name="product" required="true" type="de.hybris.platform.commercefacades.product.data.ProductData" %>
<%@ attribute name="displayWeightedEstimatedPrice" required="false" type="java.lang.Boolean" %>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format" %>

<ycommerce:testId code="searchPage_price_label_${product.code}">
	<c:set var="VAT_asterisk" value="" />
	<c:if test="${product.subjectToVAT}">
		<c:set var="VAT_asterisk">
			<span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color "></span>
		</c:set>
	</c:if>

	<%-- if product is multidimensional with different prices, show range, else, show unique price --%>

	<c:choose>
		<c:when test="${product.multidimensional and (product.priceRange.minPrice.value ne product.priceRange.maxPrice.value)}">
			<format:price priceData="${product.priceRange.minPrice}"/> - <format:price priceData="${product.priceRange.maxPrice}"/>
		</c:when>
		<c:otherwise>
			<c:choose>
				<c:when test="${displayWeightedEstimatedPrice}">
					<span class="js-productPrice" data-price="${product.estimatedPrice.value}" data-currency-symbol="${currentCurrency.symbol}">
						<c:if test="${not empty product.estimatedPrice}">
							<format:price priceData="${product.estimatedPrice}"/>
						</c:if>
						<c:if test="${empty product.estimatedPrice}">
							Pricing Unavailable
						</c:if>
					</span>${VAT_asterisk}
				</c:when>
				<c:otherwise>
					<span class="js-productPrice" data-price="${product.price.value}" data-currency-symbol="${currentCurrency.symbol}">
						<c:if test="${not empty product.price}">
							<format:price priceData="${product.price}"/>
						</c:if>
						<c:if test="${empty product.price}">
							Pricing Unavailable
						</c:if>
					</span>${VAT_asterisk}
				</c:otherwise>
			</c:choose>
		</c:otherwise>
	</c:choose>
</ycommerce:testId>
