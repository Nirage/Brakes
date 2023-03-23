<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="searchUrl" required="true" %>
<%@ attribute name="searchPageData" required="true"
              type="de.hybris.platform.commerceservices.search.pagedata.SearchPageData" %>
<%@ attribute name="msgKey" required="false" %>
<%@ attribute name="numberPagesShown" required="false" type="java.lang.Integer" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:set var="themeMsgKey" value="${not empty msgKey ? msgKey : 'search.page'}"/>

<c:if test="${searchPageData.pagination.totalNumberOfResults >= 1}">
    <c:set var="hasPreviousPage" value="${searchPageData.pagination.currentPage > 1}"/>
    <c:set var="hasNextPage" value="${(searchPageData.pagination.currentPage) < searchPageData.pagination.numberOfPages}"/>

    <c:if test="${(searchPageData.pagination.numberOfPages > 1)}">
        <ul class="bottom-pagination">
            <c:if test="${hasPreviousPage}">
                <li class="bottom-pagination__nav bottom-pagination__nav--prev">
                    <spring:url value="${searchUrl}" var="previousPageUrl" htmlEscape="true">
                        <spring:param name="page" value="${searchPageData.pagination.currentPage - 1}"/>
                    </spring:url>
                    <ycommerce:testId code="searchResults_previousPage_link">
                        <a href="${previousPageUrl}" rel="prev"><span class="icon icon--sm icon-chevron-left"></span></a>
                    </ycommerce:testId>
                </li>
            </c:if>

            <c:if test="${!hasPreviousPage}">
                <li class="bottom-pagination__nav bottom-pagination__nav--prev disabled"><span class="icon icon--sm icon-chevron-left"></span></li>
            </c:if>

            <c:set var="limit" value="${numberPagesShown}"/>
            <c:set var="halfLimit"><fmt:formatNumber value="${limit/2}" maxFractionDigits="0"/></c:set>
            <c:set var="beginPage">
                <c:choose>
                    <%-- Limit is higher than number of pages --%>
                    <c:when test="${limit gt searchPageData.pagination.numberOfPages}">1</c:when>
                    <%-- Start shifting page numbers once currentPage reaches halfway point--%>
                    <c:when test="${searchPageData.pagination.currentPage + halfLimit ge limit}">
                        <c:choose>
                            <c:when test="${searchPageData.pagination.currentPage + halfLimit lt searchPageData.pagination.numberOfPages}">
                                <%-- Avoid rounding issue--%>
                                <c:choose>
                                    <c:when test="${searchPageData.pagination.currentPage - halfLimit gt 0}">
                                        ${searchPageData.pagination.currentPage - halfLimit}
                                    </c:when>
                                    <c:otherwise>1</c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>${searchPageData.pagination.numberOfPages - limit}</c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>1</c:otherwise>
                </c:choose>
            </c:set>
            <c:set var="endPage">
                <c:choose>
                    <c:when test="${limit gt searchPageData.pagination.numberOfPages}">
                        ${searchPageData.pagination.numberOfPages}
                    </c:when>
                    <c:when test="${hasNextPage}">
                        ${beginPage + limit - 1}
                    </c:when>
                    <c:otherwise>
                        ${searchPageData.pagination.numberOfPages}
                    </c:otherwise>
                </c:choose>
            </c:set>
            <c:forEach begin="${beginPage}" end="${endPage}" var="pageNumber">
                <c:set var="linkClass" value=""/>
                <c:choose>
                    <c:when test="${searchPageData.pagination.currentPage ne pageNumber}">
                        <spring:url value="${searchUrl}" var="pageNumberUrl" htmlEscape="true">
                            <spring:param name="page" value="${pageNumber}"/>
                        </spring:url>

                        <c:choose>
                            <c:when test="${ (searchPageData.pagination.currentPage  eq beginPage) or (searchPageData.pagination.currentPage eq endPage) }">
                                <c:if test="${searchPageData.pagination.currentPage  eq beginPage}">
                                    <c:if test="${pageNumber gt searchPageData.pagination.currentPage + 3}">
                                        <c:set var="linkClass" value="hidden-xs"/>
                                    </c:if>
                                </c:if>

                                <c:if test="${searchPageData.pagination.currentPage  eq endPage}">
                                    <c:if test="${pageNumber lt searchPageData.pagination.currentPage - 1}">
                                        <c:set var="linkClass" value="hidden-xs"/>
                                    </c:if>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${pageNumber lt searchPageData.pagination.currentPage}">
                                    <c:set var="linkClass" value="hidden-xs"/>
                                </c:if>

                                <c:if test="${pageNumber gt searchPageData.pagination.currentPage + 2}">
                                    <c:set var="linkClass" value="hidden-xs"/>
                                </c:if>
                            </c:otherwise>
                        </c:choose>

                        <ycommerce:testId code="pageNumber_link">
                            <li class="bottom-pagination__item"><a class="${linkClass}" href="${pageNumberUrl}"></a></li>
                        </ycommerce:testId>
                    </c:when>
                    <c:otherwise>
                        <li class="bottom-pagination__item active"><span><span class="sr-only">(current)</span></span></li>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <c:if test="${hasNextPage}">
                <li class="bottom-pagination__nav bottom-pagination__nav--next">
                    <spring:url value="${searchUrl}" var="nextPageUrl" htmlEscape="true">
                        <spring:param name="page" value="${searchPageData.pagination.currentPage + 1}"/>
                    </spring:url>
                    <ycommerce:testId code="searchResults_nextPage_link">
                        <a href="${nextPageUrl}" rel="next"><span class="icon icon--sm icon-chevron-right"></span></a>
                    </ycommerce:testId>
                </li>
            </c:if>

            <c:if test="${!hasNextPage}">
                <li class="bottom-pagination__nav bottom-pagination__nav--next disabled"><span class="icon icon--sm icon-chevron-right"></span></span></li>
            </c:if>
        </ul>
    </c:if>
</c:if>
    