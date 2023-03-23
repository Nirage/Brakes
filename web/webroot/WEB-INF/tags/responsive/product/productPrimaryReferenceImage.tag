<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="product" required="true" type="de.hybris.platform.commercefacades.product.data.ProductData" %>
<%@ attribute name="format" required="true" type="java.lang.String" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="theme" tagdir="/WEB-INF/tags/shared/theme" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>

<c:set var="image404" value="?img404=image-not-available&" />
<c:set var="imageNotAvailable" value="https://i1.adis.ws/i/Brakes/image-not-available?" />

<c:set value="${ycommerce:productImage(product, format)}" var="primaryImage"/>
<c:set var="altTextHtml" value="${fn:escapeXml(product.name)}" />

<c:choose>
	<c:when test="${not empty primaryImage}">
		<c:set var="productImage" value="${primaryImage.url}${image404}" />
		<c:if test="${not empty primaryImage.altText}">
			<c:set var="altTextHtml" value="${fn:escapeXml(primaryImage.altText)}" />
		</c:if>
	</c:when>
	<c:otherwise>
		<c:set var="productImage" value="${imageNotAvailable}" />
	</c:otherwise>
</c:choose>


<picture class="product-item__picture">
	<source data-size="desktop" srcset="${productImage}$plp-desktop$" media="(min-width: 1240px)">
	<source data-size="tablet" srcset="${productImage}$plp-tablet$" media="(min-width: 768px)">
	<source data-size="mobile" srcset="${productImage}$plp-mobile$">
	<img class="product-item__image product-image js-fallbackImage" src="${productImage}$plp-desktop$" alt="${altTextHtml}" title="${altTextHtml}">
</picture>