<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>
<%@ taglib prefix="promotions" tagdir="/WEB-INF/tags/responsive/promotions" %>


<template:page pageTitle="${pageTitle}">
	<div class="container mini-basket__boundary" id="js-stickyMiniBasketBoundary">
		<div class="product-grid__wrapper">
			<cms:pageSlot position="ProductLeftRefinements" var="feature" element="div" class="search-grid-page-left-refinements-slot">
				<cms:component component="${feature}"/>
			</cms:pageSlot>

			<div class="row">
				<div class="col-xs-12">
					<cms:pageSlot position="OccasionsSearchResultsGrid" var="feature" element="div" class="search-grid-page-result-grid-slot">
						<cms:component component="${feature}" element="div" class="search-grid-page-result-grid-component"/>
					</cms:pageSlot>
				</div>
			</div>
		</div>
		<cart:miniBasketComponent customClass="mini-basket-component--search-page"/>
	</div>
	<cart:quantityCartModals/>
	<cart:deleteCartModal />
	<cart:clearCartItemsModal />
	<promotions:promoQuantityZeroModal />
	<product:tradeCalculatorModal />
</template:page>