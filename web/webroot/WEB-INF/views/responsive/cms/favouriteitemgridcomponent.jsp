<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="favourite" tagdir="/WEB-INF/tags/responsive/favourite" %>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components" %>
<%@ taglib prefix="favourites" tagdir="/WEB-INF/tags/responsive/favourites" %>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart" %>
<%@ taglib prefix="analytics" tagdir="/WEB-INF/tags/shared/analytics" %>
<%@ taglib prefix="cms" uri="http://hybris.com/tld/cmstags"%>

<spring:htmlEscape defaultHtmlEscape="true" />
<c:set var="numberOfLoadedProducts" value="${fn:length(favouriteItemPageData.results)}" />
<input type="hidden" class="js-initialNumberOfLoadedProducts" value="${numberOfLoadedProducts}">
<c:set var="hasPreviousPage" value="${favouriteItemPageData.pagination.currentPage > 1}"/>
<c:set var="hasNextPage" value="${favouriteItemPageData.pagination.currentPage < favouriteItemPageData.pagination.numberOfPages}"/>

<analytics:googleAnalyticsProducts productListing="${favouriteItemPageData.results}"/>

<c:choose>
    <c:when test="${numberOfLoadedProducts > 0}">

        <div class="page-actions page-actions--simple page-actions--favourites">
          <div class="row">
            <div class="col-xs-12 col-sm-4">
                <favourite:quickAddFavouriteItem favourite="${favouriteItemPageData.favourite}" styleClass="quick-add--desktop"/>
            </div>
            <div class="col-xs-12 col-sm-8 flex justify-content-flex-end align-items-right">
              <div class="sort-by sort-by--listing-page sort-by--label-left-xs full-width-mobile">
                <nav:favouriteItemsSortByForm top="false" searchPageData="${favouriteItemPageData}" customCSSClass="form-inline site-form--inline site-form--favorites"/>
              </div>
            </div>
          </div>
        </div>


        <c:if test="${hasPreviousPage}">
            <components:favouriteItemsLoadMoreBtn direction="previous" searchPageData="${favouriteItemPageData}" customCSSClass="h-space-2 js-loadPreviousFavourites"/>
        </c:if>

        <div id="jsFavouritesListDetails" class="product__listing product__listing--favourites product__grid js-plpGrid js-favouritesListDetails">
            <c:forEach items="${favouriteItemPageData.results}" var="favouriteEntry" varStatus="status">
                <product:productListerGridItem product="${favouriteEntry.product}" favourite="${favouriteItemPageData.favourite}" />
            </c:forEach>
        </div>
        <c:if test="${hasNextPage}">
            <components:favouriteItemsLoadMoreBtn direction="next" searchPageData="${favouriteItemPageData}" customCSSClass="h-space-4 js-loadNextFavourites"/>
            <!-- VAT  -->
            <c:set var="VAT" value="false" />
            <c:forEach items="${favouriteItemPageData.results}" var="favouriteEntry" varStatus="status">
                <c:if test="${(favouriteEntry.product.subjectToVAT) && (VAT eq false)}">
                    <c:set var="VAT" value="true" />
                    <div class="vat__text-box h-space-1">
                        <spring:theme code="product.vat.applicable"/>
                    </div>
                </c:if>
            </c:forEach>
        </c:if>
    <nav:plpHandlebarsTemplates />
    </c:when>
    <c:otherwise>
        <div class="page-content page-content--border-top">
            <div class="page-content__desc">
                <spring:theme code="favouriteitems.page.no.items.text" htmlEscape="false"/>
            </div>
            <div class="row">
                <div class="col-xs-12 col-sm-4">
                <favourite:quickAddFavouriteItem favourite="${favouriteItemPageData.favourite}" styleClass="quick-add--desktop h-topspace-4 "/>
                </div>
            </div>
        </div>
    </c:otherwise>

</c:choose>
<c:if test="${numberOfLoadedProducts > 0}">
<favourites:favouritesPrintHandlebarsTemplates />
</c:if>
<nav:similarProductsHandlebarsTemplate />
<cart:quickAddModals />
<cart:cartProductUnavailable />