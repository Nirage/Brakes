<%@ tag trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ attribute name="direction" required="true" type="java.lang.String"%>
<%@ attribute name="customCSSClass" required="false" type="java.lang.String"%>
<%@ attribute name="searchPageData" required="true" type="de.hybris.platform.commerceservices.search.pagedata.SearchPageData" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="searchUrl" value="${fn:substringBefore(searchPageData.currentQuery.url, '?')}" />
<c:set var="weeksInPast" value="${currentWeeksInPast}"/>

<c:choose>
  <c:when test="${direction eq 'previous'}">
    <c:set var="pageToLoadGetParam" value="page=${(searchPageData.pagination.currentPage - 1)}" />
    <c:set var="action" value="prepend"/>
    <spring:theme var="loadMoreCTA" code="product.grid.loadPrevious" />
  </c:when>
  <c:otherwise>
    <c:set var="pageToLoadGetParam" value="page=${(searchPageData.pagination.currentPage + 1)}" />
    <c:set var="action" value="append"/>
    <spring:theme var="loadMoreCTA" code="product.grid.loadMore" />
  </c:otherwise>
</c:choose>
<c:choose>
  <c:when test="${not empty fn:trim(searchPageData.currentQuery.query.value)}">
      <c:set var="querString" value="q=${searchPageData.currentQuery.query.value}&" />
  </c:when>
  <c:otherwise>
    <c:set var="querString" value="" />
  </c:otherwise>
</c:choose>
<c:choose>
  <c:when test="${cmsPage.uid eq 'recentPurchasedProductsPage'}">
      <c:set var="pageToLoadGetUrl" value="${searchUrl}/resultsandfacets?q=${searchPageData.currentQuery.query.value}&${pageToLoadGetParam}&weeksInPast=${weeksInPast}" />
  </c:when>
  <c:otherwise>
      <c:set var="pageToLoadGetUrl" value="${searchUrl}/resultsandfacets?q=${searchPageData.currentQuery.query.value}&${pageToLoadGetParam}" />
  </c:otherwise>
 </c:choose> 

<c:choose>
  <c:when test="${cmsPage.uid eq 'myPromoProducts' and siteUid eq 'brakes'}">
    <button class="btn btn-secondary js-plpLoadMore product__listing-load-more-btn" data-base-url="/promotions/monthly-promotions<c:if test="${not empty querString}">${querString}</c:if>"
        data-url="/promotions/resultsandfacets?<c:if test="${not empty querString}">${querString}</c:if>${pageToLoadGetParam}" data-action="${action}">
        ${loadMoreCTA}
    </button> 
  </c:when>
  <c:when test="${cmsPage.uid eq 'myPromoProducts' and siteUid ne 'brakes'}">
    <button class="btn btn-secondary js-plpLoadMore product__listing-load-more-btn" data-base-url="/my-promo-products/getPromoProducts<c:if test="${not empty querString}">${querString}</c:if>"
        data-url="/my-promo-products/resultsandfacets?<c:if test="${not empty querString}">${querString}</c:if>${pageToLoadGetParam}" data-action="${action}">
        ${loadMoreCTA}
    </button> 
  </c:when>
  <c:otherwise>
    <button class="btn btn-secondary js-plpLoadMore product__listing-load-more-btn ${customCSSClass}" data-url="${pageToLoadGetUrl}" 
       data-base-url="${searchUrl}?q=${searchPageData.currentQuery.query.value}"  data-action="${action}">
       ${loadMoreCTA}
    </button> 
  </c:otherwise>
</c:choose>



