<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="storepickup" tagdir="/WEB-INF/tags/responsive/storepickup" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="favourites" tagdir="/WEB-INF/tags/responsive/favourites" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="promotions" tagdir="/WEB-INF/tags/responsive/promotions" %>

<template:page pageTitle="${pageTitle}">
<input type="hidden" id="cartLargeQuantity" value="${cartLargeQuantity}" />
<input type="hidden" id="cartMaximumQuantity" value="${cartMaximumQuantity}" />

<div class="container mini-basket__boundary" id="js-stickyMiniBasketBoundary" data-uid="${favouriteItemPageData.favourite.uid}">
	<div class="row">
		<div class="col-xs-12 js-productsGridContainer">
			<div class="row">
				<div class="xs-hidden col-xs-12 h-topspace-2">
					<a class="btn btn-back-normal header__btn-back" href="/my-account/favourites">
						<span class="btn-back__inner">
							<span class="icon icon--sm icon-chevron-left"></span>
							<span class=""><spring:theme code="back.to.favourites"/></span>
						</span>
					</a>
				</div>
				<div class="col-xs-12  ${favouriteItemPageData.pagination.totalNumberOfResults > 0 ? 'col-sm-5' : ''}">
					<div class="site-header site-header--align-left">
						<h1 class="site-header__text site-header--align-left js-wishlistName">${favouriteItemPageData.favourite.name}</h1>
						<ycommerce:testId code="favouriteItems_productsFound_label">
							<div class="totalResults">
								<c:choose>
									<c:when test="${favouriteItemPageData.pagination.totalNumberOfResults == 1}">
										<spring:theme code="favouriteitems.page.totalResult"/>
									</c:when>
									<c:otherwise>
										<spring:theme code="favouriteitems.page.totalResults" arguments="${favouriteItemPageData.pagination.totalNumberOfResults}"/>
									</c:otherwise>
								</c:choose>

							</div>
						</ycommerce:testId>
					</div>
				</div>
				<c:if test="${favouriteItemPageData.pagination.totalNumberOfResults > 0}">
					<div class="col-xs-12 col-sm-7">
						<div class="site-header-actions">
							<button type="button" class="btn btn-success site-header-actions__btn site-header-actions__btn--add-to-basket js-addWishlistToCartBtn" ><spring:theme code="favouriteitems.page.button.addlisttocart"/></button>
							<button class="btn btn-secondary site-header-actions__btn site-header-actions__btn--print-list js-wishlistPrint"><spring:theme code="favouriteitems.page.button.printList"/></button>
						</div>
					</div>
				</c:if>
			</div>
			<%-- Main container --%>
			<cms:pageSlot position="FavouriteItemGridSlot" var="feature" element="div" class="product-grid__wrapper">
				<cms:component component="${feature}" element="div" class="product__list--wrapper wishlists-details h-space-2"/>
			</cms:pageSlot>
			<cart:miniBasketComponent customClass="mini-basket-component--align-right"/>
		</div>
	</div>
</div>
<div class="js_spinner spinning-div">
	<img class="spinning-image" src="${themeResourcePath}/images/Spinner-1s-75px.gif" alt="Loading..." />
</div>
<favourites:deleteFavouritesListModal/>
<favourites:deleteFavouritesItemModal/>
<favourites:addWishlistToCartModal/>
<favourites:wishlistToCartErrorModal/>
<cart:quantityCartModals/>
<promotions:promoQuantityZeroModal />
<script>
var wishlistDetails = {
	id: "${favouriteItemPageData.favourite.uid}",
	totalNumber: ${favouriteItemPageData.pagination.totalNumberOfResults},
	pageSize: ${favouriteItemPageData.pagination.pageSize},
	currentPage: ${favouriteItemPageData.pagination.currentPage},
	numberOfPages: ${favouriteItemPageData.pagination.numberOfPages},
	sortBy: "${favouriteItemPageData.sorts[0].code}"
};
</script>
</template:page>