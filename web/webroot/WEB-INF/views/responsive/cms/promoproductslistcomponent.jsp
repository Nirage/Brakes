<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product" %>
<%@ taglib prefix="nav" tagdir="/WEB-INF/tags/responsive/nav" %>
<%@ taglib prefix="storepickup" tagdir="/WEB-INF/tags/responsive/storepickup" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="components" tagdir="/WEB-INF/tags/components" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:set var="numberOfLoadedProducts" value="${fn:length(searchPageData.results)}" />
<c:set var="numberOfVisibleProducts" value="${promoSearchPageSize}" />
<c:set var="numberOfLoadMoreProducts" value="${promoSearchPageSize}" />
<input type="hidden" class="js-loadedMoreProductsCount" value="${numberOfLoadMoreProducts}">
<input type="hidden" class="js-initialNumberOfLoadedProducts" value="${numberOfVisibleProducts}"> 

<c:set var="hasNextPage" value="${searchPageData.pagination.numberOfPages > searchPageData.pagination.currentPage }"/>
<c:set var="hasPreviousPage" value="${searchPageData.pagination.currentPage > 1}"/>

<c:set var="showVatApplicable" value="false"/>
<c:choose>
  <c:when test="${numberOfLoadedProducts > 0}">
  <c:if test="${hasPreviousPage}">
        <components:loadMoreBtn direction="previous" searchPageData="${searchPageData}" customCSSClass="mtb1"/>
    </c:if>
    <div class="product__listing product__list js-promoProductsList js-plpGrid">
      <c:forEach items="${searchPageData.results}" var="product" varStatus="status">
          <product:productListerGridItem product="${product}" customCSSClass="${status.index >= numberOfVisibleProducts ? 'hide': ''}"/>
          <c:if test="${product.subjectToVAT eq true}">
              <c:set var="showVatApplicable" value="true"/>
          </c:if>
      </c:forEach>
    </div>

    <c:if test="${hasNextPage}">
        <components:loadMoreBtn direction="next" searchPageData="${searchPageData}" customCSSClass="h-space-4"/>
	  </c:if>

	<c:if test="${showVatApplicable eq true}">
        <div class="row">
            <div class="vat__text-box h-space-1">
                <span class="glyphicon glyphicon-asterisk product-price__asterisk-icon vat__color"></span>
                <spring:theme code="product.vat.applicable"/>
            </div>
        </div>
    </c:if>

    <nav:plpHandlebarsTemplates />
<nav:similarProductsHandlebarsTemplate/>

  </c:when>
  <c:otherwise>
    <div class="page-content page-content--border-top">
      <div class="page-content__desc">
        <spring:theme code="promoPage.noresults" htmlEscape="false"/>
      </div>
    </div>
  </c:otherwise>

</c:choose>
