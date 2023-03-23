<%@ tag trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components"%>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>

<c:url value="/cart/notLoggedInAddAction" var="notLoggedInAddAction"/>

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
    <c:set var="isLoggedIn" value="true" />
</sec:authorize>
<c:set var="viewPromotions" value="${not empty currentB2BUnit && currentB2BUnit.viewPromotions ? 'true' : 'false' }" />

<script id="facetsTemplate" type="text/x-handlebars-template">
    {{> facetsAppliedFiltersPartial}}
    {{> facetsRefinementPartial}}
 </script>
  
 <script id="facetsAppliedFiltersPartial" type="text/x-handlebars-template">
    {{#if breadcrumbs}}
        <div class="js-facet facet-applied">
            <div class="facet-applied__values js-facet-values">
                <ul class="facet-applied__list js-facetAppliedList">
                    {{#each breadcrumbs}}
                        {{#ifCond @index '<' ../appliedFiltersThreshold}}
                            <li class="facet-applied__item align-items-center js-facetApplied">
                                <a href="{{removeQuery.url}}" 
                                    class="facet-applied__link js-facetAppliedLink flex align-items-center"
                                    data-facet-code="{{facetCode}}"
                                    data-facet-value-code="{{facetValueCode}}"
                                >
                                    <span class="facet-applied__name js-facetAppliedName">
                                        {{#ifCond facetCode '==' 'spicelevel'}}
                                            {{#switch facetValueCode}}
                                                {{#case "1"}}
                                                    <spring:theme code="search.nav.facetValue.spicelevel.name_1" />&nbsp;
                                                {{/case}}
                                                {{#case "2"}}
                                                    <spring:theme code="search.nav.facetValue.spicelevel.name_2" />&nbsp;
                                                {{/case}}
                                                {{#case 3}}
                                                    <spring:theme code="search.nav.facetValue.spicelevel.name_3" />&nbsp;
                                                {{/case}}
                                            {{/switch}}
                                        {{else}}
                                            {{facetValueName}}&nbsp;
                                            <input type="hidden" class="jsFacetVal" value="{{facetValueName}}"/>
                                        {{/ifCond}}
                                    </span>
                                    <i class="icon icon-close bold"></i>
                                </a>
                            </li>
                        {{else}}
                            <li class="facet-applied__item js-facetApplied hide">
                                <input type="hidden" class="jsFacetVal" value="{{facetValueName}}"/>
                                <a href="{{removeQuery.url}}"
                                    class="facet-applied__link js-facetAppliedLink flex align-items-center"
                                    data-facet-code="{{facetCode}}"
                                    data-facet-value-code="{{facetValueCode}}"
                                >
                                    <span class="facet-applied__name js-facetAppliedName">{{facetValueName}}</span>
                                    <i class="icon icon-close bold"></i>
                                </a>
                            </li>
                            {{#ifCond @index '==' ../appliedFiltersThreshold}}
                                <li class="facet-applied__item js-moreAppliedFiltersCount flex align-items-center">
                                    &nbsp;+{{subtract ../breadcrumbs.length ../appliedFiltersThreshold}}&nbsp;
                                </li>
                                <li class="facet-applied__see-more js-facetAppliedSeeMore break">
                                    <span class="facet-applied__see-more-text">
                                        <spring:theme code="search.nav.applied.filters.SeeMore" />
                                    </span>
                                    <i class="icon icon--sm icon-chevron-down"></i>
                                </li>
                            {{/ifCond}}  
                        {{/ifCond}}
                        {{#if @last}}
                            <li class="facet-clear-all js-facetClearAll underline pointer" data-search-term="{{freeTextSearch}}">
                                <spring:theme code="search.nav.facetClearAll" />
                            </li>
                        {{/if}}
                    {{/each}}
                </ul>
            </div>
        </div>
    {{/if}}
 </script>

  <script id="facetsRefinementPartial" type="text/x-handlebars-template">
    {{#each facets}}
        <c:choose>
            <c:when test="${isLoggedIn}">
                {{#ifCond code '==' 'promotion'}}
                    <c:choose>
                        <c:when test="${viewPromotions eq 'false'}">
                            {{var 'viewFacet' 'false'}}
                        </c:when>
                        <c:otherwise>
                            {{var 'viewFacet' 'true'}}
                        </c:otherwise>
                    </c:choose>
                {{else}}                
                    {{var 'viewFacet' 'true'}}
                {{/ifCond}}
            </c:when>
            <c:otherwise>
               {{var 'viewFacet' 'true'}}
            </c:otherwise>
        </c:choose>
         
        {{#ifCond viewFacet '==' 'true'}}
        <div class="facet js-facet">
            <button class="facet__title clearfix js-facetTitle text-left" data-facetCode="{{code}}">
                <span class="facet__name js-facet-name">
                    <spring:theme code="search.nav.facetTitle" arguments="{{name}}"/>
                </span>
			    <span class="icon icon--sm {{#ifCond code '==' 'levelOneCategories'}}icon-chevron-up{{else}}icon-chevron-down{{/ifCond}}"></span>
		    </button>
            <div class="facet__values js-facet-values js-facet-form {{#ifCond code '!==' 'levelOneCategories'}}hide{{/ifCond}}">
                <ul class="facet__list js-facet-list">
                    {{#ifCond code '==' 'allergens'}}
					    <li class="facet__subText"><spring:theme code="allergens.subtext"></spring:theme></li>
                    {{/ifCond}}
                    {{#each values}}
                        <li class="facet__list-item js-facetListItem" data-facet-value="{{code}}">
                            <form action="#" method="get">
                                <input type="hidden" name="q" value="{{query.query.value}}" data-facet-value=":{{../code}}:{{code}}"/>
                                <input type="hidden" name="text" value="{{searchPageData.freeTextSearch}}"/>
                                <label>
                                    <input data-facetCode="{{../code}}" type="checkbox" {{#ifCond selected '==' true}} checked="checked" {{/ifCond}}   class="facet__list__checkbox js-facetCheckbox sr-only" />
                                    <span class="facet__list__label clearfix">
                                        <span class="facet__list__mark"></span>
                                        <span class="facet__list__text">
                                            {{#ifCond ../code '==' 'spicelevel'}}
                                                {{#switch code}}
                                                    {{#case "1"}}
                                                        <spring:theme code="search.nav.facetValue.spicelevel.name_1" />&nbsp;
                                                    {{/case}}
                                                    {{#case "2"}}
                                                        <spring:theme code="search.nav.facetValue.spicelevel.name_2" />&nbsp;
                                                    {{/case}}
                                                    {{#case 3}}
                                                        <spring:theme code="search.nav.facetValue.spicelevel.name_3" />&nbsp;
                                                    {{/case}}
                                                {{/switch}}
                                            {{else}}
                                                {{name}}&nbsp;
                                                <input type="hidden" class="jsFacetVal" value="{{name}}"/>
                                            {{/ifCond}}
                        
                                            <span class="facet__value__count"><spring:theme code="search.nav.facetValueCount" arguments="{{count}}"/></span>
                                        </span>
                                    </span>
                                </label>
                            </form>
                        </li>
                    {{/each}}
                </ul>
            </div>
            {{#ifCond code '==' 'allergens'}}
                <nav:allergensDisclaimer/>
            {{/ifCond}}
        </div>
        {{/ifCond}}
    {{/each}}
 </script>