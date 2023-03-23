<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template"%>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="formElement" tagdir="/WEB-INF/tags/responsive/formElement"%>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>


<spring:htmlEscape defaultHtmlEscape="true" />

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')" >

	<c:url value="/favourites/add" var="addToFavouriteUrl"/>
	<c:url value="/favourites/create" var="createFavouriteUrl"/>

		<ycommerce:testId code="add-to-favourites-popup">
			<div class="wishlist-popover js-wishlistPopoverContent">
				<span class="icon icon-close wishlist-popover__close js-wishlistPopoverClose"></span>
				<c:if test="${numberShowing > 0}">
					<div class="wishlist-popover__heading">
						<spring:theme code="popup.favourites.addto.header" />
					</div>
				</c:if>
				<c:if test="${numberShowing > 0}">
					<ul class="wishlist-popover__list">
						<c:forEach items="${response.includedIn}" var="favourite" end="${numberShowing - 1}">
							<c:url value="${addToFavouriteUrl}/${ycommerce:encodeUrl(favourite.uid)}/${productCode}" var="favouriteUrl"/>
							<li class="wishlist-popover__item">
							
								<div class="wishlist-popover__item-is-added">
									<span class="wishlist-popover__item-icon icon icon-tick"></span>
									<span class="wishlist-popover__item-text wishlist-popover__item-text--added">${fn:escapeXml(favourite.name)}&nbsp;<spring:theme code="popup.favourites.addto.list.item" arguments="${favourite.itemsCount}"/></span>
								</div>
							</li>
						</c:forEach>
						<c:if test="${not empty response.excluded && not empty response.includedIn}">
						<li class="wishlist-popover__item">	
							<div class="wishlist-popover__item-add">
								<span class="wishlist-popover__item-text">----------------------</span>
							</div>
						</li>	
						</c:if>
						<c:forEach items="${response.excluded}" var="favourite" end="${numberShowing - 1}">
						<c:url value="${addToFavouriteUrl}/${ycommerce:encodeUrl(favourite.uid)}/${productCode}" var="favouriteUrl"/>
						<li class="wishlist-popover__item">		
							<div class="wishlist-popover__item-add js-addToList" data-favourite-url="${favouriteUrl}">
								<span class="wishlist-popover__item-icon icon icon-caret-right"></span>
								<span class="wishlist-popover__item-text">${fn:escapeXml(favourite.name)}&nbsp;<spring:theme code="popup.favourites.addto.list.item" arguments="${favourite.itemsCount}"/></span>
						        <%-- <spring:theme code="popup.favourites.addto.list.item" arguments="${fn:escapeXml(favourite.name)},${fn:escapeXml(fn:length(favourite.entries))}"/></span> --%>
							</div>
								
							</li>
						</c:forEach>
					</ul>
				</c:if>
			    <c:if test="${numberOfFavourites < limitWishlist}">
    			<span class="wishlist-popover__create-btn btn-create" data-toggle="modal" data-target="#createWishlistModal">
						<span class="btn-create__icon"></span>
						<span class="btn-create__text"><spring:theme code="popup.favourites.create" /></span>
					</span>
				</c:if>
				<div class="wishlist-popover__msg wishlist-popover__msg-success">
					<span class="icon icon-tick wishlist-popover__msg-icon wishlist-popover__msg-icon--success"></span>
					<span class="wishlist-popover__msg-text"><spring:theme code="popup.favourites.addto.success" /></span>
				</div>
				<div class="wishlist-popover__msg wishlist-popover__msg-error">
					<span class="icon icon-close wishlist-popover__msg-icon wishlist-popover__msg-icon--error"></span>
					<span class="wishlist-popover__msg-text"><spring:theme code="popup.favourites.addto.error" /></span>
				</div>
			</div>
		</ycommerce:testId>
</sec:authorize>