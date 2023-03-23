<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="common" tagdir="/WEB-INF/tags/responsive/common" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ taglib prefix="template" tagdir="/WEB-INF/tags/addons/b2bpunchoutaddon/responsive/template" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="promotions" tagdir="/WEB-INF/tags/responsive/promotions" %>

<template:page pageTitle="${pageTitle}">
    <div class="container mini-basket__boundary" id="js-stickyMiniBasketBoundary">
        <div class="product-grid__wrapper">
            <c:if test="${not empty categoryUrl}">
                <picture class="category-tile__picture">
                    <source data-size="desktop" srcset="${categoryURL}" media="(min-width: 1240px)">
                    <source data-size="tablet" srcset="${categoryURL}$plp-tablet$" media="(min-width: 768px)">
                    <source data-size="mobile" srcset="${categoryURL}$plp-mobile$">
                    <img class="category-tile__image category-image js-fallbackImage" src="${categoryURL}" alt="${altTextHtml}" title="${altTextHtml}">
                </picture>
            </c:if>
            <cms:pageSlot position="CategoryContentSlot" var="feature" element="div">
                <cms:component component="${feature}" element="div"/>
            </cms:pageSlot>

            <cms:pageSlot position="Section1" var="feature" element="div" class="product-grid-section1-slot">
                <cms:component component="${feature}" element="div" class="yComponentWrapper map product-grid-section1-component"/>
            </cms:pageSlot>

            <div class="row">
                <div class="xs-hidden col-sm-4 col-md-3  h-space-2 product-grid__aside">
                    <cms:pageSlot position="AdditionalCategories" var="feature" element="div">
                        <cms:component component="${feature}" element="div" class="yComponentWrapper"/>
                    </cms:pageSlot>
                    <cms:pageSlot position="ProductLeftRefinements" var="feature" element="div" class="product-grid-left-refinements-slot">
                        <cms:component component="${feature}" element="div" class="yComponentWrapper product-grid-left-refinements-component"/>
                    </cms:pageSlot>
                </div>
                <div class="col-xs-12 col-sm-8 col-md-9 product-grid__main js-productGrid">
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="site-header site-header--align-left">
                                <h1 class="site-header__text site-header--align-left ">${categoryName}</h1>
                                <span class="site-header__rectangle site-header__rectangle--align-left"></span>
                                <div class="read-more-less mb1">
									<input type="radio" id="read-more" name="read-toggle" />
									<input type="radio" id="read-less" name="read-toggle" checked />
									<div class="read-more-less__paragraph elipsis-2-line font-size-1">
										<c:if test="${not empty categoryDescription}">
											${categoryDescription}
										</c:if>
									</div>
									<div class="read-more-less__buttons hide">
										<label for="read-more" class="btn-initial"><spring:theme code="categoryDesc.readmore" /></label>
										<label for="read-less" class="btn-initial"><spring:theme code="categoryDesc.readless" /></label>
									</div>
								</div>
                            </div>
                        </div>
                    </div>
                    <%-- Main container --%>
                    <cms:pageSlot position="ProductGridSlot" var="feature" element="div" class="product-grid-right-result-slot">
                        <cms:component component="${feature}" element="div" class="product__list--wrapper yComponentWrapper product-grid-right-result-component"/>
                    </cms:pageSlot>
                </div>
            </div>
        </div>
		<%-- <cart:miniBasketComponent /> --%>
    </div>
	<cart:quantityCartModals />
	<promotions:promoQuantityZeroModal />
	<product:tradeCalculatorModal />
</template:page>
