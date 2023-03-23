
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:if test="${cmsPage.uid eq 'search' || cmsPage.uid eq 'category' || cmsPage.uid eq 'searchGrid'  || cmsPage.uid eq 'productGrid' }">

<c:if test="${not empty searchPageData && not empty searchPageData.pagination }">
    <c:set var="searchUrl" value="${fn:substringBefore(searchPageData.currentQuery.url, '?')}" />
    <c:set var="baseUrl" value="${searchUrl}/results?q=${searchPageData.currentQuery.query.value}&page=" />
    <c:set var="currentPage" value="${searchPageData.pagination.currentPage}"/>
    <c:set var="hasPreviousPage" value="${currentPage > 1}"/>
    <c:set var="hasNextPage" value="${currentPage < searchPageData.pagination.numberOfPages}"/>
    <c:set var="generateUrl" value="https://${header['host']}${baseUrl}" />

    <c:if test="${hasPreviousPage}">
        <link rel="prev" href="${generateUrl}${currentPage - 1}" />
    </c:if>
    <c:if test="${hasNextPage}">
        <link rel="next" href="${generateUrl}${currentPage + 1}" />
    </c:if>
</c:if>
</c:if>