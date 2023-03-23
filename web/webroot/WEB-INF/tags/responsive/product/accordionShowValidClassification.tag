
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="classification" required="true" type="java.lang.Object" %>

<c:set var="hasValidFeatures" value="false"/>

<c:forEach items="${classification.features}" var="feature">
  <c:forEach items="${feature.featureValues}" var="value" varStatus="status">
    <c:if test="${not empty value.value && value.value ne '-'}">
      <c:choose>
        <c:when test="${classification.code eq 'productPackingInfo'}">
          <c:if test="${value.value ne true}">
            <c:set var="hasValidFeatures" value="true"/>
          </c:if>
        </c:when>
        <c:otherwise>
          <c:set var="hasValidFeatures" value="true"/>
        </c:otherwise>
      </c:choose>  
    </c:if>
  </c:forEach>
</c:forEach>

<c:choose>
    <c:when test="${hasValidFeatures}">true</c:when>
    <c:otherwise>false</c:otherwise>
</c:choose>