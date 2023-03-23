<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="pageData" required="true" type="de.hybris.platform.commerceservices.search.facetdata.ProductSearchPageData" %>
<%@ attribute name="filterThreshold" required="false" type="java.lang.String"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:if test="${not empty pageData.breadcrumbs}">
	<c:set var="appliedFiltersThreshold" value="${not empty filterThreshold ? filterThreshold : '3'}" />
	<c:set var="hiddenFiltersCount" value="${fn:length(pageData.breadcrumbs) - appliedFiltersThreshold}" />
	<div class="js-facet facet-applied">
		<div class="facet-applied__values js-facet-values">
			<ul class="facet-applied__list js-facetAppliedList">
				<c:forEach items="${pageData.breadcrumbs}" var="breadcrumb" varStatus="appliedFiltersCounter">
					<c:choose>
						<c:when test="${appliedFiltersCounter.index lt appliedFiltersThreshold}">
							<nav:facetNavAppliedFiltersItem breadcrumb="${breadcrumb}" />
						</c:when>
						<c:otherwise>
							<nav:facetNavAppliedFiltersItem breadcrumb="${breadcrumb}" visibilityClass="hide" />
							<c:if test="${appliedFiltersCounter.index eq appliedFiltersThreshold}">
								<li class="facet-applied__item js-moreAppliedFiltersCount flex align-items-center">
									&nbsp;+${hiddenFiltersCount}&nbsp;
								</li>
								<li class="facet-applied__see-more js-facetAppliedSeeMore break">
									<span class="facet-applied__see-more-text">
										<spring:theme code="search.nav.applied.filters.SeeMore" />
									</span>
									<i class="icon icon--sm icon-chevron-down"></i>
								</li>
							</c:if>
						</c:otherwise>
					</c:choose>
					<c:if test="${appliedFiltersCounter.last}">
						<li class="facet-clear-all js-facetClearAll underline pointer" data-search-term="${searchPageData.freeTextSearch}">
							<spring:theme code="search.nav.facetClearAll" />
						</li>
					</c:if>
				</c:forEach>
			</ul>
		</div>
	</div>
</c:if>