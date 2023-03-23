<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="storepickup" tagdir="/WEB-INF/tags/responsive/storepickup" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="favourites" tagdir="/WEB-INF/tags/responsive/favourites" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>

<c:set var="imageNotAvailable" value="https://i1.adis.ws/i/Brakes/image-not-available?" />

<template:page pageTitle="${pageTitle}">
	<div class="favourites-page container">
		<div class="row">
			<cms:pageSlot position="FavouriteGridSlot" var="feature" element="div" class="favourite-grid-right-result-slot js-favouriteListPage col-xs-12">
				<cms:component component="${feature}" element="div" class=""/>
			</cms:pageSlot>
		</div>
	</div>

	<favourites:newFavouritiesList/>
	<favourites:amendFavouritiesListName/>
	<favourites:deleteFavouritesListModal/>

	<script id="wishlist-template" type="text/x-handlebars-template">
		<div class="fav-item js-favouriteItem" data-favourite="{{uid}}">
			<a class="fav-item__thumb" href="/my-account/favourites/{{uid}}" title="{{name}}">
				<picture class="fav-item__picture">
					<source data-size="desktop" srcset="${imageNotAvailable}$favlist-desktop$" media="(min-width: 1240px)">
					<source data-size="tablet" srcset="${imageNotAvailable}$favlist-tablet$" media="(min-width: 768px)">
					<source data-size="mobile" srcset="${imageNotAvailable}$favlist-mobile$">
					<img class="fav-item__image fav-item-image js-fallbackImage" src="${imageNotAvailable}$favlist-desktop$" alt="{{name}}" title="{{name}}">
				</picture>
			</a>
			<div class="fav-item__info">
				<a class="fav-item__name js-favItemName" href="/my-account/favourites/{{uid}}">{{name}}</a>
				<div class="fav-item__edit js-editWishlist  " data-url="/favourite/rollover/edit/{{uid}}">
					<span class="icon icon-more "></span>
				</div>
				<div class="fav-item__edit-container js-editWishlistContainer">
					<components:wishlistActions componentName="wishlistListingPage" sizeOfWishlist="${fn:length(favouritesPageData.results)}"/>
				</div>
				<div class="fav-item-details__qty"><spring:theme code="wishlist.itemsCount" arguments="0"/></div>
			</div>
		</div>
	</script>
</template:page>