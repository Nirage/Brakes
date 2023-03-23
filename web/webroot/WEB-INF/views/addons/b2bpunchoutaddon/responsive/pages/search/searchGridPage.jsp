<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>

<%@ taglib prefix="template" tagdir="/WEB-INF/tags/addons/b2bpunchoutaddon/responsive/template" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>
<%@ taglib prefix="promotions" tagdir="/WEB-INF/tags/responsive/promotions" %>

<template:page pageTitle="${pageTitle}">
    <div class="container mini-basket__boundary" id="js-stickyMiniBasketBoundary">
        <div class="product-grid__wrapper">
            <div class="row">
                <div class="results search-result">	
                <h1 class="search-result__title col-xs-12"><span class="search-result__term">"${searchPageData.freeTextSearch}"</span><br class="visible-xs"/>&nbsp;<spring:theme code="search.page.searchText"/>&nbsp;<span class="search-result__count">(<span class="js-searchPageTotalCount">${searchPageData.pagination.totalNumberOfResults}</span>)</span></h1>
                    <nav:searchSpellingSuggestion suggestions="${searchPageData.suggestions}" />
                </div>
                <div class="xs-hidden col-sm-4 col-md-3">
                    <cms:pageSlot position="ProductLeftRefinements" var="feature" element="div" class="search-grid-page-left-refinements-slot">
                        <cms:component component="${feature}" element="div" class="search-grid-page-left-refinements-component"/>
                    </cms:pageSlot>
                </div>
                <div class="col-xs-12 col-sm-8 col-md-9">
                    <cms:pageSlot position="SearchResultsGridSlot" var="feature" element="div" class="search-grid-page-result-grid-slot">
                        <cms:component component="${feature}" element="div" class="search-grid-page-result-grid-component"/>
                    </cms:pageSlot>
                </div>
            </div>
        </div>
        <%-- <cart:miniBasketComponent customClass="mini-basket-component--search-page"/> --%>
    </div>
	<cart:quantityCartModals/>
	<cart:deleteCartModal />
	<cart:clearCartItemsModal />
	<promotions:promoQuantityZeroModal />
	<product:tradeCalculatorModal />
</template:page>
