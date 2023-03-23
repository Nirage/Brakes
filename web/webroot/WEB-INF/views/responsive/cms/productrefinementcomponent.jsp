<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<input type="hidden" class="js-facetsInitialData" data-initial-sort="${searchPageData.pagination.sort}" data-query-url="${searchPageData.currentQuery.url}" data-search-term="${fn:escapeXml(searchPageData.freeTextSearch)}">

<div id="facet-overlay" class="facet__overlay animation hide" data-animation-type="slide" data-animation-direction="right">
    <div id="product-facet" class="product__facet js-product-facet">
        <nav:facetNavHeader pageData="${searchPageData}"/>
        <div class="js-facetContent">
            <nav:facetNavAppliedFilters pageData="${searchPageData}"/>
            <nav:facetNavRefinements pageData="${searchPageData}"/>
        </div>

        <button class="btn btn-primary facet__apply js-facetsApply facet--close" disabled>
            <spring:theme code="search.nav.mobile.applyFacets" />
        </button>
    </div>
</div>
<div id="facet-background" class="facet__background facet--close" aria-hidden="true"></div>