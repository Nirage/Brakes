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

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>

<spring:htmlEscape defaultHtmlEscape="false" />

<c:set var="themeMsgKey" value="${not empty msgKey ? msgKey : 'search.page'}"/>
<c:set var="showCurrPage" value="${not empty showCurrentPageInfo ? showCurrentPageInfo : false}"/>
<c:set var="showTotals" value="${empty showTopTotals ? true : showTopTotals}"/>

<form id="orderHistoryFormDesktop" name="orderHistoryFormMobile" method="get" action="">
  <div class="page-actions-bar page-actions mb1 flex">
    <c:if test="${showTotals}">
      <div class="showing-entries mrauto flex align-items-center font-size-1">
        <nav:totalResults  searchUrl="${searchUrl}" searchPageData="${searchPageData}" />
      </div>
    </c:if>

    <%-- Sort dropdown --%>
    <c:if test="${not empty searchPageData.sorts}">
      <nav:orderSortBy top="false" msgKey="text.account.orderHistory.page" searchUrl="${searchUrl}" searchPageData="${searchPageData}" customCSSClass="page-actions__sort form-inline site-form--inline ml1 text-center"/>
    </c:if>
    
    <%-- Filter dropdown --%>
    <c:if test="${not empty orderStatuFilters}">
        <nav:orderFilterBy msgKey="text.account.orderHistory.page" />
    </c:if>
  </div>
</form>