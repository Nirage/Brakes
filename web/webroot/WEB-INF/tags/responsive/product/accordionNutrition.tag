<%@ attribute name="classification" required="true" type="java.lang.Object" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div class="accordion__title--right-text">
       <c:forEach items="${classification.features}" var="feature">
          <c:if test="${fn:contains(feature.code, 'nutrition_unit')}">
                <c:forEach items="${feature.featureValues}" var="value" varStatus="status">
                     <c:set var="nutrition_unit" value="${value.value}"/>
                </c:forEach>
          </c:if>
        </c:forEach>
        <c:choose>
            <c:when test="${not empty nutrition_unit && nutrition_unit ne '-'}">
                ${nutrition_unit}
            </c:when>
            <c:otherwise>
                 <spring:theme code="accordion.nutrition.table"/>
            </c:otherwise>
        </c:choose>
</div>
<table class="accordion__table table">
  <c:forEach items="${classification.features}" var="feature">
    <c:set var="featureName" value=""/>
    <c:forEach items="${feature.featureValues}" var="value" varStatus="status">
    <c:choose>
      <c:when test="${value.value eq true}">
         <c:set var="featureName" value="${feature.name}"/>
         <c:set var="booleanFeature" value="true"/>
      </c:when>
      <c:when test="${value.value ne 'true' && value.value ne 'false' && value.value ne '' && value.value ne '-'}">
        <c:set var="featureName" value="${value.value}"/>
        <c:set var="booleanFeature" value="false"/>
      </c:when>
       </c:choose>
    </c:forEach>

    <c:if test="${featureName ne '' && !fn:contains(feature.code, 'nutrition_unit') && !fn:contains(feature.code, 'per_serve')}">
      <tr>
        <th>${feature.name}</th>
        <td class="text-right">
          <c:if test="${booleanFeature ne 'true'}">
          ${featureName}
          </c:if>
        </td>
      </tr>
    </c:if>
  </c:forEach>
</table>