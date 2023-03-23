<%@ tag trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%@ attribute name="direction" required="true" type="java.lang.String"%>
<%@ attribute name="customCSSClass" required="false" type="java.lang.String"%>
<%@ attribute name="dataUrl" required="true" type="java.lang.String"%>
<%@ attribute name="dataBaseUrl" required="true" type="java.lang.String"%>
<%@ attribute name="searchPageData" required="true" type="de.hybris.platform.commerceservices.search.pagedata.SearchPageData" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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

<c:set var="pageToLoadGetUrl" value="${dataUrl}?q=${searchPageData.currentQuery.query.value}&${pageToLoadGetParam}" />

<button class="btn btn-secondary js-plpLoadMore product__listing-load-more-btn ${customCSSClass}" data-url="${pageToLoadGetUrl}" 
data-base-url="${dataBaseUrl}?q=${searchPageData.currentQuery.query.value}"  data-action="${action}">
    ${loadMoreCTA}
</button>

