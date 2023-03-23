<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="template" tagdir="/WEB-INF/tags/responsive/template" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="favourites" tagdir="/WEB-INF/tags/responsive/favourites" %>
<%@ taglib prefix="promotions" tagdir="/WEB-INF/tags/responsive/promotions" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="promoPageTitle" value="loggedOut"/>

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
	<c:set var="promoPageTitle" value="loggedIn"/>
</sec:authorize>

<template:page pageTitle="${pageTitle}">
  <div class="container">
    <cms:pageSlot position="ProductLeftRefinements" var="feature" element="div" class="search-grid-page-left-refinements-slot">
        <cms:component component="${feature}"/>
    </cms:pageSlot>

    <div class="row">
      <div class="xs-hidden col-xs-12">
        <a class="btn btn-back-normal header__btn-back" href="/">
          <span class="btn-back__inner">
            <i class="icon icon--sm icon-chevron-left"></i>
            <spring:theme code="promoPage.goBack"/>
          </span>
        </a>
      </div>
      <div class="col-xs-12">
        <div class="site-header site-header--align-left">
          <h1 class="site-header__text site-header__text--underline site-header__text--underline-left">
            <spring:theme code="promoPageTitle.${promoPageTitle}"/>
          </h1>
        </div>
      </div>
      <nav:actionsBar
        top="true"
        supportShowPaged="${isShowPageAllowed}"
        supportShowAll="${isShowAllAllowed}"
        searchPageData="${searchPageData}"
        searchUrl="${searchPageData.currentQuery.url}"
        numberPagesShown="${numberPagesShown}"
      />
      <div id="applied-filters">
          <nav:facetNavAppliedFilters pageData="${searchPageData}" filterThreshold="6"/>
      </div>

      <cms:pageSlot position="PromoProductsListSlot" var="feature" element="div" class="product-list-right-slot">
        <cms:component component="${feature}" element="div" class="product__list--wrapper yComponentWrapper product-list-right-component"/>
      </cms:pageSlot>
    </div>
  </div>
  <div class="js_spinner spinning-div">
    <img class="spinning-image" src="${themeResourcePath}/images/Spinner-1s-75px.gif" alt="Loading..." />
  </div>
	<c:set var="pageToLoadGetUrl" value="/my-promo-products/resultsandfacets?q=${searchPageData.currentQuery.query.value}&${pageToLoadGetParam}" />  
  <c:if test="${siteUid eq 'brakes'}">
  <c:set var="pageToLoadGetUrl" value="/promotions/resultsandfacets?q=${searchPageData.currentQuery.query.value}&${pageToLoadGetParam}" />
  </c:if>

  <cart:quantityCartModals/>
  <favourites:newFavouritiesList/>
  <nav:plpHandlebarsTemplates />
  <nav:similarProductsHandlebarsTemplate/>
  <promotions:promoQuantityZeroModal />
  <nav:facetsHandlebarsTemplates />
</template:page>