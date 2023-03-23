<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="favourite" required="true" type="com.envoydigital.brakes.facades.wishlist.data.FavouritesData" %>
<%@ taglib prefix="favourite" tagdir="/WEB-INF/tags/responsive/favourite" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="action" tagdir="/WEB-INF/tags/responsive/action" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="utils" uri="http://brake.co.uk/tld/encrypt" %>
<%@ attribute name="index" required="false" type="java.lang.String"%>

<spring:htmlEscape defaultHtmlEscape="false" />

<sec:authorize access="!hasRole('ROLE_ANONYMOUS')">
	<c:set var="isUserLoggedIn" value="true"/>
</sec:authorize>

<c:set var="exceedsTabletLength" value="false" />
<c:set var="exceedsMobileLength" value="false" />

<c:url value="/my-account/favourites" var="favouritesUrl"/>
<c:url value="${favouritesUrl}/${ycommerce:encodeUrl(utils:encrypt(favourite.uid))}" var="favouriteUrl"/>

<div class="fav-item product-item mt1 p0 ${component.componentType != 'SHARED' ? 'js-favouriteItem' : ''}" data-favourite="${fn:escapeXml(favourite.uid)}" data-order="${index}">
	<ycommerce:testId code="favourite_wholeFavourite">
		<a class="fav-item__thumb" href="${fn:escapeXml(favouriteUrl)}" title="${fn:escapeXml(favourite.name)}">
			<product:productImageLazyLoad product="${favourite.lastEntryProduct}" ttMobile="$favlist-mobile$" ttTablet="$favlist-tablet$" ttDesktop="$favlist-desktop$" format="product"/>
		</a>
		<div class="fav-item__info">
			<ycommerce:testId code="favourite_favouriteName">	
				<a class="fav-item__name js-favItemName" href="${fn:escapeXml(favouriteUrl)}">
					<c:out escapeXml="false" value="${favourite.name}" />
				</a>
			</ycommerce:testId>
			<c:if test="${component.componentType != 'SHARED'}">
				<favourite:editFavourite favourite="${favourite}" />
			</c:if>
			<div class="fav-item-details__qty">
				<c:choose>
					<c:when test="${favourite.itemsCount eq 1}">
						<spring:theme code="wishlist.itemCount"/>
					</c:when>
					<c:otherwise>
						<spring:theme code="wishlist.itemsCount" arguments="${favourite.itemsCount}"/>
					</c:otherwise>
				</c:choose>
			</div>

		</div>
	</ycommerce:testId>
</div>