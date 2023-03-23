<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>


<spring:htmlEscape defaultHtmlEscape="true" />
<c:set var="numberOfLoadedProducts" value="${fn:length(searchPageData.results)}" />

<input type="hidden" class="js-initialNumberOfLoadedProducts" value="${numberOfLoadedProducts}">
<c:set var="hasPreviousPage" value="${recentPurchasedSearchPageData.pagination.currentPage > 1}"/>
<c:set var="hasNextPage" value="${recentPurchasedSearchPageData.pagination.currentPage < recentPurchasedSearchPageData.pagination.numberOfPages}"/>

<div class="product-grid-right-result-slot">
    <c:choose>
        <c:when test="${numberOfLoadedProducts > 0}">
            <c:if test="${hasPreviousPage}">
                <nav:recentPurchasedProductsLoadMoreBtn direction="previous" searchPageData="${searchPageData}" customCSSClass="h-space-2"/>
            </c:if>
            <div id="jsRecentPurchasedProducts" class="product__listing product__grid js-plpGrid js-recentPurchasedProducts">
                <c:forEach items="${searchPageData.results}" var="productData" varStatus="status">
                    <product:productListerGridItem product="${productData}" />
                </c:forEach>
            </div>

            <c:if test="${hasNextPage}">
                <nav:recentPurchasedProductsLoadMoreBtn direction="next" searchPageData="${searchPageData}" customCSSClass="h-space-4"/>
            </c:if>

            <nav:plpHandlebarsTemplates />
            <nav:similarProductsHandlebarsTemplate/>

            <div class="js_spinner spinning-div">
                <img class="spinning-image" src="${themeResourcePath}/images/Spinner-1s-75px.gif" alt="Loading..." />
            </div>
            <cart:quantityCartModals/>

        </c:when>
        <c:otherwise>
            <div class="page-content page-content--border-top">
                <div class="page-content__desc">
                    <spring:theme code="text.account.recentpurchases.noresults" htmlEscape="false"/>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>