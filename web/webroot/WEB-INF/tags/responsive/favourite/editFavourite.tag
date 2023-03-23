<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="favourite" required="true" type="com.envoydigital.brakes.facades.wishlist.data.FavouritesData" %>
<%@ attribute name="product" required="false" type="de.hybris.platform.commercefacades.product.data.ProductData" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="action" tagdir="/WEB-INF/tags/responsive/action" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ attribute name="isProduct" required="false" type="java.lang.Object"%>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<spring:htmlEscape defaultHtmlEscape="false" />
<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')" >
	<div class="fav-item__edit js-editWishlist ${isProduct ? 'fav-item__edit--product' : ''} "  <c:if test="${not empty product}"> data-product-code="${product.code}" </c:if>>
		<span class="icon icon-more ${isProduct ? 'icon-user-actions' : ''}" ></span>
	</div>
	<div class="fav-item__edit-container js-editWishlistContainer">
		<c:choose>
			<c:when test="${not empty product}">
				<%-- wishlist details --%>
				<components:wishlistActions sizeOfWishlist="${fn:length(favouriteItemPageData.results)}"/>
			</c:when>
			<c:otherwise>
				<%-- Wishlist Listing page --%>
				<components:wishlistActions componentName="wishlistListingPage" sizeOfWishlist="${fn:length(favouritesPageData.results)}"/>
			</c:otherwise>
		</c:choose>
	</div>
</sec:authorize>


