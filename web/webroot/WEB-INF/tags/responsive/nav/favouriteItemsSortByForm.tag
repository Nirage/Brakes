<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="searchPageData" required="true" type="java.lang.Object" %>
<%@ attribute name="top" required="true" type="java.lang.Boolean" %>
<%@ attribute name="showTopTotals" required="false" type="java.lang.Boolean" %>
<%@ attribute name="supportShowAll" required="false" type="java.lang.Boolean" %>
<%@ attribute name="supportShowPaged" required="false" type="java.lang.Boolean" %>
<%@ attribute name="additionalParams" required="false" type="java.util.HashMap" %>
<%@ attribute name="msgKey" required="false" %>
<%@ attribute name="showCurrentPageInfo" required="false" type="java.lang.Boolean" %>
<%@ attribute name="hideRefineButton" required="false" type="java.lang.Boolean" %>
<%@ attribute name="customCSSClass" required="false" type="java.lang.String"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="themeMsgKey" value="${not empty msgKey ? msgKey : 'favouriteitems.page'}"/>

<form id="sortForm${top ? '1' : '2'}" name="sortForm${top ? '1' : '2'}" class="site-form ${customCSSClass}" method="get" action="#">
  <div class="site-form__label">
    <spring:theme code="${themeMsgKey}.sortTitle"/>
  </div>
  <div class="site-form__formgroup form-group">
    <div class="control site-form__dropdown">
      <label class="" for="sortForm${top ? '1' : '2'}">
        <select id="sortOptions${top ? '1' : '2'}" name="sort" class="form-control site-form__select">
          <c:forEach items="${searchPageData.availableSorts}" var="sort">
            <option value="${fn:escapeXml(sort.code)}" ${searchPageData.sorts[0].code == sort.code ? 'selected="selected"' : ''}>
               <spring:theme code="${themeMsgKey}.sort.${sort.code}"/>
            </option>
          </c:forEach>
        </select>
      </label>
    </div>
  </div>
  <c:if test="${supportShowAll}">
    <ycommerce:testId code="searchResults_showAll_link">
      <input type="hidden" name="show" value="Page"/>
    </ycommerce:testId>
  </c:if>
  <c:if test="${supportShowPaged}">
    <ycommerce:testId code="searchResults_showPage_link">
      <input type="hidden" name="show" value="All"/>
    </ycommerce:testId>
  </c:if>
  <c:if test="${not empty additionalParams}">
    <c:forEach items="${additionalParams}" var="entry">
      <input type="hidden" name="${fn:escapeXml(entry.key)}" value="${fn:escapeXml(entry.value)}"/>
    </c:forEach>
  </c:if>
            
</form>