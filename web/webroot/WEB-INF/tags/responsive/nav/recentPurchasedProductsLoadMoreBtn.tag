<%@ tag trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ attribute name="direction" required="true" type="java.lang.String"%>
<%@ attribute name="customCSSClass" required="false" type="java.lang.String"%>
<%@ attribute name="searchPageData" required="true" type="de.hybris.platform.core.servicelayer.data.SearchPageData" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<spring:url value="/my-account/recent-purchased-products" var="baseUrl" htmlEscape="false"/>
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

<c:set var="weeksInPast" value="&weeksInPast=${currentWeeksInPast}"/>
<c:set var="pageToLoadGetUrl" value="${baseUrl}/results?${pageToLoadGetParam}${weeksInPast}" />

<button class="btn btn-secondary js-plpLoadMore product__listing-load-more-btn ${customCSSClass}"
        data-url="${pageToLoadGetUrl}"
        data-base-url="${baseUrl}"
        data-action="${action}"
        data-sort-by="${weeksInPast}">
    ${loadMoreCTA}
</button>

