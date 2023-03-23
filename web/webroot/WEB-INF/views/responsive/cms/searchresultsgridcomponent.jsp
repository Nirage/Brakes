<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components" %>
<%@ taglib prefix="favourites" tagdir="/WEB-INF/tags/responsive/favourites" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
    <c:set var="isLoggedIn" value="true" />
</sec:authorize>

<spring:htmlEscape defaultHtmlEscape="true" />
<c:set var="numberOfLoadedProducts" value="${fn:length(searchPageData.results)}" />
<c:set var="hasPreviousPage" value="${searchPageData.pagination.currentPage > 1}"/>
<c:set var="hasNextPage" value="${searchPageData.pagination.currentPage < searchPageData.pagination.numberOfPages}"/>
<input type="hidden" class="js-initialNumberOfLoadedProducts" value="${numberOfLoadedProducts}">

<nav:actionsBar
    top="true"
    supportShowPaged="${isShowPageAllowed}"
    supportShowAll="${isShowAllAllowed}"
    searchPageData="${searchPageData}"
    searchUrl="${searchPageData.currentQuery.url}"
    numberPagesShown="${numberPagesShown}"
/>
<div id="applied-filters">
    <nav:facetNavAppliedFilters pageData="${searchPageData}" filterThreshold="6"/>
</div>

<c:if test="${hasPreviousPage}">
    <components:loadMoreBtn direction="previous" searchPageData="${searchPageData}" customCSSClass="mtb1"/>
</c:if>

<%-- Product List from IS --%>
<c:if test="${isLoggedIn and showISComponent}">
    <product:productListerItemIS />
</c:if>

<div class="product__listing product__grid js-plpGrid">
    <c:forEach items="${searchPageData.results}" var="product" varStatus="status">
        <product:productListerGridItem product="${product}"/>
    </c:forEach>
</div>

<c:if test="${hasNextPage}">
    <components:loadMoreBtn direction="next" searchPageData="${searchPageData}" customCSSClass="h-space-4"/>
</c:if>
<!-- VAT start -->
<c:set var="VAT" value="false"/>
<c:forEach items="${searchPageData.results}" var="product" varStatus="status">
    <c:if test="${product.subjectToVAT && VAT eq false}" >
        <c:set var="VAT" value="true"/>
        <div class="vat__text-box h-space-1">
            <span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color "></span>
            <spring:theme code="product.vat.applicable"/>
        </div>
    </c:if>
</c:forEach>
<!-- VAT end -->
<div class="js_spinner spinning-div">
    <img class="spinning-image" src="${themeResourcePath}/images/Spinner-1s-75px.gif" alt="Loading..." />
</div>

<div id="addToCartTitle" class="display-none">
    <div class="add-to-cart-header">
        <div class="headline">
            <span class="headline-text"><spring:theme code="basket.added.to.basket"/></span>
        </div>
    </div>
</div>

<nav:similarProductsHandlebarsTemplate/>
<nav:plpHandlebarsTemplates />
<nav:facetsHandlebarsTemplates/>
<favourites:newFavouritiesList/>
<cart:quickAddModals />
<cart:cartProductUnavailable />