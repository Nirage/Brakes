<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ attribute name="product" required="true" type="de.hybris.platform.commercefacades.product.data.ProductData" %>
<%@ attribute name="format" required="true" type="java.lang.String" %>
<%@ attribute name="ttMobile" required="false" type="java.lang.String" %>
<%@ attribute name="ttTablet" required="false" type="java.lang.String" %>
<%@ attribute name="ttDesktop" required="false" type="java.lang.String" %>

<c:set var="primaryImage" value="${ycommerce:productImage(product, format)}"/>
<c:set var="altTextHtml" value="${fn:escapeXml(product.name)}" />

<c:choose>
	<c:when test="${not empty primaryImage}">
		<c:set var="productImage" value="${fn:replace(primaryImage.url, '.jpg', '')}" />
		<c:if test="${not empty primaryImage.altText}">
			<c:set var="altTextHtml" value="${fn:escapeXml(primaryImage.altText)}" />
		</c:if>
	</c:when>
	<c:otherwise>
		<c:set var="productImage" value="https://i1.adis.ws/i/Brakes/image-not-available/" />
	</c:otherwise>
</c:choose>

<picture class="product-item__picture flex justify-content-center">
	<source data-size="desktop" data-srcset="${productImage}${ttDesktop}&fmt=webp" media="(min-width: 1240px)" type="image/webp">
	<source data-size="desktop" data-srcset="${productImage}${ttDesktop}" media="(min-width: 1240px)" type="image/jpeg">
	<source data-size="tablet" data-srcset="${productImage}${ttTablet}&fmt=webp" media="(min-width: 768px)" type="image/webp">
	<source data-size="tablet" data-srcset="${productImage}${ttTablet}" media="(min-width: 768px)" type="image/jpeg">
	<source data-size="mobile" data-srcset="${productImage}${ttMobile}&fmt=webp" type="image/webp">
	<source data-size="mobile" data-srcset="${productImage}${ttMobile}" type="image/jpeg">
	<img data-sizes="auto" class="product-item__image product-image lazyload" data-src="${productImage}${ttDesktop}" alt="${altTextHtml}" title="${altTextHtml}" width="213" height="142">
	<div class="loader__image"></div>
</picture>