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
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>

<spring:url value="/favourites/rollover/{/componentUid}" var="rolloverPopupUrl" htmlEscape="false">
	<spring:param name="componentUid"  value="${component.uid}"/>
</spring:url>

<c:url value="/my-account/favourites" var="favouritesUrl"/>
<c:url value="/sign-in" var="loginUrl"/>


<sec:authorize access="hasAnyRole('ROLE_ANONYMOUS')" >
	<a tabindex="0" href="${loginUrl}" class="btn nav__links-item__link ga-nav-bar-4">
		<span class="icon icon-Heart"></span>
		<span class="nav__links-item-text"><spring:theme code="header.wishlist.mylist"/></span>
	</a>
</sec:authorize>
<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
	<a tabindex="0" href="${favouritesUrl}" class="btn nav__links-item__link js-favouritesLink ga-nav-bar-4"
	   data-mini-favourites-url="${rolloverPopupUrl}"
	   data-mini-favourites-name="<spring:theme code="text.favourites"/>"
	   data-mini-favourites-empty-name="<spring:theme code="popup.favourites.empty"/>"
	   data-mini-favourites-items-text="<spring:theme code="favourites.items"/>"
	>
		<span class="icon icon-Heart"></span>
		<span class="nav__links-item-text"><spring:theme code="header.wishlist.mylist"/></span>
	</a>
	<div class="mini-favourites js-favouritesContainer hide">
		<div id="jsMiniFavourites"></div>
	</div>
	<nav:miniFavouritesHandlebarsTemplate />
</sec:authorize>