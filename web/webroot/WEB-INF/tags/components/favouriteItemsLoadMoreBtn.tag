<%@ tag trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ attribute name="direction" required="true" type="java.lang.String"%>
<%@ attribute name="customCSSClass" required="false" type="java.lang.String"%>
<%@ attribute name="searchPageData" required="true" type="com.envoydigital.brakes.facades.wishlist.data.FavouriteSearchPageData" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="utils" uri="http://brake.co.uk/tld/encrypt" %>

<spring:url value="/my-account/favourites/${ycommerce:encodeUrl(utils:encrypt(searchPageData.favourite.uid))}" var="baseUrl" htmlEscape="false"/>

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

<c:if test="${not empty searchPageData.sorts[0].code}">
  <c:set var="sortQuery" value="&sort=${searchPageData.sorts[0].code}" />
</c:if>

<c:set var="pageToLoadGetUrl" value="${baseUrl}/results?${pageToLoadGetParam}${sortQuery}" />

<button class="btn btn-secondary js-plpLoadMore product__listing-load-more-btn ${customCSSClass}"
        data-url="${pageToLoadGetUrl}"
        data-base-url="${baseUrl}"
        data-sort-by="${sortQuery}"
        data-action="${action}">
    ${loadMoreCTA}
</button>

