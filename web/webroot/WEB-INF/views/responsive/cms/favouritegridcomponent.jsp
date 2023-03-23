<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>
<%@ taglib prefix="favourite" tagdir="/WEB-INF/tags/responsive/favourite" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:set var="numberOfLoadedFavourites" value="${fn:length(favouritesPageData.results)}" />
<input type="hidden" class="js-initialNumberOfLoadedFavourites" value="${numberOfLoadedFavourites}">
<c:set var="hasFavouritesPreviousPage" value="${favouritesPageData.pagination.currentPage > 1}"/>
<c:set var="hasFavouritesNextPage" value="${favouritesPageData.pagination.currentPage < favouritesPageData.pagination.numberOfPages}"/>

<c:choose>
    <c:when test="${component.componentType == 'SHARED'}">
        <c:set var="favouritesHeaderText">

        <spring:theme code="text.account.favourites.shared"/></c:set>
    </c:when>
    <c:otherwise>
        <c:set var="displayButton" value="true" />
        <c:set var="displayHeader" value="true" />
        <c:set var="favouritesHeaderText">
        <spring:theme code="text.account.favourites.my"/></c:set>
    </c:otherwise>
</c:choose>

<c:choose>
    <c:when test="${numberOfLoadedFavourites > 0}">
        <c:if test="${displayHeader}">
            <div class="site-header site-header--align-left">
                <h1 class="site-header__text site-header--align-left "><spring:theme code="wishlist.page.heading" /></h1>
            </div>
        </c:if>
        <div class="row">
            <div class="col-xs-12 col-sm-7 h-space-1">
                <h2 class="site-header site-header--align-left h-nounderline m-0">
                    <c:out value="${favouritesHeaderText}"/>
                </h2>
            </div>
            <c:if test="${displayButton}">
                <div class="col-xs-12 col-sm-5">
                    <button type="button" class="btn btn-secondary pull-right btn--mobile-full-width btn--text-center js-createNewWishlistBtn" data-toggle="modal" data-target="#createWishlistModal" disabled="disabled">
                        <span class="btn-content">
                        <span class="btn-create__icon"></span>
                        <span class="btn-create__text"><spring:theme code="wishlist.create.new" /></span>
                        </span>
                    </button>
                </div>
            </c:if>
        </div>

        <div class="favourites-list product__listing row m0 mb2 ${component.componentType != 'SHARED' ? 'js-favouritesList' : ''}">
            <c:forEach items="${favouritesPageData.results}" var="favourite" varStatus="status">
                <favourite:favouriteListerGridItem favourite="${favourite}" />
            </c:forEach>
        </div>
    </c:when>
    <c:otherwise>
        <c:if test="${component.componentType != 'SHARED'}">
            <div class="row">
                <div class="col-xs-12">
                    <div class="site-header">
                        <h1 class="site-header__text text-center"><c:out value="${favouritesHeaderText}"/></h1>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-12">
                    <form:form id="createNewFavouriteForm" action="/favourites/createNew" method="post" class="favourites-page__new-favourites-form js-createNewFavouriteForm">
                        <ycommerce:testId code="createNewFavouriteButton">
                            <span class="favourites-page__empty-msg align-center"><spring:theme code="text.account.favourites.empty"/></span>
                            <button type="button" class="btn btn-primary btn-block btn--mobile-full-width btn--text-center center-block" data-toggle="modal" data-target="#createWishlistModal" data-action="create">
                                <span class="btn-content">
                                    <span class="btn-create__icon"></span>
                                    <span class="btn-create__text"><spring:theme code="text.account.favourites.create"/></span>
                                </span>
                            </button>
                        </ycommerce:testId>
                    </form:form>
                </div>
            </div>
        </c:if>
    </c:otherwise>
</c:choose>