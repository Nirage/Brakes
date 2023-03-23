<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="searchUrl" required="true" type="java.lang.Object" %>
<%@ attribute name="searchPageData" required="true" type="java.lang.Object" %>

<%@ attribute name="msgKey" required="false" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ attribute name="customCSSClass" required="false" type="java.lang.String"%>

<c:set var="numberOfLoadedProducts" value="${fn:length(searchPageData.results)}" />

<c:set var="themeMsgKey" value="${not empty msgKey ? msgKey : 'search.page'}" />


<ycommerce:testId code="searchResults_productsFound_label">
  <c:choose>
    <c:when test="${showCurrPage}">
      <c:choose>
        <c:when test="${searchPageData.pagination.totalNumberOfResults == 1}">
          <spring:theme code="${themeMsgKey}.totalResultsSingleOrder"/>
        </c:when>
        <c:when test="${searchPageData.pagination.numberOfPages <= 1}">
          <spring:theme code="${themeMsgKey}.totalResultsSinglePag" arguments="${searchPageData.pagination.totalNumberOfResults}"/>
        </c:when>
        <c:otherwise>
          <c:set var="currentPageItems" value="${(searchPageData.pagination.currentPage + 1) * searchPageData.pagination.pageSize}"/>
          <c:set var="upTo" value="${(currentPageItems > searchPageData.pagination.totalNumberOfResults ? searchPageData.pagination.totalNumberOfResults : currentPageItems)}"/>
          <c:set var="currentPage" value="${searchPageData.pagination.currentPage * searchPageData.pagination.pageSize + 1} - ${upTo}"/>
          <spring:theme code="${themeMsgKey}.totalResultsCurrPage" arguments="${currentPage},${searchPageData.pagination.totalNumberOfResults}"/>
        </c:otherwise>
      </c:choose>
    </c:when>
    <c:otherwise>
      <span class="entries-counter"><spring:theme code="${themeMsgKey}.showingResults" arguments="${numberOfLoadedProducts}, ${searchPageData.pagination.totalNumberOfResults}"/></span>
    </c:otherwise>
  </c:choose>
</ycommerce:testId>