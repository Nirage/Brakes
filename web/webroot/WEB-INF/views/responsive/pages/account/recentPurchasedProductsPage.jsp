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
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="favourites" tagdir="/WEB-INF/tags/responsive/favourites" %>
<%@ taglib prefix="promotions" tagdir="/WEB-INF/tags/responsive/promotions" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components" %>

<template:page pageTitle="${pageTitle}">
  <c:set var="numberOfLoadedProducts" value="${fn:length(searchPageData.results)}" />
  <c:set var="hasPreviousPage" value="${searchPageData.pagination.currentPage > 1}"/>
  <c:set var="hasNextPage" value="${searchPageData.pagination.currentPage < searchPageData.pagination.numberOfPages}"/>
  <input type="hidden" class="js-initialNumberOfLoadedProducts" value="${numberOfLoadedProducts}">
  <input type="hidden" class="jsWeeksInPast" value="${currentWeeksInPast}"/>

  <div class="container">
    <div class="row">
      <div class="xs-hidden col-xs-12 col-md-2 h-topspace-2">
        <a class="btn btn-back-normal header__btn-back" href="/my-account/orders">
          <i class="icon icon--sm icon-chevron-left"></i>
          <spring:theme code="text.myaccount.orderHistory"/>
        </a>
      </div>
    </div>

    <cms:pageSlot position="ProductLeftRefinements" var="feature" element="div" class="search-grid-page-left-refinements-slot">
        <cms:component component="${feature}"/>
    </cms:pageSlot>

    <div class="row">
      <div class="col-xs-12">
        <div class="site-header site-header--align-left">
          <h1 class="site-header__text"><spring:theme code="text.myaccount.recentPurchases"/></h1>
        </div>
      </div>
      <div class="col-xs-12">
        <nav:recentPurchasedProductsFilterForm searchPageData="${searchPageData}" desktop="true"/>
        <div id="applied-filters">
            <nav:facetNavAppliedFilters pageData="${searchPageData}" filterThreshold="6"/>
        </div>

        <c:choose>
          <c:when test="${numberOfLoadedProducts > 0}">
            <c:if test="${hasPreviousPage}">
              <components:loadMoreBtn direction="previous" searchPageData="${searchPageData}" customCSSClass="mtb1"/>
            </c:if>
            <cms:pageSlot position="RecentPurchasedProductsGridPageSlot" var="feature" element="div" class="product-grid-right-result-slot">
              <cms:component component="${feature}" element="div" class="product__list--wrapper"/>
            </cms:pageSlot>
            <c:if test="${hasNextPage}">
              <components:loadMoreBtn direction="next" searchPageData="${searchPageData}" customCSSClass="h-space-4"/>
            </c:if>
          </c:when>
          <c:otherwise>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
    <div class="js_spinner spinning-div">
      <img class="spinning-image" src="${themeResourcePath}/images/Spinner-1s-75px.gif" alt="Loading..." />
    </div>
  </div>
  <cart:quantityCartModals/>
  <nav:plpHandlebarsTemplates />
  <favourites:newFavouritiesList/>
  <nav:plpHandlebarsTemplates />
  <promotions:promoQuantityZeroModal />
  <nav:facetsHandlebarsTemplates />
</template:page>

