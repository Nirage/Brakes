<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="breadcrumb" required="true" type="de.hybris.platform.commerceservices.search.facetdata.BreadcrumbData" %>
<%@ attribute name="visibilityClass" required="false" type="java.lang.String" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<li class="facet-applied__item align-items-center js-facetApplied ${visibilityClass}">
    <c:url value="${breadcrumb.removeQuery.url}" var="removeQueryUrl"/>
    <a href="${fn:escapeXml(removeQueryUrl)}"
      class="facet-applied__link js-facetAppliedLink flex align-items-center"
      data-facet-code="${breadcrumb.facetCode}"
      data-facet-value-code="${breadcrumb.facetValueCode}"
    >
      <span class="facet-applied__name js-facetAppliedName">
        <c:choose>
          <c:when test="${fn:containsIgnoreCase(breadcrumb.facetCode, 'spicelevel')}">
            <spring:theme code="search.nav.facetValue.spicelevel.name_${fn:escapeXml(breadcrumb.facetValueCode)}" />&nbsp;
          </c:when>
          <c:otherwise>
            ${fn:escapeXml(breadcrumb.facetValueName)}&nbsp;
            <input type="hidden" class="jsFacetVal" value="${breadcrumb.facetValueName}"/>
          </c:otherwise>
        </c:choose>
      </span>
      <i class="icon icon-close bold"></i>
    </a>
</li>