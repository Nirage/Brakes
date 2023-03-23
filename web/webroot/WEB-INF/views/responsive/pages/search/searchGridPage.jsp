<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
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
					<div class="results search-result">
						<sec:authorize access="hasAnyRole('ROLE_ANONYMOUS')">
							<button type="button" class="btn btn-secondary position-absolute--right" data-toggle="modal" data-target="#tradeCalculatorModal">
								<div class="btn__text-wrapper">
									<i class="icon icon-calculator btn__icon"></i>
									<span class="btn__text">
										<spring:theme code="customerTools.tradeCalculator.button"/>
									</span>
								</div>
							</button>
						</sec:authorize>
						<h1 class="search-result__title col-xs-12">
							<span class="search-result__term">"${searchPageData.freeTextSearch}"</span>
							<br class="visible-xs"/>&nbsp;<spring:theme code="search.page.searchText"/>&nbsp;
							<span class="search-result__count">(<span class="js-searchPageTotalCount">${searchPageData.pagination.totalNumberOfResults}</span>)</span>
						</h1>
						<nav:searchSpellingSuggestion suggestions="${searchPageData.suggestions}" />
					</div>
				</div>
				<div class="col-xs-12">
					<cms:pageSlot position="SearchResultsGridSlot" var="feature" element="div" class="search-grid-page-result-grid-slot">
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