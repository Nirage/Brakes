<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="format" tagdir="/WEB-INF/tags/shared/format"%>
<%@ taglib prefix="product" tagdir="/WEB-INF/tags/responsive/product"%>
<%@ taglib prefix="component" tagdir="/WEB-INF/tags/shared/component"%>
<%@ taglib prefix="cart" tagdir="/WEB-INF/tags/responsive/cart"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<spring:htmlEscape defaultHtmlEscape="true" />

<div class="suggestions">
  <h2 class="suggestions__header">
    ${fn:escapeXml(component.title)}
	</h2>
  <div class="suggestions__list h-space-4">
    <c:forEach end="${component.maximumNumberProducts}" items="${suggestions}" var="suggestion" varStatus="loop">
      <c:if test="${loop.last}">
        <c:set var="customClass" value="suggestion--last" />
      </c:if>
      <c:choose>
        <c:when test="${loop.count le 2}">
          <cart:productSuggestion suggestion="${suggestion}" customClass="${customClass}"/>
        </c:when>
        <c:otherwise>
          <c:if test="${loop.count eq 3}">
            <div class="js-suggestionsMoreProducts hide">
            <c:set var="loadMoreBtn">
              <button class="btn btn-secondary btn--full-width h-space-2 js-suggestionsLoadMore">
                <spring:theme code="basket.page.suggestions.load.more" />
              </button>
            </c:set>
          </c:if>
          <cart:productSuggestion suggestion="${suggestion}" customClass="${customClass}"/>
          <c:if test="${loop.last}">
            </div>
            ${loadMoreBtn}
          </c:if>
        </c:otherwise>
      </c:choose>
    </c:forEach>
  </div>
</div>