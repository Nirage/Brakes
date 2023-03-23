<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement"
	tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<sec:authorize access="hasAnyRole('ROLE_ANONYMOUS')">
    <c:set var="isLoggedOut" value="true" />
</sec:authorize>

<spring:url value="/favourites/rollover/add/{/componentUid}/{/productCode}" var="rolloverPopupUrl" htmlEscape="false">
	<spring:param name="componentUid"  value="${component.uid}"/>
	<spring:param name="productCode"  value="${product.code}"/>
</spring:url>
<c:url value="/sign-in" var="loginUrl"/>

<c:if test="${empty punchoutUser}">
    <c:choose>
        <c:when test="${hasProductInFavourites}">
            <c:set var="heartStyleClass" value="${styleClass} icon icon-heart-filled"/>
        </c:when>
        <c:otherwise>
            <c:set var="heartStyleClass" value="${styleClass} icon icon-Heart"/>
        </c:otherwise>
    </c:choose>

    <div class="add-to-favourites js-displayWishlist ${product.isDiscontinued eq true || product.isOutOfStock eq true ? 'product-item--discontinuedFavicon':""}" data-product-id="${product.code}">
        <c:if test="${isLoggedOut}">
            <a href="${loginUrl}">
        </c:if>
        <span class="${heartStyleClass} js-wishlistIcon"  title="<spring:theme code="favourites.add"/>"></span>
        <c:if test="${showText}">
            <span class="add-to-favourites__text hidden-xs"><spring:theme code="productDetails.addToFavourites" /></span>
        </c:if>
        <c:if test="${isLoggedOut}">
            </a>
        </c:if>
    </div>

    <div class="js-productWishlistHolder product-wishlist-holder ${showText ? 'has-text' : ''}"></div>
</c:if>