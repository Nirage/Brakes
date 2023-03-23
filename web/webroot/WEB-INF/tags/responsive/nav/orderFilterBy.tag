<%@ tag body-content="empty" trimDirectiveWhitespaces="true" %>
<%@ attribute name="msgKey" required="false" %>
<%@ attribute name="customCSSClass" required="false" type="java.lang.String"%>
<%@ attribute name="mobile" required="false" type="java.lang.String"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="ycommerce" uri="http://hybris.com/tld/ycommercetags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="themeMsgKey" value="${not empty msgKey ? msgKey : 'search.page'}"/>
<c:set var="selectedFiltersCounter" value="0" />

<c:forEach items="${orderStatuFilters}" var="orderStatus">
  <c:if test="${fn:escapeXml(orderStatus.key) ne 'QUEUED' && fn:escapeXml(orderStatus.value) eq 'true'}">
    <c:set var="selectedFiltersCounter" value="${selectedFiltersCounter + 1}"/>
  </c:if>
</c:forEach>

<div class="order-filter">
  <div class="order-filter__label">
    <spring:theme code="${themeMsgKey}.filterTitle"  />
  </div>
  <div class="order-filter__actions">
    <button class="btn btn-secondary btn--full-width order-filter__btn js-orderFilterBtn">
      <span><spring:theme code="${themeMsgKey}.selectedFiltersCount" arguments="${selectedFiltersCounter}"/></span>
      <span class="icon icon-chevron-down"></span>
    </button>
  
    <div class="order-filter__content order-filter-content hide js-orderFilterContent">
      <div class="order-filter-content__header js-orderFilterContentHide">
        <span>
          <spring:theme code="${themeMsgKey}.selectedFiltersCount" arguments="${selectedFiltersCounter}"/>
        </span>
        <span class="icon icon-chevron-up"></span>
      </div>
      <c:forEach items="${orderStatuFilters}" var="orderStatus">
        <c:choose>
					<c:when test="${orderStatus.key == 'QUEUED' }">
						<input class="js-queued" type="checkbox" name="status" value="${orderStatus.key}" ${orderStatus.value? 'checked="checked"':'' } hidden="true"/>
					</c:when>
          <c:otherwise>
            <div class="order-filter-content__item custom-form-element">
              <input id="${orderStatus.key}${mobile ? '-mobile':''}" type="checkbox" name="status" value="${orderStatus.key}" ${orderStatus.value? 'checked="checked"':'' } class="js-orderFilterByCheckbox">
              <label for="${orderStatus.key}${mobile ? '-mobile':''}">
                <spring:theme code="${themeMsgKey}.${orderStatus.key}"/>
              </label>
            </div>
          </c:otherwise>
				</c:choose>
      </c:forEach>
    </div>
  </div>
</div>