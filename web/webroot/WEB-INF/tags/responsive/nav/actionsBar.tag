<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="searchUrl" required="true" %>
<%@ attribute name="searchPageData" required="true" type="de.hybris.platform.commerceservices.search.pagedata.SearchPageData" %>
<%@ attribute name="top" required="true" type="java.lang.Boolean" %>
<%@ attribute name="showTopTotals" required="false" type="java.lang.Boolean" %>
<%@ attribute name="supportShowAll" required="true" type="java.lang.Boolean" %>
<%@ attribute name="supportShowPaged" required="true" type="java.lang.Boolean" %>
<%@ attribute name="additionalParams" required="false" type="java.util.HashMap" %>
<%@ attribute name="msgKey" required="false" %>
<%@ attribute name="showCurrentPageInfo" required="false" type="java.lang.Boolean" %>
<%@ attribute name="hideRefineButton" required="false" type="java.lang.Boolean" %>
<%@ attribute name="numberPagesShown" required="false" type="java.lang.Integer" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>

<spring:htmlEscape defaultHtmlEscape="false" />

<c:set var="themeMsgKey" value="${not empty msgKey ? msgKey : 'search.page'}"/>
<c:set var="showCurrPage" value="${not empty showCurrentPageInfo ? showCurrentPageInfo : false}"/>
<c:set var="showTotals" value="${empty showTopTotals ? true : showTopTotals}"/>

<c:if test="${searchPageData.pagination.totalNumberOfResults == 0 && top && showTotals}">
  <div class="paginationBar top clearfix">
    <ycommerce:testId code="searchResults_productsFound_label">
      <div class="totalResults">
        <spring:theme code="${themeMsgKey}.totalResults" arguments="${searchPageData.pagination.totalNumberOfResults}"/>
      </div>
    </ycommerce:testId>
  </div>
</c:if>

<div class="page-actions-bar page-actions flex">
  <c:if test="${showTotals}">
    <div class="showing-entries mrauto flex align-items-center font-size-1">
      <nav:totalResults  searchUrl="${searchUrl}" searchPageData="${searchPageData}" />
    </div>
  </c:if>

  <cms:pageSlot position="AdditionalCategories" var="feature" element="div" class="categories-dropdown hidden-xs">
    <cms:component component="${feature}"/>
  </cms:pageSlot>

  <c:if test="${searchPageData.pagination.totalNumberOfResults > 0}">
    <c:if test="${not empty searchPageData.sorts}">
      <%-- Sort dropdown --%>
      <nav:sortByForm top="false" searchUrl="${searchUrl}" searchPageData="${searchPageData}" customCSSClass="page-actions__sort form-inline site-form--inline ml1"/>

      <%-- Filter dropdown --%>
      <button id="facet-filter" class="site-form__dropdown page-actions__filter form-control js-showFacets ml1">
        <i class="glyphicon glyphicon-filter"></i>
        <spring:theme code="search.page.filter" />&nbsp;
        <span class="js-facet-appled-size"><c:if test="${searchPageData.breadcrumbs.size() > 0}">(${searchPageData.breadcrumbs.size()})</c:if></span>
      </button>
    </c:if>
  </c:if>
</div>