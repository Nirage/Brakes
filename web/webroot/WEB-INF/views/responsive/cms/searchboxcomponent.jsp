<%@ page trimDirectiveWhitespaces="true"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglibprefix="ycommerce" uri="http://hybris.com/tld/ycommercetags"%> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<spring:htmlEscape defaultHtmlEscape="true" />

<c:url value="/search" var="searchUrl" />
<spring:url value="/search/autocomplete/{/componentuid}" var="autocompleteUrl" htmlEscape="false"> 
  <spring:param name="componentuid" value="${component.uid}" />
</spring:url>
<c:if test="${not empty searchPageData}"> 
  <c:set var="searchFreeText" value="${searchPageData.freeTextSearch}" /> 
</c:if>

<div id="v-autocomplete" class="site-search">
  <form name="search_form_${fn:escapeXml(component.uid)}" method="get"
    action="${fn:escapeXml(searchUrl)}">
    <div class="input-group site-search__input-group flex js-site-search__input-group">
      <spring:theme code="search.placeholder" var="searchPlaceholderHtml" />

      <ycommerce:testId code="header_search_input">
        <input type="text" id="js-site-search-input" value="${searchFreeText}"
          class="form-control js-site-search-input site-search__input ga-nav-bar-2"
          name="text"
          maxlength="100"
          autocomplete="off"
          placeholder="${searchPlaceholderHtml}"
          data-autocomplete-url="${fn:escapeXml(autocompleteUrl)}"
          data-min-characters-before-request="${ycommerce:encodeJSON(component.minCharactersBeforeRequest)}"
          data-wait-time-before-request="${ycommerce:encodeJSON(component.waitTimeBeforeRequest)}"
          data-display-product-images="${ycommerce:encodeJSON(component.displayProductImages)}"
        />
      </ycommerce:testId>

      <ycommerce:testId code="header_search_button">
        <button class="btn js_search_button site-search__submit-btn input-group-btn" type="submit" disabled aria-label="${searchPlaceholderHtml}">
          <i class="glyphicon glyphicon-search nav-bar-3" aria-hidden="true"></i>
        </button>
      </ycommerce:testId>
    </div>
  </form>
</div>