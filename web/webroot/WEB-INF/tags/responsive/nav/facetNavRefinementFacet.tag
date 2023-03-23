<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="facetData" required="true" type="de.hybris.platform.commerceservices.search.facetdata.FacetData" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>


<spring:htmlEscape defaultHtmlEscape="true" />

<sec:authorize access="!hasAnyRole('ROLE_ANONYMOUS')">
	<c:set var="isLoggedIn" value="true" />
</sec:authorize>

<c:set var="viewPromotions" value="${not empty currentB2BUnit && currentB2BUnit.viewPromotions ? 'true' : 'false' }" />

<c:if test="${not empty facetData.values}">
	<c:choose>
		<c:when test="${isLoggedIn}">
			<c:choose>
				<c:when test="${facetData.code eq 'promotion' &&  viewPromotions eq false}">
					<c:set var="viewFacet" value="false"/>
				</c:when>
				<c:otherwise>
					<c:set var="viewFacet" value="true"/>
				</c:otherwise>
			</c:choose>
		</c:when>
		<c:otherwise>
			<c:set var="viewFacet" value="true"/>
		</c:otherwise>
	</c:choose>

	<ycommerce:testId code="facetNav_title_${facetData.name}">
		<c:if test="${viewFacet eq true}">
			<div class="facet js-facet" data-facetCode="${facetData.code}">
				<button class="facet__title clearfix js-facetTitle text-left" data-facetCode="${facetData.code}">
					<span class="facet__name js-facet-name">
						<spring:theme code="search.nav.facetTitle" arguments="${facetData.name}"/>
					</span>
					<i class="icon icon--sm icon-chevron-down"></i>
				</button>
				<div class="facet__values js-facet-values js-facet-form hide">
					<%-- End of comment for top values --%>
					<ul class="facet__list js-facet-list <c:if test="${not empty facetData.topValues}">facet__list--hidden js-facet-list-hidden</c:if>">
						<c:if test="${facetData.code eq 'allergens'}">
							<li class="facet__subText"><spring:theme code="allergens.subtext"></spring:theme></li>
						</c:if>

						<c:forEach items="${facetData.values}" var="facetValue">
							<li class="facet__list-item js-facetListItem" data-facet-value="${facetValue.code}">
								<ycommerce:testId code="facetNav_selectForm">
									<form action="#" method="get">
										<%-- facetValue.query.query.value and searchPageData.freeTextSearch are html output encoded in the backend --%>
										<input type="hidden" name="q" value="${facetValue.query.query.value}" data-facet-value=":${facetData.code}:${facetValue.code}"/>
										<input type="hidden" name="text" value="${searchPageData.freeTextSearch}"/>
										<label>
											<input data-facetCode="${facetData.code}" type="checkbox" ${facetValue.selected ? 'checked="checked"' : ''}  class="facet__list__checkbox js-facetCheckbox sr-only" />
											<span class="facet__list__label clearfix">
												<span class="facet__list__mark"></span>
												<span class="facet__list__text">
													<c:choose>
														<c:when test="${facetData.code eq 'spicelevel'}">
															<spring:theme code="search.nav.facetValue.spicelevel.name_${fn:escapeXml(facetValue.name)}" />&nbsp;
														</c:when>
														<c:otherwise>
															${fn:escapeXml(facetValue.name)}&nbsp;
															<input type="hidden" class="jsFacetVal" value="${facetValue.name}"/>
														</c:otherwise>
													</c:choose>
													<ycommerce:testId code="facetNav_count">
														<span class="facet__value__count"><spring:theme code="search.nav.facetValueCount" arguments="${facetValue.count}"/></span>
													</ycommerce:testId>
												</span>
											</span>
										</label>
									</form>
								</ycommerce:testId>
							</li>
						</c:forEach>
					</ul>
				</div>
				<c:if test="${facetData.code eq 'allergens'}">
					<nav:allergensDisclaimer/>
				</c:if>
			</div>
		</c:if>
	</ycommerce:testId>
</c:if>
