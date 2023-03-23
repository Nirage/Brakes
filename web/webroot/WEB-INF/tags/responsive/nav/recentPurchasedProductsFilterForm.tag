<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="searchPageData" required="true" type="java.lang.Object" %>
<%@ attribute name="desktop" required="true" type="java.lang.Boolean" %>
<%@ attribute name="showTopTotals" required="false" type="java.lang.Boolean" %>
<%@ attribute name="supportShowAll" required="false" type="java.lang.Boolean" %>
<%@ attribute name="supportShowPaged" required="false" type="java.lang.Boolean" %>
<%@ attribute name="additionalParams" required="false" type="java.util.HashMap" %>
<%@ attribute name="msgKey" required="false" %>
<%@ attribute name="showCurrentPageInfo" required="false" type="java.lang.Boolean" %>
<%@ attribute name="hideRefineButton" required="false" type="java.lang.Boolean" %>
<%@ attribute name="customCSSClass" required="false" type="java.lang.String"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="page-actions-bar page-actions-bar--recent-purchased page-actions mb1 flex justify-content-flex-end justify-content-center-mob">
    <%-- Please note, the suffix here will be always '1' as we already checked that is desktop, however we are leaving it as expression as it might be useful in the case we are going to improve the code by merging desktop and mobile view (this is part of the tech debt that we are going to discuss on December 2021). --%>
    <form id="sortForm${desktop ? '1' : '2'}" name="sortForm${desktop ? '1' : '2'}"  name="sortForm${desktop ? '1' : '2'}" class="site-form form-inline site-form--inline flex flex-wrap" method="get" action="#">
        <div class="page-actions__dropdown site-form__formgroup form-group">
            <div class="control site-form__dropdown">
                <label class="" for="sortForm${desktop ? '1' : '2'}">
                    <select id="filterOption" name="filterOption" class="form-control site-form__select">
                        <c:forEach items="${filterOptions}" var="filterOption" varStatus="varStatus" >
                            <option value="${filterOption.code}" ${filterOption.code eq selectedFilterOption ? 'selected="selected"' : ''}>
                                ${filterOption.name}
                            </option>
                        </c:forEach>
                    </select>
                </label>
            </div>
        </div>
        <div class="page-actions__dropdown flex align-items-center">
            <div class="site-form__label ml1">
                <spring:theme code="text.account.recentpurchases.filter.title"/>
            </div>
            <div class="site-form__formgroup form-group">
                <div class="control site-form__dropdown">
                    <label class="" for="sortForm${desktop ? '1' : '2'}">
                        <select id="weeksInPast" name="weeksInPast" class="form-control site-form__select">
                            <c:forEach items="${sorts}" var="weekFilter" varStatus="varStatus" >
                                <option value="${weekFilter.code}" ${weekFilter.code eq currentWeeksInPast ? 'selected="selected"' : ''}>
                                    <c:choose>
                                        <c:when test="${weekFilter.code eq '1'}">
                                            <spring:theme code="text.account.recentpurchases.filter.oneweek"/>
                                        </c:when>
                                        <c:otherwise>
                                            <spring:theme code="text.account.recentpurchases.filter.multweeks" arguments="${weekFilter.code}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </option>
                            </c:forEach>
                        </select>
                    </label>
                </div>
            </div>
        </div>

        <c:catch var="errorException">
            <spring:eval expression="searchPageData.currentQuery.query"
            var="dummyVar"/><%-- This will throw an exception is it is not supported --%>
            <!-- searchPageData.currentQuery.query.value is html output encoded in the backend -->
            <input type="hidden" name="q" value="${searchPageData.currentQuery.query.value}"/>
        </c:catch>
        <c:if test="${not empty additionalParams}">
            <c:forEach items="${additionalParams}" var="entry">
                <input type="hidden" name="${fn:escapeXml(entry.key)}" value="${fn:escapeXml(entry.value)}"/>
            </c:forEach>
        </c:if>
    </form>

    <%-- Filter dropdown --%>
    <button id="facet-filter" class="page-actions__dropdown site-form__dropdown page-actions__filter form-control js-showFacets ml1">
        <i class="glyphicon glyphicon-filter"></i>
        <spring:theme code="search.page.filter" />&nbsp;
        <span class="js-facet-appled-size"><c:if test="${searchPageData.breadcrumbs.size() > 0}">(${searchPageData.breadcrumbs.size()})</c:if></span>
    </button>
</div>